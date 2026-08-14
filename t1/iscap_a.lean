import Mathlib

/-!
IsCap formalization A — claude-basin-seat, 2026-08-13.
Written blind from t1/QUESTION.md's informal text ONLY:
  "does there exist a set of 9 points containing no three distinct
   elements x, y, z with x + y + z = 0?"
Sealed by sha256 commitment on the seat board before reveal, per the
dual-independent-formalization law (synthesis, permanent law 5).
Also carries this seat's S2 control candidate and the char-3 battery
seed lemmas. `decide` is used in CONTROLS, labeled, per the synthesis
(allowed for Round 1 controls; the result lane is a separate question).
-/

/-- Formalization A of "cap": no three pairwise-distinct elements sum to zero. -/
def IsCapA (A : Finset (Fin 3 → ZMod 3)) : Prop :=
  ∀ x ∈ A, ∀ y ∈ A, ∀ z ∈ A, x ≠ y → y ≠ z → x ≠ z → x + y + z ≠ 0

instance (A : Finset (Fin 3 → ZMod 3)) : Decidable (IsCapA A) := by
  unfold IsCapA; infer_instance

/-- S2 control: a 9-point set that is NOT a cap. It contains the line
    `{0, e₁, 2e₁}`, whose sum is `3·e₁ = 0` in characteristic 3. -/
def sBad : Finset (Fin 3 → ZMod 3) :=
  { ![0,0,0], ![1,0,0], ![2,0,0],
    ![0,1,0], ![0,2,0], ![0,0,1],
    ![0,0,2], ![1,1,0], ![1,0,1] }

/-- Cardinality is CONJOINED, not implied (failure mode 4: Finset dedup). -/
theorem sBad_card : sBad.card = 9 := by decide

/-- S2 INVERTED: a positive kernel refutation with the violating triple
    named in the proof term — `![0,0,0], ![1,0,0], ![2,0,0]`. -/
theorem sBad_not_cap : ¬ IsCapA sBad := by
  intro h
  exact h ![0,0,0] (by decide) ![1,0,0] (by decide) ![2,0,0] (by decide)
    (by decide) (by decide) (by decide) (by decide)

/-- Battery lemma: in `ZMod 3`, every element sums with itself thrice to zero. -/
theorem zmod3_triple_self : ∀ t : ZMod 3, t + t + t = 0 := by decide

/-- Battery 1: dropping ALL distinctness guards makes the cap condition
    false for every nonempty set — `x + x + x = 0` always fires. -/
theorem no_distinctness_false (A : Finset (Fin 3 → ZMod 3)) (hA : A.Nonempty) :
    ¬ (∀ x ∈ A, ∀ y ∈ A, ∀ z ∈ A, x + y + z ≠ 0) := by
  obtain ⟨a, ha⟩ := hA
  intro h
  exact h a ha a ha a ha (funext fun i => zmod3_triple_self (a i))

/-- Battery lemma: two-equal forces all-equal on a zero-sum triple in char 3. -/
theorem zmod3_two_eq (a b : ZMod 3) (h : a + b + a = 0) : b = a := by
  revert h; revert a b; decide

/-- Battery 2: dropping ONE pairwise inequality (here `x ≠ z`) leaves a
    statement still equivalent in strength — a zero-sum triple with
    `x = z` forces `y = x`, so no genuinely new triples are admitted.
    Recorded because the natural S4 mutation misfires here. -/
theorem drop_one_ineq_no_new_triples (x y z : Fin 3 → ZMod 3)
    (hxz : x = z) (hsum : x + y + z = 0) : y = x := by
  subst hxz
  funext i
  have hi := congrFun hsum i
  simpa using zmod3_two_eq (x i) (y i) (by simpa [add_comm, add_assoc, add_left_comm] using hi)
