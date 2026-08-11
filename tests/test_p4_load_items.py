"""P4 preflight: load_items strata without calling Lean."""
from __future__ import annotations

import unittest
from pathlib import Path

from sweep import load_items, load_parents

REPO = Path(__file__).resolve().parents[1]
PAIRS = REPO / "corpus" / "pairs.jsonl"


@unittest.skipUnless(PAIRS.exists(), "corpus/pairs.jsonl missing")
class LoadItemsTests(unittest.TestCase):
    def test_true_matches_load_parents(self) -> None:
        self.assertEqual(load_items(PAIRS, stratum="TRUE"), load_parents(PAIRS))

    def test_refutable_only_certified_mutants(self) -> None:
        items = load_items(PAIRS, stratum="REFUTABLE")
        self.assertGreater(len(items), 0)
        for it in items:
            self.assertEqual(it["stratum"], "REFUTABLE")
            self.assertEqual(it["ground_truth"], "REFUTABLE")
            self.assertTrue(it.get("mutation_op"))
            self.assertTrue(str(it["item_id"]).startswith("refutable_"))

    def test_refutable_skips_shortfalls(self) -> None:
        import json
        pairs = [json.loads(l) for l in PAIRS.read_text().splitlines() if l.strip()]
        certified = sum(1 for p in pairs if p.get("mutant"))
        self.assertEqual(len(load_items(PAIRS, stratum="REFUTABLE")), certified)

    def test_both_counts(self) -> None:
        import json
        pairs = [json.loads(l) for l in PAIRS.read_text().splitlines() if l.strip()]
        n_true = len(pairs)
        n_ref = sum(1 for p in pairs if p.get("mutant"))
        self.assertEqual(len(load_items(PAIRS, stratum="BOTH")), n_true + n_ref)

    def test_bad_stratum(self) -> None:
        with self.assertRaises(ValueError):
            load_items(PAIRS, stratum="FALSE")


if __name__ == "__main__":
    unittest.main()
