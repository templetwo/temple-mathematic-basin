"""The for loop (spec §12 P2): items × samples → sample → certify → record.

Every (item, sample_idx) slot appends exactly one §10 record to the day's
runs/ jsonl, whatever happens: a kernel-certified answer, an UNKNOWN
abstention, a malformed response, a refusal, a transport failure after
retries, or an internal bug in this very pipeline (recorded as
MALFORMED internal:<type>, never raised past the slot). The only aborts are
deliberate: FatalTransportError on auth/endpoint misconfiguration, before
money is spent on a sweep that measures nothing.

Records are appended incrementally as certification completes, under a lock,
so a crash mid-sweep loses at most in-flight samples — runs/ is receipts and
receipts survive. Read-time ordering comes from (item_id, sample_idx) fields.

The pinned toolchain and Mathlib commit are READ from lean/lean-toolchain and
lean/lake-manifest.json at startup, so records attest what the kernel
actually runs, not what a constant remembers.

Certification warms the pinned Lake environment with one serial call before
the parallel workers start (README: prepare the environment before running
concurrent checks).

Aggregation does NOT happen here: committed and certified stances are derived
by analyze.py from the four sample records, so the 3-of-4 rule lives in one
place (spec §10).
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
import threading
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone
from pathlib import Path

from arms import ChatCompletionsArm, FatalTransportError, check_drift, parse_response
from verdict import verdict

REPO_ROOT = Path(__file__).resolve().parent
SAMPLES_PER_ITEM = 4


def pinned_toolchain() -> str:
    return (REPO_ROOT / "lean" / "lean-toolchain").read_text(encoding="utf-8").strip()


def pinned_mathlib_commit() -> str:
    manifest = json.loads((REPO_ROOT / "lean" / "lake-manifest.json").read_text(encoding="utf-8"))
    for package in manifest["packages"]:
        if package.get("name") == "mathlib":
            return package["rev"]
    raise RuntimeError("mathlib not found in lake-manifest.json")


def load_parents(pairs_path: Path) -> list[dict]:
    parents = []
    with pairs_path.open(encoding="utf-8") as fh:
        for line in fh:
            if line.strip():
                pair = json.loads(line)
                parents.append(pair["parent"] | {"pair_id": pair["pair_id"]})
    return parents


def spec_commit() -> str:
    head = subprocess.run(
        ["git", "-C", str(REPO_ROOT), "rev-parse", "HEAD"],
        capture_output=True, text=True, check=True,
    ).stdout.strip()
    dirty = subprocess.run(
        ["git", "-C", str(REPO_ROOT), "status", "--porcelain", "--untracked-files=no"],
        capture_output=True, text=True, check=True,
    ).stdout.strip()
    return f"{head}+dirty" if dirty else head


def build_prompt(template: str, statement: str) -> str:
    return template.replace("{{PROPOSITION}}", statement)


def run_sweep(
    *,
    arm: ChatCompletionsArm,
    parents: list[dict],
    template: str,
    out_path: Path,
    run_id: str,
    commit: str,
    sample_workers: int,
    lean_workers: int,
    price_in_per_mtok: float | None = None,
    price_out_per_mtok: float | None = None,
) -> list[dict]:
    lean_toolchain = pinned_toolchain()
    mathlib_commit = pinned_mathlib_commit()
    project_dir = REPO_ROOT / "lean"
    slots = [(item, idx) for item in parents for idx in range(SAMPLES_PER_ITEM)]

    def do_sample(slot):
        item, idx = slot
        try:
            raw = arm.sample(build_prompt(template, item["statement"]))
            return (item, idx, raw, None)
        except FatalTransportError:
            raise
        except Exception as exc:  # pipeline bug: record it, never drop the slot
            return (item, idx, None, f"internal:{type(exc).__name__}")

    with ThreadPoolExecutor(max_workers=sample_workers) as pool:
        sampled = list(pool.map(do_sample, slots))

    # Warm the pinned Lake environment serially before concurrent certification
    # (README protocol; also surfaces environment breakage before the queue).
    warmup = verdict("True", "PROVABLE", "by trivial", project_dir=project_dir)
    if warmup.status.value != "ACCEPT":
        raise RuntimeError(f"lean environment warmup failed: {warmup.reject_reason}")

    records: list[dict] = []
    write_lock = threading.Lock()
    out_path.parent.mkdir(exist_ok=True)
    out_file = out_path.open("a", encoding="utf-8")

    def cost_usd(tokens_in, tokens_out):
        if price_in_per_mtok is None or price_out_per_mtok is None:
            return None
        if tokens_in is None or tokens_out is None:
            return None
        return round((tokens_in * price_in_per_mtok + tokens_out * price_out_per_mtok) / 1e6, 6)

    def do_certify(entry):
        item, idx, raw, internal_error = entry
        lean_ms = None
        if internal_error is not None:
            stance_claimed, reject_reason, kernel_result, axioms = (
                "MALFORMED", internal_error, None, [])
        elif raw.error is not None:
            stance_claimed, reject_reason, kernel_result, axioms = (
                "MALFORMED", raw.error, None, [])
        else:
            parsed = parse_response(raw.content)
            if parsed.malformed_reason is not None:
                stance_claimed, reject_reason, kernel_result, axioms = (
                    "MALFORMED", f"malformed:{parsed.malformed_reason}", None, [])
            else:
                try:
                    import time as _time

                    t0 = _time.monotonic()
                    result = verdict(
                        item["statement"], parsed.stance, parsed.proof_body,
                        project_dir=project_dir,
                    )
                    lean_ms = int((_time.monotonic() - t0) * 1000)
                    stance_claimed = parsed.stance
                    kernel_result = result.status.value
                    reject_reason = result.reject_reason
                    axioms = list(result.axioms)
                except Exception as exc:  # certification bug: record, don't drop
                    stance_claimed, reject_reason, kernel_result, axioms = (
                        "MALFORMED", f"internal:{type(exc).__name__}", None, [])

        record = {
            "run_id": run_id,
            "spec_commit": commit,
            "item_id": item["item_id"],
            "pair_id": item["pair_id"],
            "stratum": item["stratum"],
            "mutation_op": None,
            "ground_truth": item["ground_truth"],
            "arm": arm.arm_name,
            "arm_role": "primary",
            "model_requested": arm.model,
            "model_string_served": raw.model_string_served if raw else None,
            "temperature": arm.temperature,
            "sample_idx": idx,
            "stance_claimed": stance_claimed,
            "kernel_result": kernel_result,
            "reject_reason": reject_reason,
            "axioms": axioms,
            "lean_toolchain": lean_toolchain,
            "mathlib_commit": mathlib_commit,
            "tokens_in": raw.tokens_in if raw else None,
            "tokens_out": raw.tokens_out if raw else None,
            "cost_usd": cost_usd(raw.tokens_in, raw.tokens_out) if raw else None,
            "wall_ms": raw.wall_ms if raw else None,
            "lean_wall_ms": lean_ms,
        }
        with write_lock:
            out_file.write(json.dumps(record, ensure_ascii=False) + "\n")
            out_file.flush()
            records.append(record)
        return record

    try:
        with ThreadPoolExecutor(max_workers=lean_workers) as pool:
            list(pool.map(do_certify, sampled))
    finally:
        out_file.close()

    expected = len(parents) * SAMPLES_PER_ITEM
    if len(records) != expected:
        raise AssertionError(f"record count {len(records)} != expected {expected}")
    return records


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--model", required=True)
    parser.add_argument("--arm", default="family-x")
    parser.add_argument("--temperature", type=float, default=0.7)
    parser.add_argument(
        "--endpoint", default="https://api.x.ai/v1/chat/completions",
        help="OpenAI-compatible chat-completions endpoint",
    )
    parser.add_argument(
        "--key-env", default="XAI_API_KEY",
        help="environment variable holding the API key for --endpoint",
    )
    parser.add_argument("--pairs", default=str(REPO_ROOT / "corpus" / "pairs.jsonl"))
    parser.add_argument("--sample-workers", type=int, default=4)
    parser.add_argument("--lean-workers", type=int, default=4)
    parser.add_argument("--limit", type=int, default=None, help="first N items only (smoke)")
    parser.add_argument("--price-in", type=float, default=None,
                        help="USD per 1M input tokens; enables cost_usd receipts")
    parser.add_argument("--price-out", type=float, default=None,
                        help="USD per 1M output tokens; enables cost_usd receipts")
    args = parser.parse_args()

    import os

    api_key = os.environ.get(args.key_env)
    if not api_key:
        print(f"{args.key_env} not set", file=sys.stderr)
        return 2

    arm = ChatCompletionsArm(
        arm_name=args.arm,
        model=args.model,
        api_key=api_key,
        temperature=args.temperature,
        endpoint=args.endpoint,
    )
    parents = load_parents(Path(args.pairs))
    if args.limit:
        parents = parents[: args.limit]
    template = (REPO_ROOT / "prompt.txt").read_text(encoding="utf-8")
    now = datetime.now(timezone.utc)
    run_id = now.strftime("%Y-%m-%dT%H:%M:%SZ")
    out_path = REPO_ROOT / "runs" / f"{now.strftime('%Y-%m-%d')}.jsonl"

    try:
        records = run_sweep(
            arm=arm,
            parents=parents,
            template=template,
            out_path=out_path,
            run_id=run_id,
            commit=spec_commit(),
            sample_workers=args.sample_workers,
            lean_workers=args.lean_workers,
            price_in_per_mtok=args.price_in,
            price_out_per_mtok=args.price_out,
        )
    except FatalTransportError as exc:
        print(f"SWEEP ABORTED (no records written for this run): {exc}", file=sys.stderr)
        return 4

    served = [r["model_string_served"] for r in records]
    try:
        check_drift(served)
    except Exception as exc:
        print(f"SWEEP INVALIDATED: {exc}", file=sys.stderr)
        return 3

    malformed = sum(1 for r in records if r["stance_claimed"] == "MALFORMED")
    accepts = sum(1 for r in records if r["kernel_result"] == "ACCEPT")
    total_cost = sum(r["cost_usd"] or 0 for r in records)
    print(f"run_id={run_id} records={len(records)} malformed={malformed} "
          f"kernel_accepts={accepts} cost_usd={round(total_cost, 4) if total_cost else 'n/a'}")
    print(f"appended to {out_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
