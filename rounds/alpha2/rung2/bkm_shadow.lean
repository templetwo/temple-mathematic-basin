import Mathlib

/-!
# Rung 2 · constriction — the Grönwall engine of Beale–Kato–Majda

BKM (1984): a smooth 3D Euler/NS solution on [0,T*) continues past T* iff
∫₀^{T*} ‖ω‖_∞ dt < ∞. It is the theorem that makes VORTEX STRETCHING the
question: regularity is lost only through vorticity growth.

The fence cannot state BKM (no Sobolev norms, no PDE solution concept — FENCE.md).
Its ENGINE is fence-legal and IS the analytic content:

  **time-dependent Grönwall (integrating-factor form).** If y ≥ 0 satisfies
  y' ≤ K·y on [a,b] and I is an antiderivative of K there, then
  y(t) ≤ y(a)·exp(I(t) − I(a)). A finite ∫K forces y bounded.

In BKM, y = a regularity norm and K = C‖ω(t)‖_∞: bounded ∫‖ω‖_∞ ⇒ bounded
norm ⇒ no blow-up. Lean checks the ODE inequality; the PDE estimate that
produces y' ≤ K y (Calderón–Zygmund + log-Sobolev) is what Mathlib lacks.

The antiderivative I is a HYPOTHESIS here, not derived by FTC — that keeps the
theorem the pure Grönwall step. FTC (I(t) = ∫ₐᵗ K for continuous K) is a
separate standard fact, cited.

Claim-typed: machine-checked = the Grönwall engine. CITED — that this engine
fed the BKM estimate yields the BKM criterion. NOT the criterion. NO PDE.
Toward the trunk, not the trunk.
-/

noncomputable section
open Set

theorem gronwall_integrating_factor
    {y y' K I : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hy : ∀ t ∈ Icc a b, HasDerivAt y (y' t) t)
    (hI : ∀ t ∈ Icc a b, HasDerivAt I (K t) t)
    (hineq : ∀ t ∈ Icc a b, y' t ≤ K t * y t)
    (hy0 : ∀ t ∈ Icc a b, 0 ≤ y t) :
    ∀ t ∈ Icc a b, y t ≤ y a * Real.exp (I t - I a) := by
  intro t ht
  -- g(s) := y(s) · exp(−I(s)); g' = (y' − K y)·exp(−I) ≤ 0 on [a,b]
  set g : ℝ → ℝ := fun s => y s * Real.exp (-(I s)) with hg
  have hg' : ∀ s ∈ Icc a b, HasDerivAt g ((y' s - K s * y s) * Real.exp (-(I s))) s := by
    intro s hs
    have h1 := (hy s hs).mul (((hI s hs).neg).exp)
    have hfun : (y * fun x => Real.exp ((-I) x) : ℝ → ℝ) = g := by
      funext x; simp [hg]
    rw [hfun] at h1
    exact h1.congr_deriv (by simp only [Pi.neg_apply]; ring)
  have hgmono : ∀ s ∈ Icc a b, g s ≤ g a := by
    intro s hs
    have hle : ∀ u ∈ Icc a s, deriv g u ≤ 0 := by
      intro u hu
      have hu' : u ∈ Icc a b := ⟨hu.1, hu.2.trans hs.2⟩
      rw [(hg' u hu').deriv]
      apply mul_nonpos_of_nonpos_of_nonneg
      · linarith [hineq u hu']
      · exact (Real.exp_pos _).le
    have hcont : ContinuousOn g (Icc a s) := fun u hu =>
      (hg' u ⟨hu.1, hu.2.trans hs.2⟩).continuousAt.continuousWithinAt
    have hdiff : DifferentiableOn ℝ g (interior (Icc a s)) := by
      rw [interior_Icc]
      exact fun u hu => (hg' u ⟨hu.1.le, hu.2.le.trans hs.2⟩).differentiableAt.differentiableWithinAt
    have hle' : ∀ u ∈ interior (Icc a s), deriv g u ≤ 0 := by
      rw [interior_Icc]; exact fun u hu => hle u (Ioo_subset_Icc_self hu)
    exact antitoneOn_of_deriv_nonpos (convex_Icc a s) hcont hdiff hle' ⟨le_refl a, hs.1⟩ ⟨hs.1, le_refl s⟩ hs.1
  have := hgmono t ht
  simp only [hg] at this
  -- y t · exp(−I t) ≤ y a · exp(−I a)  ⇒  y t ≤ y a · exp(I t − I a)
  have hpos : 0 < Real.exp (-(I t)) := Real.exp_pos _
  calc y t = (y t * Real.exp (-(I t))) * Real.exp (I t) := by
          rw [mul_assoc, ← Real.exp_add]; simp
    _ ≤ (y a * Real.exp (-(I a))) * Real.exp (I t) := by
          apply mul_le_mul_of_nonneg_right this (Real.exp_pos _).le
    _ = y a * Real.exp (I t - I a) := by
          rw [mul_assoc, ← Real.exp_add]; ring_nf

end
