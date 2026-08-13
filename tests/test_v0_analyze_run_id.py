"""V0 debt 1 (spec §18.11.1): the tool that made the record reproduces the record.

Two halves. Synthetic tests pin the new run_id mechanics: the "run_ids"
summary makes cross-run pooling visible, and filtering to one run_id yields
that run alone. Regression tests then assert the actual recorded figures
against the committed run files, so the gate "the record reproduces itself"
is executable rather than asserted.

No Lean, no network.
"""

from __future__ import annotations

import unittest
from pathlib import Path

from analyze import load_records, report

REPO = Path(__file__).resolve().parent.parent


def _record(run_id, item_id, stance, kernel=None, *, idx=0):
    return {
        "run_id": run_id, "arm": "family-t", "stratum": "TRUE", "item_id": item_id,
        "sample_idx": idx, "stance_claimed": stance, "kernel_result": kernel,
        "ground_truth": "PROVABLE", "model_string_served": "m-1",
    }


def _four(run_id, item_id, stances):
    return [
        _record(run_id, item_id, s, "ACCEPT" if s == "PROVABLE" else None, idx=i)
        for i, s in enumerate(stances)
    ]


class RunIdVisibilityTests(unittest.TestCase):
    def test_run_ids_summary_counts_every_run(self) -> None:
        records = (
            _four("run-smoke", "true_0001", ["PROVABLE"] * 4)
            + _four("run-full", "true_0001", ["PROVABLE"] * 4)
        )
        out = report(records)
        self.assertEqual(out["run_ids"], {"run-full": 4, "run-smoke": 4})

    def test_filtering_to_one_run_id_drops_the_other(self) -> None:
        records = (
            _four("run-smoke", "true_0001", ["PROVABLE"] * 4)
            + _four("run-full", "true_0001", ["PROVABLE"] * 4)
            + _four("run-full", "true_0002", ["UNKNOWN"] * 4)
        )
        filtered = [r for r in records if r["run_id"] == "run-full"]
        out = report(filtered)
        self.assertEqual(out["run_ids"], {"run-full": 8})
        self.assertEqual(out["arms"]["family-t/TRUE"]["items"], 2)


class RecordedFigureRegressionTests(unittest.TestCase):
    """The numbers in the record, reproduced from the committed run files.

    These are the exact figures carried by the P4 gate record and the P2
    close (per-item, 3-of-4 committed stance, single run_id). If this test
    fails, either the data or the estimator changed, and whichever it was
    must be recorded, not patched.
    """

    def _arm(self, filename: str, run_id: str, key: str) -> dict:
        records = load_records([REPO / "runs" / filename])
        records = [r for r in records if r["run_id"] == run_id]
        out = report(records)
        self.assertEqual(out["drift_excluded"], [])
        self.assertEqual(out["incomplete_groups"], [])
        return out["arms"][key]

    def test_p4_gate_family_x_refutable(self) -> None:
        arm = self._arm(
            "2026-08-11.jsonl", "2026-08-11T07:49:50Z", "family-x/REFUTABLE"
        )
        self.assertEqual(arm["items"], 66)
        self.assertEqual(arm["E1_claimed_accuracy"], 0.9242)
        self.assertEqual(arm["E1_certified_accuracy"], 0.5758)

    def test_p4_smoke_run_is_two_items_not_pooled(self) -> None:
        arm = self._arm(
            "2026-08-11.jsonl", "2026-08-11T07:44:49Z", "family-x/REFUTABLE"
        )
        self.assertEqual(arm["items"], 2)

    def test_p2_true_stratum_family_x(self) -> None:
        arm = self._arm("2026-08-09.jsonl", "2026-08-09T02:33:03Z", "family-x/TRUE")
        self.assertEqual(arm["items"], 20)
        self.assertEqual(arm["E1_claimed_accuracy"], 0.75)
        self.assertEqual(arm["E1_certified_accuracy"], 0.1)


if __name__ == "__main__":
    unittest.main()
