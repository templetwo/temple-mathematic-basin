import Mathlib

/-!
# Rung 3 · constriction — the critical scaling, as algebra

Navier–Stokes is invariant under `u_λ(x,t) = λ·u(λx, λ²t)`. A norm is CRITICAL
if it is invariant under this scaling. The trunk question is framed around the
critical norms L³ and Ḣ^{1/2} because they sit exactly at the scaling threshold —
this rung certifies WHY.

(i) THE L^p SCALING IDENTITY, on ℝ³ (`EuclideanSpace ℝ (Fin 3)`, finrank 3):
    ∫ ‖λ·u(λ·x)‖^p dx = λ^{p−3} ∫ ‖u‖^p dx    (λ > 0)
  by change of variables (Mathlib `integral_comp_smul_of_nonneg`). So the
  L^p norm scales as λ^{1−3/p}: INVARIANT iff p = 3. That is why L³ is the
  endpoint at all (Escauriaza–Seregin–Šverák).

(ii) THE EXPONENT ARITHMETIC as closed facts: 1 − 3/p = 0 ↔ p = 3; and for
  the Sobolev scale, ‖u_λ‖_{Ḣ^s} = λ^{s − 1/2}‖u‖_{Ḣ^s} so s − 1/2 = 0 ↔ s = 1/2.
  Ḣ^{1/2} ITSELF is not defined in Mathlib (FENCE.md); its exponent identity is
  certified here as arithmetic; its definition is Rung-0-style work, deferred.

Claim-typed: machine-checked = the L^p scaling identity and both exponent
identities. CITED = that L³ / Ḣ^{1/2} criticality is what makes them the
endpoint norms in the regularity theory. Toward the trunk, not the trunk.
Nothing dynamical — pure scaling algebra.
-/

noncomputable section
open MeasureTheory

abbrev V := EuclideanSpace ℝ (Fin 3)

/-- The scaled field `x ↦ λ • u (λ • x)`. -/
def scaleField (lam : ℝ) (u : V → V) : V → V := fun x => lam • u (lam • x)

/-- (i) L^p scaling: `∫ ‖u_λ‖^p = λ^{p−3} · ∫ ‖u‖^p` for λ > 0. -/
theorem lp_scaling (lam : ℝ) (hlam : 0 < lam) (u : V → V) (p : ℕ) :
    ∫ x, ‖scaleField lam u x‖ ^ p ∂(volume : Measure V)
      = lam ^ p * (lam ^ 3)⁻¹ * ∫ x, ‖u x‖ ^ p ∂(volume : Measure V) := by
  simp only [scaleField, norm_smul, Real.norm_eq_abs, abs_of_pos hlam, mul_pow]
  rw [integral_const_mul]
  have h := (volume : Measure V).integral_comp_smul_of_nonneg (fun x => ‖u x‖ ^ p) lam (hR := hlam.le)
  rw [h, finrank_euclideanSpace, Fintype.card_fin]
  simp [smul_eq_mul]; ring

/-- (ii-a) the L^p exponent: 1 − 3/p = 0 ↔ p = 3, for p > 0. -/
theorem lp_critical_exponent (p : ℝ) (hp : 0 < p) : (1 - 3 / p = 0) ↔ p = 3 := by
  constructor
  · intro h; field_simp at h; linarith
  · intro h; subst h; norm_num

/-- (ii-b) the Ḣ^s exponent on ℝ³: s − 1/2 = 0 ↔ s = 1/2. -/
theorem sobolev_critical_exponent (s : ℝ) : (s - 1/2 = 0) ↔ s = 1/2 := by
  constructor <;> intro h <;> linarith

/-- The L^p scaling identity specialised to p = 3: the integral is INVARIANT. -/
theorem l3_invariant (lam : ℝ) (hlam : 0 < lam) (u : V → V) :
    ∫ x, ‖scaleField lam u x‖ ^ 3 ∂(volume : Measure V)
      = ∫ x, ‖u x‖ ^ 3 ∂(volume : Measure V) := by
  rw [lp_scaling lam hlam u 3]
  have : lam ^ 3 * (lam ^ 3)⁻¹ = 1 := mul_inv_cancel₀ (pow_ne_zero 3 hlam.ne')
  rw [this, one_mul]

end
