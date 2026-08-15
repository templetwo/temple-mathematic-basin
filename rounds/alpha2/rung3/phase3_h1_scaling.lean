import Mathlib

open MeasureTheory

/-- Ḣ¹ scaling: for u_λ(x) = λ u(λx), ∫‖∇u_λ‖² = λ⁴ λ⁻³ ∫‖∇u‖². -/
theorem r3_h1_scaling : ∀ (lam : ℝ), 0 < lam → ∀ (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)), Differentiable ℝ u → ∫ x, ‖fderiv ℝ ((fun (lam : ℝ) (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (x : EuclideanSpace ℝ (Fin 3)) => lam • u (lam • x)) lam u) x‖ ^ 2 ∂(MeasureTheory.volume : MeasureTheory.Measure (EuclideanSpace ℝ (Fin 3))) = lam ^ 4 * (lam ^ 3)⁻¹ * ∫ x, ‖fderiv ℝ u x‖ ^ 2 ∂(MeasureTheory.volume : MeasureTheory.Measure (EuclideanSpace ℝ (Fin 3))) := by
  intro lam hl u hu
  -- pointwise: fderiv (λ u(λ·)) x = (λ*λ) • fderiv u (λ x)
  have hpt : ∀ x : EuclideanSpace ℝ (Fin 3),
      fderiv ℝ (fun x => lam • u (lam • x)) x = (lam * lam) • fderiv ℝ u (lam • x) := by
    intro x
    have hs : HasFDerivAt (fun y : EuclideanSpace ℝ (Fin 3) => lam • y)
        (lam • ContinuousLinearMap.id ℝ (EuclideanSpace ℝ (Fin 3))) x :=
      (hasFDerivAt_id x).const_smul lam
    have hc : HasFDerivAt (fun y => u (lam • y))
        ((fderiv ℝ u (lam • x)).comp (lam • ContinuousLinearMap.id ℝ (EuclideanSpace ℝ (Fin 3)))) x :=
      (hu (lam • x)).hasFDerivAt.comp x hs
    have h : HasFDerivAt (fun y => lam • u (lam • y))
        (lam • ((fderiv ℝ u (lam • x)).comp (lam • ContinuousLinearMap.id ℝ (EuclideanSpace ℝ (Fin 3))))) x :=
      hc.const_smul lam
    rw [h.fderiv]
    ext v
    simp only [smul_apply, ContinuousLinearMap.comp_apply,
      ContinuousLinearMap.id_apply, map_smul, smul_smul]
  have hnorm : ∀ x : EuclideanSpace ℝ (Fin 3),
      ‖fderiv ℝ (fun x => lam • u (lam • x)) x‖ ^ 2 = (lam ^ 4) * ‖fderiv ℝ u (lam • x)‖ ^ 2 := by
    intro x
    rw [hpt, norm_smul, mul_pow, Real.norm_eq_abs, abs_of_pos (mul_pos hl hl)]
    ring
  simp_rw [hnorm]
  rw [integral_const_mul]
  have hcs := MeasureTheory.Measure.integral_comp_smul (volume : Measure (EuclideanSpace ℝ (Fin 3)))
    (fun y => ‖fderiv ℝ u y‖ ^ 2) lam
  rw [hcs, finrank_euclideanSpace_fin]
  rw [smul_eq_mul, abs_of_pos (inv_pos.mpr (pow_pos hl 3))]
  ring
