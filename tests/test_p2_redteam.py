"""P2 redteam fixture (spec §12 P2) plus the aggregation-rule contract.

Redteam: a malformed response and a refusal both land as MALFORMED rather
than crashing or silently dropping. Exercised end-to-end through run_sweep
with a stub arm and a stubbed acceptance surface — every sample slot must
produce exactly one record, and the kernel must never be invoked for a
MALFORMED sample.

No network and no Lean: the arm is a stub and verdict is patched. The live
gate has its own fixtures in test_verdict.py / test_p1_redteam.py.
"""

from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path
from unittest import mock

from arms import (
    ChatCompletionsArm,
    DriftError,
    FatalTransportError,
    RawSample,
    check_drift,
    parse_response,
)
from analyze import certified_sample_stance, committed_stance, report, split_drifted
import sweep


def _raw(content, *, served="model-x-2026-01-01", error=None) -> RawSample:
    return RawSample(
        model_requested="model-x-2026-01-01",
        model_string_served=served,
        content=content,
        tokens_in=10,
        tokens_out=20,
        wall_ms=5,
        error=error,
    )


class ParserTests(unittest.TestCase):
    def test_valid_response_parses(self) -> None:
        parsed = parse_response('{"stance": "PROVABLE", "proof_body": "by trivial", "reasoning": "r"}')
        self.assertIsNone(parsed.malformed_reason)
        self.assertEqual(parsed.stance, "PROVABLE")
        self.assertEqual(parsed.proof_body, "by trivial")

    def test_fenced_response_parses(self) -> None:
        parsed = parse_response('```json\n{"stance": "UNKNOWN", "proof_body": ""}\n```')
        self.assertIsNone(parsed.malformed_reason)
        self.assertEqual(parsed.stance, "UNKNOWN")

    def test_refusal_prose_is_malformed(self) -> None:
        parsed = parse_response("I'm sorry, but I can't help with proving propositions.")
        self.assertEqual(parsed.malformed_reason, "not_json")

    def test_empty_response_is_malformed(self) -> None:
        self.assertEqual(parse_response("").malformed_reason, "empty_response")
        self.assertEqual(parse_response(None).malformed_reason, "empty_response")

    def test_wrong_case_stance_is_malformed(self) -> None:
        parsed = parse_response('{"stance": "provable", "proof_body": "by trivial"}')
        self.assertEqual(parsed.malformed_reason, "invalid_stance")

    def test_json_array_is_malformed(self) -> None:
        self.assertEqual(parse_response("[1, 2]").malformed_reason, "not_object")

    def test_committed_stance_without_proof_is_malformed(self) -> None:
        parsed = parse_response('{"stance": "PROVABLE", "proof_body": "  "}')
        self.assertEqual(parsed.malformed_reason, "empty_proof_body")

    def test_unknown_without_proof_body_is_fine(self) -> None:
        parsed = parse_response('{"stance": "UNKNOWN"}')
        self.assertIsNone(parsed.malformed_reason)

    def test_unknown_with_null_proof_body_is_fine(self) -> None:
        parsed = parse_response('{"stance": "UNKNOWN", "proof_body": null}')
        self.assertIsNone(parsed.malformed_reason)
        self.assertEqual(parsed.stance, "UNKNOWN")
        self.assertEqual(parsed.proof_body, "")


class ProtocolGuardTests(unittest.TestCase):
    def test_temperature_zero_is_refused(self) -> None:
        for bad in (0.0, -0.5):
            with self.assertRaises(ValueError):
                ChatCompletionsArm(
                    arm_name="family-t", model="m", api_key="k", temperature=bad
                )


class AggregationTests(unittest.TestCase):
    def test_three_of_four_commits(self) -> None:
        self.assertEqual(committed_stance(["PROVABLE"] * 3 + ["REFUTABLE"]), "PROVABLE")
        self.assertEqual(committed_stance(["REFUTABLE"] * 4), "REFUTABLE")

    def test_two_one_one_is_unknown(self) -> None:
        self.assertEqual(
            committed_stance(["PROVABLE", "PROVABLE", "REFUTABLE", "UNKNOWN"]), "UNKNOWN"
        )

    def test_malformed_never_contributes(self) -> None:
        self.assertEqual(
            committed_stance(["PROVABLE", "PROVABLE", "MALFORMED", "MALFORMED"]), "UNKNOWN"
        )
        self.assertEqual(
            committed_stance(["PROVABLE", "PROVABLE", "PROVABLE", "MALFORMED"]), "PROVABLE"
        )

    def test_unanimous_abstention_commits_unknown(self) -> None:
        self.assertEqual(committed_stance(["UNKNOWN"] * 4), "UNKNOWN")

    def test_certified_stance_earned_only_by_accept(self) -> None:
        accept = {"kernel_result": "ACCEPT", "stance_claimed": "PROVABLE"}
        reject = {"kernel_result": "REJECT", "stance_claimed": "PROVABLE"}
        malformed = {"kernel_result": None, "stance_claimed": "MALFORMED"}
        self.assertEqual(certified_sample_stance(accept), "PROVABLE")
        self.assertEqual(certified_sample_stance(reject), "UNKNOWN")
        self.assertEqual(certified_sample_stance(malformed), "UNKNOWN")


class DriftTests(unittest.TestCase):
    def test_constant_served_string_passes(self) -> None:
        check_drift(["m-1", "m-1", None, "m-1"])

    def test_drift_raises(self) -> None:
        with self.assertRaises(DriftError):
            check_drift(["m-1", "m-2"])

    def test_analyze_excludes_drifted_run(self) -> None:
        base = {"run_id": "r1", "arm": "family-o"}
        records = [
            base | {"model_string_served": "m-1"},
            base | {"model_string_served": "m-2"},
            {"run_id": "r2", "arm": "family-o", "model_string_served": "m-1"},
        ]
        kept, drifted = split_drifted(records)
        self.assertEqual(drifted, ["r1/family-o"])
        self.assertEqual(len(kept), 1)


def _record(run_id, item_id, stance, kernel=None, *, idx=0, served="m-1"):
    return {
        "run_id": run_id, "arm": "family-t", "stratum": "TRUE", "item_id": item_id,
        "sample_idx": idx, "stance_claimed": stance, "kernel_result": kernel,
        "ground_truth": "PROVABLE", "model_string_served": served,
    }


class ReportTests(unittest.TestCase):
    def _four(self, run_id, item_id, stances):
        return [
            _record(run_id, item_id, s, "ACCEPT" if s == "PROVABLE" else None, idx=i)
            for i, s in enumerate(stances)
        ]

    def test_smoke_plus_full_run_items_both_counted_not_skipped(self) -> None:
        records = (
            self._four("run-smoke", "true_0001", ["PROVABLE"] * 4)
            + self._four("run-full", "true_0001", ["PROVABLE"] * 4)
            + self._four("run-full", "true_0002", ["UNKNOWN"] * 4)
        )
        out = report(records)
        self.assertEqual(out["incomplete_groups"], [])
        arm = out["arms"]["family-t/TRUE"]
        self.assertEqual(arm["items"], 3)
        self.assertAlmostEqual(arm["E1_claimed_accuracy"], 2 / 3, places=3)

    def test_incomplete_group_reported_in_json_not_silently_dropped(self) -> None:
        records = self._four("run-1", "true_0001", ["PROVABLE"] * 4)[:3]
        out = report(records)
        self.assertEqual(len(out["incomplete_groups"]), 1)
        self.assertEqual(out["incomplete_groups"][0]["samples"], 3)
        self.assertEqual(out["arms"], {})

    def test_all_malformed_item_is_not_consistent(self) -> None:
        records = self._four("run-1", "true_0001", ["MALFORMED"] * 4)
        out = report(records)
        arm = out["arms"]["family-t/TRUE"]
        self.assertEqual(arm["consistency"], 0.0)
        self.assertEqual(arm["malformed_rate"], 1.0)


class _StubArm:
    """One item, four samples: valid proof, refusal, malformed JSON, transport error."""

    arm_name = "family-stub"
    model = "model-x-2026-01-01"
    temperature = 0.7

    def __init__(self) -> None:
        self._responses = [
            _raw('{"stance": "PROVABLE", "proof_body": "by trivial"}'),
            _raw("I cannot assist with this request."),
            _raw('{"stance": "MAYBE", "proof_body": "by trivial"}'),
            _raw(None, served=None, error="transport:http_500"),
        ]
        self._lock = __import__("threading").Lock()

    def sample(self, prompt: str) -> RawSample:
        with self._lock:
            return self._responses.pop(0)


class SweepRedteamTests(unittest.TestCase):
    def test_malformed_and_refusal_land_as_records_not_crashes(self) -> None:
        parent = {
            "item_id": "true_0001",
            "pair_id": "0001",
            "stratum": "TRUE",
            "ground_truth": "PROVABLE",
            "statement": "True",
        }
        fake_verdict = mock.Mock()
        fake_verdict.return_value = mock.Mock(
            status=mock.Mock(value="ACCEPT"), reject_reason=None, axioms=(),
            # ab5c19e persists compile_log[:2000]; an unmodeled Mock attribute
            # is unsliceable, and the resulting TypeError was landing the one
            # well-formed sample as a fourth MALFORMED record
            # (stale-fixture fix, V0 2026-08-12).
            compile_log="lean: ok",
        )
        with tempfile.TemporaryDirectory() as tmp:
            out_path = Path(tmp) / "run.jsonl"
            with mock.patch.object(sweep, "verdict", fake_verdict):
                records = sweep.run_sweep(
                    arm=_StubArm(),
                    parents=[parent],
                    template="P: {{PROPOSITION}}",
                    out_path=out_path,
                    run_id="test-run",
                    commit="deadbeef",
                    sample_workers=1,
                    lean_workers=1,
                )
            written = [json.loads(l) for l in out_path.read_text().splitlines()]

        self.assertEqual(len(records), 4)
        self.assertEqual(len(written), 4)
        stances = [r["stance_claimed"] for r in written]
        self.assertEqual(stances.count("MALFORMED"), 3)
        self.assertIn("PROVABLE", stances)
        reasons = {r["reject_reason"] for r in written if r["stance_claimed"] == "MALFORMED"}
        self.assertEqual(reasons, {"malformed:not_json", "malformed:invalid_stance", "transport:http_500"})
        # The kernel ran for the warmup plus the one well-formed committed sample.
        self.assertEqual(fake_verdict.call_count, 2)
        for r in written:
            if r["stance_claimed"] == "MALFORMED":
                self.assertIsNone(r["kernel_result"])
        self.assertEqual({r["sample_idx"] for r in written}, {0, 1, 2, 3})

    def test_internal_sampling_bug_lands_as_record_not_crash(self) -> None:
        class _ExplodingArm(_StubArm):
            def sample(self, prompt):
                raise RuntimeError("pipeline bug")

        parent = {
            "item_id": "true_0001", "pair_id": "0001", "stratum": "TRUE",
            "ground_truth": "PROVABLE", "statement": "True",
        }
        fake_verdict = mock.Mock()
        fake_verdict.return_value = mock.Mock(
            status=mock.Mock(value="ACCEPT"), reject_reason=None, axioms=()
        )
        with tempfile.TemporaryDirectory() as tmp:
            out_path = Path(tmp) / "run.jsonl"
            with mock.patch.object(sweep, "verdict", fake_verdict):
                records = sweep.run_sweep(
                    arm=_ExplodingArm(), parents=[parent], template="{{PROPOSITION}}",
                    out_path=out_path, run_id="r", commit="c",
                    sample_workers=2, lean_workers=1,
                )
        self.assertEqual(len(records), 4)
        self.assertTrue(all(r["stance_claimed"] == "MALFORMED" for r in records))
        self.assertTrue(all(r["reject_reason"] == "internal:RuntimeError" for r in records))

    def test_fatal_transport_error_aborts_instead_of_recording(self) -> None:
        class _FatalArm(_StubArm):
            def sample(self, prompt):
                raise FatalTransportError("HTTP 401")

        parent = {
            "item_id": "true_0001", "pair_id": "0001", "stratum": "TRUE",
            "ground_truth": "PROVABLE", "statement": "True",
        }
        with tempfile.TemporaryDirectory() as tmp:
            out_path = Path(tmp) / "run.jsonl"
            with self.assertRaises(FatalTransportError):
                sweep.run_sweep(
                    arm=_FatalArm(), parents=[parent], template="{{PROPOSITION}}",
                    out_path=out_path, run_id="r", commit="c",
                    sample_workers=2, lean_workers=1,
                )
            self.assertFalse(out_path.exists())


if __name__ == "__main__":
    unittest.main()
