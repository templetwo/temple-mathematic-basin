"""T1 candidate terms. Strings only — no Lean import from this file.

These are *types* (Prop terms) for verdict.py's term parser, not .lean command files.
"""

from __future__ import annotations

# Cap-set lower bound: beat the boolean cube in (ZMod 3)^n, n ≥ 3.
# lake env lean #check (2026-08-12): elaborates as Prop.
CAP_SET_BEAT_CUBE = """
∃ (n : ℕ) (A : Finset (Fin n → ZMod 3)),
  3 ≤ n ∧
  (∀ a ∈ A, ∀ b ∈ A, ∀ c ∈ A,
    a ≠ b → b ≠ c → a ≠ c → a + c ≠ (2 : ℕ) • b) ∧
  A.card > 2 ^ n
""".strip()

# Control: universe-polymorphic via Type*. lake env lean elaborates this;
# verdict.py thmDecl (levelParams := []) should then hit undefined universe.
UNIVERSE_CONTROL = """
∀ {α : Type*} [AddCommMonoid α] (a b : α), a + b = b + a
""".strip()

CANDIDATES = {
    "cap_set_beat_cube": CAP_SET_BEAT_CUBE,
    "universe_control": UNIVERSE_CONTROL,
}
