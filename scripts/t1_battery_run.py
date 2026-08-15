#!/usr/bin/env python3
"""Char-3 mutation battery — as a RUN, through trusted verdict.py.

Anthony's 2026-08-15 accounting correction: the compiled seed lemmas in
t1/iscap_{a,b}.lean are staging, not a run, and lake-compiled theorems
are not the goal's currency — the trusted harness is. This runner takes
each battery item as a CLOSED proposition, pushes it through verdict.py
(the same gate the witness must pass), and writes a per-mutant ledger.

Every proposition is universe-monomorphic (n = 3 concrete). Proof
bodies are self-contained (verdict.py compiles them against Mathlib
alone). `decide` appears only on closed ZMod-3 case splits, labeled.

Battery items:
  B1 drop-ALL-distinctness  -> the mutated condition is FALSE on every
     nonempty set (x+x+x = 0 fires); proven positively as a ¬∀.
  B2 guards flipped ≠ -> =  -> equally false, same trap.
  B3 drop-ONE-inequality    -> proven EQUIVALENT to the full-guard
     condition (the synthesis's misfire case, now a kernel Iff).
  B4 sum-form <-> AP-form    -> the char-3 bridge as a closed ∀-Iff
     (mirrors t1/iscap_iff.lean's sum_zero_iff_ap through the harness).

The in-tree S2 controls (¬IsCapA sBad, ¬IsCapB s2NonCap, cards
conjoined) are lake receipts at 348535b and are cross-referenced, not
re-run: their statements mention t1 defs the harness cannot import.

Exit 0 iff every item returns ACCEPT with axioms within the allowlist.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO))

from verdict import verdict  # noqa: E402

PROJECT = REPO / "lean"
OUT = REPO / "t1" / "battery_ledger.json"

ALLOWED = {"propext", "Classical.choice", "Quot.sound"}

V = "Fin 3 → ZMod 3"

ITEMS = [
    (
        "B1_drop_all_distinctness_false",
        f"∀ A : Finset ({V}), A.Nonempty → "
        f"¬ (∀ x ∈ A, ∀ y ∈ A, ∀ z ∈ A, x + y + z ≠ 0)",
        "by\n"
        "  intro A hA h\n"
        "  obtain ⟨a, ha⟩ := hA\n"
        "  refine h a ha a ha a ha (funext fun i => ?_)\n"
        "  have key : ∀ t : ZMod 3, t + t + t = 0 := by decide\n"
        "  exact key (a i)",
    ),
    (
        "B2_guards_flipped_to_eq_false",
        f"∀ A : Finset ({V}), A.Nonempty → "
        f"¬ (∀ x ∈ A, ∀ y ∈ A, ∀ z ∈ A, x = y → y = z → x = z → x + y + z ≠ 0)",
        "by\n"
        "  intro A hA h\n"
        "  obtain ⟨a, ha⟩ := hA\n"
        "  refine h a ha a ha a ha rfl rfl rfl (funext fun i => ?_)\n"
        "  have key : ∀ t : ZMod 3, t + t + t = 0 := by decide\n"
        "  exact key (a i)",
    ),
    (
        "B3_drop_one_inequality_equivalent",
        f"∀ A : Finset ({V}), "
        f"(∀ x ∈ A, ∀ y ∈ A, ∀ z ∈ A, x ≠ y → y ≠ z → x + y + z ≠ 0) ↔ "
        f"(∀ x ∈ A, ∀ y ∈ A, ∀ z ∈ A, x ≠ y → y ≠ z → x ≠ z → x + y + z ≠ 0)",
        "by\n"
        "  intro A\n"
        "  constructor\n"
        "  · intro h x hx y hy z hz hxy hyz _\n"
        "    exact h x hx y hy z hz hxy hyz\n"
        "  · intro h x hx y hy z hz hxy hyz\n"
        "    by_cases hxz : x = z\n"
        "    · subst hxz\n"
        "      intro hsum\n"
        "      have key : ∀ a b : ZMod 3, a + b + a = 0 → b = a := by decide\n"
        "      -- attempt 1 carried a stray outer .symm here: funext already\n"
        "      -- yields x = y, and flipping it broke elaboration (REJECT,\n"
        "      -- sorryAx — preserved in t1/battery_ledger_attempt1.json)\n"
        "      exact hxy (funext fun i => (key (x i) (y i) (congrFun hsum i)).symm)\n"
        "    · exact h x hx y hy z hz hxy hyz hxz",
    ),
    (
        "B4_sum_form_iff_ap_form",
        f"∀ x y z : {V}, x + y + z = 0 ↔ x + z = (2 : ℕ) • y",
        "by\n"
        "  intro x y z\n"
        "  have point : ∀ a b c : ZMod 3, (a + b + c = 0) ↔ (a + c = (2 : ℕ) • b) := by decide\n"
        "  constructor\n"
        "  · intro h\n"
        "    ext i\n"
        "    exact (point (x i) (y i) (z i)).mp (congrFun h i)\n"
        "  · intro h\n"
        "    ext i\n"
        "    exact (point (x i) (y i) (z i)).mpr (congrFun h i)",
    ),
]

CROSS_REFS = [
    {"name": "S2_not_cap_A", "where": "t1/iscap_a.lean sBad_not_cap + sBad_card", "receipt": "lake @ 348535b"},
    {"name": "S2_not_cap_B", "where": "t1/iscap_b.lean s2_control", "receipt": "lake @ 348535b"},
    {"name": "dual_Iff_chain", "where": "t1/iscap_iff.lean a_iff_b / b_iff_frozen", "receipt": "lake @ 348535b"},
]


def main() -> int:
    rows = []
    ok_all = True
    for name, prop, body in ITEMS:
        r = verdict(prop, "PROVABLE", body, project_dir=PROJECT, timeout_seconds=300)
        axioms = list(r.axioms)
        clean = r.status.value == "ACCEPT" and set(axioms) <= ALLOWED
        ok_all &= clean
        rows.append({
            "name": name,
            "proposition": prop,
            "status": r.status.value,
            "reject_reason": r.reject_reason,
            "axioms": axioms,
            "axioms_within_allowlist": set(axioms) <= ALLOWED,
            "log_tail": (r.compile_log or "")[-300:],
        })
        print(f"{name}: {r.status.value} axioms={axioms}")
    ledger = {
        "run": "char-3 mutation battery, trusted-path",
        "harness": "verdict.py, PROVABLE stance, term/tactic bodies, Mathlib-only",
        "items": rows,
        "cross_referenced_lake_receipts": CROSS_REFS,
        "all_accept_within_allowlist": ok_all,
    }
    OUT.write_text(json.dumps(ledger, indent=1, ensure_ascii=False))
    print(f"ledger -> {OUT}  all_accept={ok_all}")
    return 0 if ok_all else 1


if __name__ == "__main__":
    raise SystemExit(main())
