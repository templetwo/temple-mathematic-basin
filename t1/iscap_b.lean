import Mathlib

/-!
# IsCap-B (mbp-grok, commit-reveal)

Blind formalization of the informal sentence in `t1/QUESTION.md`:

    a set containing no three distinct elements x, y, z with
    x + y + z = 0 is a cap.

Source is that English, not the elaborated AP term in the same file.
Sealed until both seats post sha256 and reveal. Not a witness.
-/

/-- Cap predicate B: no three distinct members sum to `0`. -/
def IsCapB {n : ℕ} (A : Finset (Fin n → ZMod 3)) : Prop :=
  ∀ x ∈ A, ∀ y ∈ A, ∀ z ∈ A,
    x ≠ y → y ≠ z → x ≠ z → x + y + z ≠ 0

instance instDecidableIsCapB {n : ℕ} (A : Finset (Fin n → ZMod 3)) :
    Decidable (IsCapB A) := by
  dsimp [IsCapB]
  infer_instance

/-! ## Char-3 battery (seed)

`x + x + x = 0` for every point. Distinctness is load-bearing:
without it the predicate is false on every nonempty set.
Dropping one inequality cannot manufacture a mixed triple.
-/

lemma zmod3_add_add_self (a : ZMod 3) : a + a + a = 0 := by
  have : (1 + 1 + 1 : ZMod 3) * a = 0 := by
    rw [show (1 + 1 + 1 : ZMod 3) = 0 from rfl, zero_mul]
  simpa [add_mul, one_mul] using this

lemma point_add_add_self {n : ℕ} (x : Fin n → ZMod 3) : x + x + x = 0 := by
  ext i
  exact zmod3_add_add_self (x i)

/-- Control, labeled `decide`-free: the char-3 identity is algebraic. -/
theorem no_distinctness_is_false {n : ℕ} {A : Finset (Fin n → ZMod 3)}
    (hA : A.Nonempty) :
    ¬ (∀ x ∈ A, ∀ y ∈ A, ∀ z ∈ A, x + y + z ≠ 0) := by
  obtain ⟨x, hx⟩ := hA
  intro h
  exact h x hx x hx x hx (point_add_add_self x)

lemma zmod3_eq_of_add_double (a b : ZMod 3) (h : a + b + b = 0) : a = b := by
  decide +revert -- labeled: finite case-split on ZMod 3

lemma eq_of_add_double {n : ℕ} {x y : Fin n → ZMod 3}
    (h : x + y + y = 0) : x = y := by
  ext i
  exact zmod3_eq_of_add_double (x i) (y i) (congrFun h i)

/-- Dropping `y ≠ z` does not admit a new sum-zero triple:
if `y = z` then char 3 forces `x = y`. -/
theorem drop_one_inequality_no_new_triples {n : ℕ}
    (x y z : Fin n → ZMod 3)
    (hxy : x ≠ y) (_hxz : x ≠ z) (hsum : x + y + z = 0) :
    y ≠ z := by
  intro hyz
  subst hyz
  exact hxy (eq_of_add_double hsum)

/-! ## S2 control — kernel `¬IsCapB` with a named triple

A 9-point non-cap: the affine plane `p 0 = 0` in `(ℤ/3ℤ)³`.
Violating triple (named in the proof term):
`![0,0,0]`, `![0,1,0]`, `![0,2,0]`.
`decide` appears only on closed numeric goals, labeled.
-/

def s2NonCap : Finset (Fin 3 → ZMod 3) :=
  Finset.univ.filter (fun p : Fin 3 → ZMod 3 => p 0 = 0)

theorem s2_card : s2NonCap.card = 9 := by
  decide -- labeled: control card, closed numeral

private theorem s2_mem_of_coord (p : Fin 3 → ZMod 3) (hp : p 0 = 0) :
    p ∈ s2NonCap := by
  simp [s2NonCap, hp]

private def t0 : Fin 3 → ZMod 3 := ![0, 0, 0]
private def t1 : Fin 3 → ZMod 3 := ![0, 1, 0]
private def t2 : Fin 3 → ZMod 3 := ![0, 2, 0]

theorem s2_named_triple_in :
    t0 ∈ s2NonCap ∧ t1 ∈ s2NonCap ∧ t2 ∈ s2NonCap := by
  refine ⟨s2_mem_of_coord t0 ?_, s2_mem_of_coord t1 ?_, s2_mem_of_coord t2 ?_⟩
  · decide -- labeled: t0 first coord
  · decide -- labeled: t1 first coord
  · decide -- labeled: t2 first coord

theorem s2_named_triple_distinct : t0 ≠ t1 ∧ t1 ≠ t2 ∧ t0 ≠ t2 := by
  decide -- labeled: closed vector inequalities

theorem s2_named_triple_sums_to_zero : t0 + t1 + t2 = 0 := by
  decide -- labeled: closed vector sum in char 3

theorem s2_not_cap : ¬ IsCapB s2NonCap := by
  intro h
  have hsum : t0 + t1 + t2 ≠ 0 :=
    h t0 s2_named_triple_in.1
      t1 s2_named_triple_in.2.1
      t2 s2_named_triple_in.2.2
      s2_named_triple_distinct.1
      s2_named_triple_distinct.2.1
      s2_named_triple_distinct.2.2
  exact hsum s2_named_triple_sums_to_zero

/-- S2 inverted: card 9 conjoined with a kernel refutation that
names its violating triple. -/
theorem s2_control : s2NonCap.card = 9 ∧ ¬ IsCapB s2NonCap :=
  ⟨s2_card, s2_not_cap⟩
