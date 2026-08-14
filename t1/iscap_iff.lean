import Mathlib

/-!
# The kernel Iff — closing the dual-formalization control (criterion 2)

Both `IsCap` formalizations were written blind from `t1/QUESTION.md`'s
English under commit-reveal (board #17891/#17894/#17896/#17898;
commitments af6e583b… / 731cc87a…, both verified in-tree).

This file is SELF-CONTAINED: the two definitions below are byte-copies
of the def-blocks in `t1/iscap_a.lean` and `t1/iscap_b.lean` (checked
by `scripts/check_iff_defs.py`; single-source honesty is enforced by
that byte-identity check, since these standalone files cannot import
one another without a lake package).

Three equivalences, in ascending strength:
1. `a_iff_b` — the two blind predicates are definitionally equal at
   `n = 3`. Recorded even though it is `Iff.rfl`, because *that* is the
   finding: two seats, two vendors, one English sentence, one formula.
2. `sum_zero_iff_ap` — the char-3 identity `x+y+z = 0 ↔ x+z = 2•y`,
   proven pointwise by labeled `decide` over `ZMod 3`.
3. `b_iff_frozen` — the blind predicates are equivalent to the FROZEN
   term's AP-form condition (`cap_set_beat_cube.lean`, dual-signed
   receipt). This is the non-trivial control: the question's sum form
   and the obligation's AP form provably ask the same thing.

HONESTY CAVEAT, recorded where it binds: the blind protocol controlled
each seat reading the *other's file*. It could not control prior
exposure — both seats had earlier read the AP-form term. Both
nevertheless chose the sum form, which is QUESTION.md's English. The
convergence is evidence about the sentence, not proof of independence
from all shared context.
-/

/-- Byte-copy of `IsCapA` (`t1/iscap_a.lean`, commitment af6e583b…). -/
def IsCapA (A : Finset (Fin 3 → ZMod 3)) : Prop :=
  ∀ x ∈ A, ∀ y ∈ A, ∀ z ∈ A, x ≠ y → y ≠ z → x ≠ z → x + y + z ≠ 0

/-- Byte-copy of `IsCapB` (`t1/iscap_b.lean`, commitment 731cc87a…). -/
def IsCapB {n : ℕ} (A : Finset (Fin n → ZMod 3)) : Prop :=
  ∀ x ∈ A, ∀ y ∈ A, ∀ z ∈ A,
    x ≠ y → y ≠ z → x ≠ z → x + y + z ≠ 0

/-- The FROZEN term's cap condition, AP form, verbatim from
`cap_set_beat_cube.lean` at the dual-signed receipt. -/
def IsCapFrozen (A : Finset (Fin 3 → ZMod 3)) : Prop :=
  ∀ a ∈ A, ∀ b ∈ A, ∀ c ∈ A,
    a ≠ b → b ≠ c → a ≠ c → a + c ≠ (2 : ℕ) • b

/-- 1. The two blind formalizations agree definitionally at `n = 3`. -/
theorem a_iff_b (A : Finset (Fin 3 → ZMod 3)) : IsCapA A ↔ IsCapB A :=
  Iff.rfl

/-- 2. The char-3 bridge: a zero-sum triple is exactly an arithmetic
progression, because `2 • b = -b` in `ZMod 3`. Pointwise by labeled
`decide` (27 closed cases), lifted through the `Pi` instances. -/
theorem sum_zero_iff_ap {n : ℕ} (x y z : Fin n → ZMod 3) :
    x + y + z = 0 ↔ x + z = (2 : ℕ) • y := by
  have point : ∀ a b c : ZMod 3, (a + b + c = 0) ↔ (a + c = (2 : ℕ) • b) := by
    decide -- labeled: closed finite case split
  constructor
  · intro h
    ext i
    exact (point (x i) (y i) (z i)).mp (congrFun h i)
  · intro h
    ext i
    exact (point (x i) (y i) (z i)).mpr (congrFun h i)

/-- 3. The non-trivial kernel Iff: the blind sum-form predicates and the
frozen obligation's AP-form condition are the same property. -/
theorem b_iff_frozen (A : Finset (Fin 3 → ZMod 3)) :
    IsCapB A ↔ IsCapFrozen A := by
  unfold IsCapB IsCapFrozen
  constructor
  · intro h a ha b hb c hc hab hbc hac hap
    exact h a ha b hb c hc hab hbc hac ((sum_zero_iff_ap a b c).mpr hap)
  · intro h x hx y hy z hz hxy hyz hxz hsum
    exact h x hx y hy z hz hxy hyz hxz ((sum_zero_iff_ap x y z).mp hsum)

/-- The full chain, for the record: A ↔ B ↔ Frozen. -/
theorem a_iff_frozen (A : Finset (Fin 3 → ZMod 3)) : IsCapA A ↔ IsCapFrozen A :=
  (a_iff_b A).trans (b_iff_frozen A)
