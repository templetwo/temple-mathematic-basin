"""Provider adapters, blind dispatch, model-string drift check (spec §6).

One arm = one model behind one adapter. Blind: the adapter sends exactly the
verbatim prompt it is given, single-shot, no repair loop, no shared context.
Every sample records `model_requested` and `model_string_served` separately;
floating aliases are banned as arm identifiers and served-string drift inside
a sweep invalidates that arm's sweep (spec §6, model-string discipline).

Response parsing is strict but not brittle: the model must return one JSON
object with a valid `stance` and (unless UNKNOWN) a string `proof_body`.
The only normalization applied is stripping surrounding whitespace and one
markdown code fence, because a fence is packaging, not content. Everything
else — prose, refusals, wrong enums, wrong types, truncation — lands as
MALFORMED with a recorded reason, never as a crash and never dropped.
"""

from __future__ import annotations

import json
import random
import time
import urllib.error
import urllib.request
from dataclasses import dataclass

STANCES = ("PROVABLE", "REFUTABLE", "UNKNOWN")

TRANSPORT_RETRIES = 3
RETRY_BACKOFF_SECONDS = 5.0
FATAL_HTTP_CODES = (401, 403, 404)  # config errors, not measurements: abort, don't record


@dataclass(frozen=True)
class RawSample:
    """What came back from the provider, before any interpretation."""

    model_requested: str
    model_string_served: str | None
    content: str | None
    tokens_in: int | None
    tokens_out: int | None
    wall_ms: int
    error: str | None  # None, or "transport:<detail>" after retries exhausted


@dataclass(frozen=True)
class ParsedResponse:
    """The model's answer in stance vocabulary, or MALFORMED with a reason."""

    stance: str | None  # one of STANCES, or None when malformed
    proof_body: str
    malformed_reason: str | None


class DriftError(RuntimeError):
    """Served model string changed mid-sweep; the sweep is invalid (spec §6)."""


class FatalTransportError(RuntimeError):
    """Auth/endpoint misconfiguration (401/403/404): abort the sweep instead of
    appending a full file of MALFORMED records that measure nothing."""


def _strip_one_fence(text: str) -> str:
    stripped = text.strip()
    if stripped.startswith("```") and stripped.endswith("```") and len(stripped) > 6:
        inner = stripped[3:-3]
        first_newline = inner.find("\n")
        if first_newline != -1 and " " not in inner[:first_newline].strip():
            inner = inner[first_newline + 1 :]
        return inner.strip()
    return stripped


def parse_response(content: str | None) -> ParsedResponse:
    """Interpret raw model output against the spec §6 response schema."""
    if content is None or not content.strip():
        return ParsedResponse(None, "", "empty_response")
    try:
        payload = json.loads(_strip_one_fence(content))
    except (json.JSONDecodeError, ValueError):
        return ParsedResponse(None, "", "not_json")
    if not isinstance(payload, dict):
        return ParsedResponse(None, "", "not_object")
    stance = payload.get("stance")
    if stance not in STANCES:
        return ParsedResponse(None, "", "invalid_stance")
    proof_body = payload.get("proof_body")
    if stance == "UNKNOWN":
        # Abstention ignores proof_body (spec §6); tolerate null/missing/any type.
        return ParsedResponse(stance, proof_body if isinstance(proof_body, str) else "", None)
    if not isinstance(proof_body, str):
        return ParsedResponse(None, "", "invalid_proof_body")
    if not proof_body.strip():
        return ParsedResponse(None, "", "empty_proof_body")
    return ParsedResponse(stance, proof_body, None)


class ChatCompletionsArm:
    """OpenAI-compatible chat-completions adapter (OpenAI, xAI, ...). Stdlib only."""

    def __init__(
        self,
        *,
        arm_name: str,
        model: str,
        api_key: str,
        temperature: float,
        endpoint: str = "https://api.openai.com/v1/chat/completions",
        max_completion_tokens: int = 8192,
        timeout_seconds: float = 240,
    ) -> None:
        if not temperature > 0:
            # Spec §6: fixed at one stated value ABOVE ZERO. At temperature 0
            # the four samples collapse and the 3-of-4 rule is vacuous.
            raise ValueError(f"temperature must be > 0 (spec §6), got {temperature}")
        self.arm_name = arm_name
        self.model = model
        self._api_key = api_key
        self.temperature = temperature
        self.endpoint = endpoint
        self.max_completion_tokens = max_completion_tokens
        self.timeout_seconds = timeout_seconds

    def sample(self, prompt: str) -> RawSample:
        body = json.dumps(
            {
                "model": self.model,
                "messages": [{"role": "user", "content": prompt}],
                "temperature": self.temperature,
                "max_completion_tokens": self.max_completion_tokens,
            }
        ).encode()
        last_error = "transport:unknown"
        attempt_ms = 0
        for attempt in range(TRANSPORT_RETRIES):
            request = urllib.request.Request(
                self.endpoint,
                data=body,
                headers={
                    "Authorization": f"Bearer {self._api_key}",
                    "Content-Type": "application/json",
                },
            )
            attempt_start = time.monotonic()
            try:
                with urllib.request.urlopen(request, timeout=self.timeout_seconds) as resp:
                    payload = json.loads(resp.read().decode())
                # wall_ms is the successful attempt's HTTP time only; retry
                # backoff is infrastructure latency, not a model observation.
                attempt_ms = int((time.monotonic() - attempt_start) * 1000)
                choice = payload["choices"][0]
                usage = payload.get("usage", {})
                return RawSample(
                    model_requested=self.model,
                    model_string_served=payload.get("model"),
                    content=choice.get("message", {}).get("content"),
                    tokens_in=usage.get("prompt_tokens"),
                    tokens_out=usage.get("completion_tokens"),
                    wall_ms=attempt_ms,
                    error=None,
                )
            except urllib.error.HTTPError as exc:
                attempt_ms = int((time.monotonic() - attempt_start) * 1000)
                if exc.code in FATAL_HTTP_CODES:
                    raise FatalTransportError(
                        f"{self.endpoint} returned HTTP {exc.code}; sweep aborted"
                    ) from exc
                last_error = f"transport:http_{exc.code}"
                if exc.code not in (429, 500, 502, 503, 504):
                    break
            except (urllib.error.URLError, TimeoutError, OSError, KeyError, IndexError, json.JSONDecodeError) as exc:
                attempt_ms = int((time.monotonic() - attempt_start) * 1000)
                last_error = f"transport:{type(exc).__name__}"
            if attempt < TRANSPORT_RETRIES - 1:
                time.sleep(RETRY_BACKOFF_SECONDS * (attempt + 1) * random.uniform(0.5, 1.5))
        return RawSample(
            model_requested=self.model,
            model_string_served=None,
            content=None,
            tokens_in=None,
            tokens_out=None,
            wall_ms=attempt_ms,
            error=last_error,
        )


def check_drift(served_strings: list[str]) -> None:
    """Raise DriftError if the served model string was not constant."""
    distinct = {s for s in served_strings if s is not None}
    if len(distinct) > 1:
        raise DriftError(f"served model string drifted mid-sweep: {sorted(distinct)}")
