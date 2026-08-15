import Mathlib

/-!
# Rung 1 · constriction — what "stretching wins, in a model" MEANS in Lean

Rung 1's gap is 1(b): the finite-time blow-up of the inviscid dyadic cascade
(Katz–Pavlović 2005 prove it for their infinite model; ours is finite-N — see
SCOPE.md, the citation is cited not checked). The proof is weeks and its own
selection. The CONSTRICTION today is to fix the STATEMENT so the target cannot
drift, and to certify the cheapest true fact toward it.

Solution concept — first time-dependent object in Alpha 2:
  a trajectory `a : ℝ → (Fin N → ℝ)` solves the model on `[0,T)` iff
  `∀ t ∈ Ico 0 T, HasDerivAt a (field ν λ (a t)) t`.
Mathlib's `HasDerivAt` on `ℝ → (Fin N → ℝ)` — exists in the pinned library.

Blow-up — of a CRITICAL-TYPE norm, per the trunk's framing:
  `H(a) := Σₙ λ^{2n} aₙ²` (the model's dissipation-weighted norm; the analogue
  of the Ḣ¹ / critical shell norm KP use). Blow-up on `[0,T)` iff `H(a t)` is
  unbounded as `t → T⁻`.

**IMPORTANT HONESTY about finite N.** In a FINITE dyadic model, the ODE is
polynomial on `Fin N → ℝ` with a conserved energy when ν = 0 (proven below),
so `‖a t‖₂` is BOUNDED and NO finite-time blow-up of ANY norm can occur —
the solution is global by Picard–Lindelöf + energy bound. Katz–Pavlović's
blow-up is a phenomenon of the INFINITE hierarchy: energy runs to n = ∞ in
finite time. So the honest 1(b) target for THIS model is NOT "blow-up
exists" (it is FALSE at finite N). It is one of:
  (b1) the N → ∞ statement, which needs ℓ² sequences, not `Fin N` — a fence
       question and a new definition set; or
  (b2) the finite-N SHADOW: energy concentrates at the top shell — for the
       inviscid model, `a_{N-1}` becomes the dominant shell — the "cascade
       reaches the cutoff" statement, which IS provable at finite N and IS
       "stretching wins" in the only sense finite N allows.

This file records the constriction: (i) the solution concept and blow-up
predicate as DEFINITIONS (certified next); (ii) inviscid energy CONSERVATION,
proven — the reason finite-N cannot blow up, and the cheapest true fact
toward 1(b). Toward the trunk, not the trunk. IN A MODEL.
-/

noncomputable section
variable {N : ℕ}

def prev (a : Fin N → ℝ) (n : Fin N) : ℝ :=
  if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else 0
def next (a : Fin N → ℝ) (n : Fin N) : ℝ :=
  if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else 0
def cascade (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) : ℝ :=
  lam ^ n.val * (prev a n) ^ 2 - lam ^ (n.val + 1) * a n * next a n
def damping (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) : ℝ :=
  - nu * lam ^ (2 * n.val) * a n
def field (nu lam : ℝ) (a : Fin N → ℝ) : Fin N → ℝ :=
  fun n => damping nu lam a n + cascade lam a n
def energy (a : Fin N → ℝ) : ℝ := (1/2) * ∑ n, (a n) ^ 2
def dissipation (nu lam : ℝ) (a : Fin N → ℝ) : ℝ := nu * ∑ n, lam ^ (2 * n.val) * (a n) ^ 2

/-- solution concept -/
def IsSolution (nu lam : ℝ) (a : ℝ → (Fin N → ℝ)) (T : ℝ) : Prop :=
  ∀ t ∈ Set.Ico 0 T, HasDerivAt a (field nu lam (a t)) t
/-- the critical-type norm -/
def critNorm (lam : ℝ) (a : Fin N → ℝ) : ℝ := ∑ n, lam ^ (2 * n.val) * (a n) ^ 2
/-- blow-up of the critical norm on [0,T) -/
def BlowsUp (lam : ℝ) (a : ℝ → (Fin N → ℝ)) (T : ℝ) : Prop :=
  ∀ M : ℝ, ∃ t ∈ Set.Ico 0 T, M < critNorm lam (a t)

/-! ## the cheapest true fact toward 1(b): inviscid energy conservation -/

theorem cascade_orthogonality (lam : ℝ) (a : Fin N → ℝ) :
    ∑ n, a n * cascade lam a n = 0 := by
  induction N with
  | zero => simp
  | succ M ih =>
    simp only [cascade, mul_sub, Finset.sum_sub_distrib]
    rw [Fin.sum_univ_succ, Fin.sum_univ_castSucc]
    have hbot : prev a (0 : Fin (M+1)) = 0 := by simp [prev]
    have htop : next a (Fin.last M) = 0 := by simp [next]
    have hp : ∀ i : Fin M, prev a i.succ = a i.castSucc := by
      intro i; simp only [prev, Fin.val_succ, Nat.add_sub_cancel]
      rw [dif_pos (Nat.succ_pos _)]; rfl
    have hn : ∀ i : Fin M, next a i.castSucc = a i.succ := by
      intro i; simp only [next, Fin.val_castSucc]
      rw [dif_pos (by omega)]; rfl
    simp only [hbot, htop, hp, hn, mul_zero, zero_pow (two_ne_zero), zero_add, add_zero]
    rw [sub_eq_zero]
    apply Finset.sum_congr rfl
    intro i _
    simp only [Fin.val_succ, Fin.val_castSucc]
    ring

/-- INVISCID ENERGY CONSERVATION: with ν = 0 the energy rate along the field is exactly 0.
This is WHY the finite-N inviscid model cannot blow up: energy is a first integral. -/
theorem inviscid_energy_conserved (lam : ℝ) (a : Fin N → ℝ) :
    ∑ n, a n * field 0 lam a n = 0 := by
  simp only [field, damping, neg_zero, zero_mul, zero_add, cascade_orthogonality]

/-- and along an actual SOLUTION, energy is constant in time: d/dt E(a t) = 0.
Coordinatewise: `HasDerivAt a v t` on `Fin N → ℝ` gives `HasDerivAt (fun s => a s n) (v n) t`
via `hasDerivAt_pi`; then energy = (1/2) Σ (·)², chain rule, and the algebraic identity. -/
theorem energy_deriv_zero_along_inviscid_solution (lam : ℝ) (a : ℝ → (Fin N → ℝ)) (T : ℝ)
    (hsol : IsSolution 0 lam a T) (t : ℝ) (ht : t ∈ Set.Ico 0 T) :
    HasDerivAt (fun s => energy (a s)) 0 t := by
  have hd := hsol t ht
  have hcoord : ∀ n : Fin N, HasDerivAt (fun s => a s n) (field 0 lam (a t) n) t :=
    fun n => (hasDerivAt_pi.mp hd) n
  have hsq : ∀ n : Fin N, HasDerivAt (fun s => (a s n) ^ 2) (2 * a t n * field 0 lam (a t) n) t := by
    intro n
    -- avoid HasDerivAt.pow (instance diamond on this pin); use mul on the square
    have h := (hcoord n).mul (hcoord n)
    have hf : ((fun s => a s n) * fun s => a s n : ℝ → ℝ) = fun s => (a s n) ^ 2 := by
      funext s; simp [sq]
    rw [hf] at h
    exact h.congr_deriv (by ring)
  have hsum : HasDerivAt (fun s => ∑ n, (a s n) ^ 2) (∑ n, 2 * a t n * field 0 lam (a t) n) t := by
    have h := HasDerivAt.sum (u := Finset.univ) (fun n _ => hsq n)
    have hf : (∑ n : Fin N, fun s => (a s n) ^ 2 : ℝ → ℝ) = fun s => ∑ n, (a s n) ^ 2 := by
      funext s; simp [Finset.sum_apply]
    rw [hf] at h
    exact h
  have hE : HasDerivAt (fun s => energy (a s)) ((1/2 : ℝ) * ∑ n, 2 * a t n * field 0 lam (a t) n) t := by
    unfold energy
    exact hsum.const_mul (1/2 : ℝ)
  have hzero : (1/2 : ℝ) * ∑ n, 2 * a t n * field 0 lam (a t) n = 0 := by
    have : ∑ n, 2 * a t n * field 0 lam (a t) n = 2 * ∑ n, a t n * field 0 lam (a t) n := by
      rw [Finset.mul_sum]; apply Finset.sum_congr rfl; intro n _; ring
    rw [this, inviscid_energy_conserved]; ring
  rw [hzero] at hE
  exact hE

end
