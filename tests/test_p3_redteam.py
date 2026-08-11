"""P3 redteam fixture (spec §12 P3) plus operator and pairing contracts.

Redteam: a mutant that is still TRUE must be rejected by the certification
step. This holds by construction — certification demands a kernel-checked
proof of the mutant's negation, and no such proof exists for a true
statement — and the fixture demonstrates it through the live gate.

Operator tests are pure (deterministic text transforms, no Lean). Pairing
tests stub certification. Two certification tests run the live gate with a
one-rung ladder to bound cost.
"""

from __future__ import annotations

import unittest
from pathlib import Path
from unittest import mock

import mutate
from mutate import (
    candidates_for,
    certify_refutable,
    mutate_corpus,
    op_drop_negation,
    op_eq_to_ne,
    op_flip_monotonicity,
    op_flip_strictness,
    op_histogram,
    op_negate_relation,
    op_perturb_constant,
    rebalance,
)

PROJECT_DIR = Path(__file__).resolve().parents[1] / "lean"


class OperatorTests(unittest.TestCase):
    def test_perturb_constant_hits_each_site_both_directions(self) -> None:
        mutants = op_perturb_constant("catalan 2 = 2")
        self.assertIn("catalan 3 = 2", mutants)
        self.assertIn("catalan 1 = 2", mutants)
        self.assertIn("catalan 2 = 3", mutants)
        self.assertIn("catalan 2 = 1", mutants)

    def test_perturb_constant_never_goes_negative(self) -> None:
        self.assertNotIn("catalan -1 = 0", op_perturb_constant("catalan 0 = 0"))

    def test_flip_strictness_swaps_each_relation(self) -> None:
        mutants = op_flip_strictness("∀ (n : ℕ), n ≤ n + 1")
        self.assertEqual(mutants, ["∀ (n : ℕ), n < n + 1"])

    def test_flip_monotonicity_prefers_longest_match(self) -> None:
        mutants = op_flip_monotonicity("StrictMonoOn pentagonal (Set.Ici 0)")
        self.assertIn("StrictAntiOn pentagonal (Set.Ici 0)", mutants)
        # StrictMonoOn must never be partially rewritten via the StrictMono rule.
        self.assertTrue(all("StrictAntiOn" in m or "StrictMonoOn" not in m or "Mono" in m
                            for m in mutants))
        self.assertNotIn("StrictAntiOn pentagonal (Set.Ici 0)On", " ".join(mutants))

    def test_drop_negation(self) -> None:
        self.assertEqual(op_drop_negation("¬IsField ℤ"), ["IsField ℤ"])
        self.assertEqual(op_drop_negation("IsField ℤ"), [])

    def test_eq_to_ne_spares_lambda_arrows_and_definitions(self) -> None:
        self.assertEqual(op_eq_to_ne("catalan 2 = 2"), ["catalan 2 ≠ 2"])
        self.assertEqual(op_eq_to_ne("(fun x => x) 1"), [])
        self.assertEqual(op_eq_to_ne("a ≠ b"), [])

    def test_negate_relation_produces_negation_class_mutants(self) -> None:
        self.assertEqual(op_negate_relation("∀ (n : ℕ), n ≤ n + 1"),
                         ["∀ (n : ℕ), n > n + 1"])

    def test_candidates_respect_operator_exclusion(self) -> None:
        stmt = "∀ (n : ℕ), n ≤ n + 1"
        ops = {op for op, _ in candidates_for(stmt, 10, frozenset({"negate_relation"}))}
        self.assertNotIn("negate_relation", ops)

    def test_candidates_are_deterministic_deduped_and_capped(self) -> None:
        statement = "∀ (n : ℕ), n ≤ n + 1"
        first = candidates_for(statement, 5)
        second = candidates_for(statement, 5)
        self.assertEqual(first, second)
        self.assertLessEqual(len(first), 5)
        self.assertNotIn(statement, [m for _, m in first])
        self.assertEqual(len({m for _, m in first}), len(first))


class PairingTests(unittest.TestCase):
    def _pair(self):
        return {
            "pair_id": "0001",
            "parent": {"item_id": "true_0001", "statement": "catalan 2 = 2",
                       "proof_body": "by norm_num"},
            "mutant": None,
            "mutation_op": None,
        }

    def test_first_certified_candidate_wins_and_records_operator(self) -> None:
        outcomes = iter([
            {"certified": False, "reason": "refutation_not_found", "attempts": []},
            {"certified": True, "refutation_body": "by norm_num",
             "axioms": [], "wall_ms": 5},
        ])
        with mock.patch.object(mutate, "certify_refutable", lambda *a, **k: next(outcomes)):
            pairs, rejected = mutate_corpus(
                [self._pair()], project_dir=PROJECT_DIR, per_parent_cap=5,
                lean_workers=1, lean_toolchain="tc", mathlib_commit="mc",
                log=lambda *_: None,
            )
        pair = pairs[0]
        self.assertIsNotNone(pair["mutant"])
        self.assertEqual(pair["mutant"]["item_id"], "refutable_0001")
        self.assertEqual(pair["mutant"]["ground_truth"], "REFUTABLE")
        self.assertEqual(pair["mutation_op"], pair["mutant"]["mutation_op"])
        self.assertEqual(len(rejected), 1)
        self.assertEqual(rejected[0]["reason"], "refutation_not_found")

    def test_exhausted_candidates_leave_shortfall_and_full_receipts(self) -> None:
        fail = {"certified": False, "reason": "refutation_not_found", "attempts": []}
        with mock.patch.object(mutate, "certify_refutable", lambda *a, **k: dict(fail)):
            pairs, rejected = mutate_corpus(
                [self._pair()], project_dir=PROJECT_DIR, per_parent_cap=3,
                lean_workers=1, lean_toolchain="tc", mathlib_commit="mc",
                log=lambda *_: None,
            )
        self.assertIsNone(pairs[0]["mutant"])
        self.assertEqual(len(rejected), 3)


class RebalanceTests(unittest.TestCase):
    def _pair(self, pid, op, stmt="x 1 = 1 ∧ y ≤ 2"):
        return {
            "pair_id": pid, "mutation_op": op,
            "parent": {"item_id": f"true_{pid}", "statement": stmt,
                       "proof_body": "by norm_num"},
            "mutant": {"item_id": f"refutable_{pid}", "mutation_op": op},
        }

    def test_dominant_operator_swapped_only_when_alternative_certifies(self) -> None:
        pairs = [self._pair(f"{i:04d}", "perturb_constant") for i in range(1, 5)]
        certify_ok = {"certified": True, "refutation_body": "by norm_num",
                      "axioms": [], "wall_ms": 1}
        with mock.patch.object(mutate, "certify_refutable", lambda *a, **k: dict(certify_ok)):
            rebalanced, _ = rebalance(
                pairs, cap_share=0.5, project_dir=PROJECT_DIR, per_parent_cap=5,
                lean_workers=1, lean_toolchain="tc", mathlib_commit="mc",
                log=lambda *_: None,
            )
        hist = op_histogram(rebalanced)
        self.assertLessEqual(hist.get("perturb_constant", 0), 2)
        self.assertEqual(sum(hist.values()), 4)  # nothing sacrificed

    def test_no_alternative_keeps_certified_pair(self) -> None:
        pairs = [self._pair(f"{i:04d}", "perturb_constant", stmt="Foo bar")
                 for i in range(1, 3)]
        fail = {"certified": False, "reason": "refutation_not_found", "attempts": []}
        with mock.patch.object(mutate, "certify_refutable", lambda *a, **k: dict(fail)):
            rebalanced, _ = rebalance(
                pairs, cap_share=0.4, project_dir=PROJECT_DIR, per_parent_cap=5,
                lean_workers=1, lean_toolchain="tc", mathlib_commit="mc",
                log=lambda *_: None,
            )
        self.assertEqual(sum(op_histogram(rebalanced).values()), 2)


class LiveCertificationRedteamTests(unittest.TestCase):
    def test_still_true_mutant_is_rejected(self) -> None:
        outcome = certify_refutable(
            "(2 : ℕ) + 2 = 4", project_dir=PROJECT_DIR, ladder=("by norm_num",)
        )
        self.assertFalse(outcome["certified"])
        self.assertEqual(outcome["reason"], "refutation_not_found")
        self.assertEqual(len(outcome["attempts"]), 1)

    def test_false_mutant_certifies_with_negation_proof(self) -> None:
        outcome = certify_refutable(
            "(2 : ℕ) + 2 = 5", project_dir=PROJECT_DIR, ladder=("by norm_num",)
        )
        self.assertTrue(outcome["certified"])
        self.assertEqual(outcome["refutation_body"], "by norm_num")

    def test_malformed_mutation_is_reported_as_malformed_not_unrefuted(self) -> None:
        outcome = certify_refutable(
            "(2 : ℕ) + = 5", project_dir=PROJECT_DIR, ladder=("by norm_num",)
        )
        self.assertFalse(outcome["certified"])
        self.assertEqual(outcome["reason"], "malformed_statement")


if __name__ == "__main__":
    unittest.main()
