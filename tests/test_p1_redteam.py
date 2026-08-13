"""P1 redteam fixture (spec §12 P1).

Gate: twenty items in corpus/pairs.jsonl with the parent side populated, all of
which passed with their real proofs first. Redteam: a stripped item whose
original proof is re-supplied must ACCEPT; one with a single tactic deleted
must REJECT.

The fixture item is chosen deterministically: the first pair whose parent proof
is a `by` block with at least two deletable tactic lines. Both redteam probes
run through the real verdict() gate against the live Lean environment.
"""

from __future__ import annotations

import json
import unittest
from pathlib import Path

from verdict import VerdictStatus, verdict

REPO_ROOT = Path(__file__).resolve().parents[1]
PROJECT_DIR = REPO_ROOT / "lean"
PAIRS_PATH = REPO_ROOT / "corpus" / "pairs.jsonl"

LEAN_TOOLCHAIN = "leanprover/lean4:v4.32.2"
MATHLIB_COMMIT = "905b95818eb32af7874a58b427f50c1711a5e96c"


def _load_pairs() -> list[dict]:
    with PAIRS_PATH.open(encoding="utf-8") as fh:
        return [json.loads(line) for line in fh if line.strip()]


def _tactic_lines(proof_body: str) -> list[str]:
    """Indices of nonempty tactic lines inside a multi-line `by` block."""
    lines = proof_body.splitlines()
    return [line for line in lines[1:] if line.strip()] if len(lines) > 1 else []


def _fixture_pair(pairs: list[dict]) -> dict:
    for pair in pairs:
        body = pair["parent"]["proof_body"]
        if "by" in body and len(_tactic_lines(body)) >= 2:
            return pair
    raise AssertionError("no pair with a >=2-tactic `by` proof; corpus cannot host the fixture")


def _delete_last_tactic(proof_body: str) -> str:
    lines = proof_body.splitlines()
    for i in range(len(lines) - 1, 0, -1):
        if lines[i].strip():
            return "\n".join(lines[:i] + lines[i + 1 :])
    raise AssertionError("no deletable tactic line")


class P1GateTests(unittest.TestCase):
    def test_pairs_has_twenty_populated_parents(self) -> None:
        # P1's gate was twenty populated parents. P3 grew the corpus to 105,
        # which the equality assertion read as a failure — the gate is a
        # floor, not a census (stale-test fix, V0 2026-08-12).
        pairs = _load_pairs()
        self.assertGreaterEqual(len(pairs), 20)
        seen_ids = set()
        for pair in pairs:
            parent = pair["parent"]
            seen_ids.add(pair["pair_id"])
            self.assertEqual(parent["stratum"], "TRUE")
            self.assertEqual(parent["ground_truth"], "PROVABLE")
            self.assertTrue(parent["statement"].strip())
            self.assertTrue(parent["proof_body"].strip())
            cert = parent["certificate"]
            self.assertEqual(cert["kernel_result"], "ACCEPT")
            self.assertEqual(cert["lean_toolchain"], LEAN_TOOLCHAIN)
            self.assertEqual(cert["mathlib_commit"], MATHLIB_COMMIT)
            # P1-era pairs carried mutant: null; P3 populated 66 of them.
            # The P1 gate is about parents — mutant validation is the P3
            # fixture's job (stale-test fix, V0 2026-08-12).
            if pair["mutant"] is not None:
                self.assertEqual(pair["mutant"]["stratum"], "REFUTABLE")
        self.assertGreaterEqual(len(seen_ids), 20)
        self.assertEqual(len(seen_ids), len(pairs))


class P1RedteamFixtureTests(unittest.TestCase):
    def test_resupplied_original_proof_accepts(self) -> None:
        pair = _fixture_pair(_load_pairs())
        parent = pair["parent"]
        result = verdict(
            parent["statement"], "PROVABLE", parent["proof_body"], project_dir=PROJECT_DIR
        )
        self.assertEqual(
            result.status,
            VerdictStatus.ACCEPT,
            f"pair {pair['pair_id']} original proof no longer accepts: "
            f"{result.reject_reason}\n{result.compile_log[-400:]}",
        )
        self.assertEqual(list(result.axioms), parent["certificate"]["axioms"])

    def test_single_tactic_deleted_rejects(self) -> None:
        pair = _fixture_pair(_load_pairs())
        parent = pair["parent"]
        broken = _delete_last_tactic(parent["proof_body"])
        result = verdict(parent["statement"], "PROVABLE", broken, project_dir=PROJECT_DIR)
        self.assertEqual(
            result.status,
            VerdictStatus.REJECT,
            f"pair {pair['pair_id']}: deleting a tactic still ACCEPTs; "
            "fixture item does not exercise the gate",
        )


if __name__ == "__main__":
    unittest.main()
