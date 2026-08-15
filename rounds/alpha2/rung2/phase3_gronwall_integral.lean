import Mathlib

/-- Grönwall in integral form: continuous K, y' ≤ K y, y ≥ 0 on [a,b] ⇒ y t ≤ y a · exp(∫ₐᵗ K). -/
theorem r2_gronwall_integral : ∀ (y y' K : ℝ → ℝ) (a b : ℝ), a ≤ b → Continuous K → (∀ t ∈ Set.Icc a b, HasDerivAt y (y' t) t) → (∀ t ∈ Set.Icc a b, y' t ≤ K t * y t) → (∀ t ∈ Set.Icc a b, 0 ≤ y t) → ∀ t ∈ Set.Icc a b, y t ≤ y a * Real.exp (∫ s in a..t, K s) := by
  intro y y' K a b hab hK hy hineq hy0 t ht
  -- the antiderivative from the FTC
  set I : ℝ → ℝ := fun u => ∫ s in a..u, K s with hIdef
  have hI : ∀ s ∈ Set.Icc a b, HasDerivAt I (K s) s := by
    intro s _
    exact intervalIntegral.integral_hasDerivAt_right (hK.intervalIntegrable a s)
      (hK.stronglyMeasurableAtFilter MeasureTheory.volume (nhds s)) hK.continuousAt
  have hIa : I a = 0 := by simp [hIdef]
  set g : ℝ → ℝ := fun s => y s * Real.exp (-(I s)) with hg
  have hg' : ∀ s ∈ Set.Icc a b, HasDerivAt g ((y' s - K s * y s) * Real.exp (-(I s))) s := by
    intro s hs
    have h1 := (hy s hs).mul (((hI s hs).neg).exp)
    have hfun : (y * fun x => Real.exp ((-I) x) : ℝ → ℝ) = g := by
      funext x; simp [hg]
    rw [hfun] at h1
    exact h1.congr_deriv (by simp only [Pi.neg_apply]; ring)
  have hgmono : ∀ s ∈ Set.Icc a b, g s ≤ g a := by
    intro s hs
    have hle : ∀ u ∈ Set.Icc a s, deriv g u ≤ 0 := by
      intro u hu
      have hu' : u ∈ Set.Icc a b := ⟨hu.1, hu.2.trans hs.2⟩
      rw [(hg' u hu').deriv]
      apply mul_nonpos_of_nonpos_of_nonneg
      · linarith [hineq u hu']
      · exact (Real.exp_pos _).le
    have hcont : ContinuousOn g (Set.Icc a s) := fun u hu =>
      (hg' u ⟨hu.1, hu.2.trans hs.2⟩).continuousAt.continuousWithinAt
    have hdiff : DifferentiableOn ℝ g (interior (Set.Icc a s)) := by
      rw [interior_Icc]
      exact fun u hu => (hg' u ⟨hu.1.le, hu.2.le.trans hs.2⟩).differentiableAt.differentiableWithinAt
    have hle' : ∀ u ∈ interior (Set.Icc a s), deriv g u ≤ 0 := by
      rw [interior_Icc]; exact fun u hu => hle u (Set.Ioo_subset_Icc_self hu)
    exact antitoneOn_of_deriv_nonpos (convex_Icc a s) hcont hdiff hle' ⟨le_refl a, hs.1⟩ ⟨hs.1, le_refl s⟩ hs.1
  have := hgmono t ht
  simp only [hg] at this
  have hIt : I t = ∫ s in a..t, K s := rfl
  calc y t = (y t * Real.exp (-(I t))) * Real.exp (I t) := by
          rw [mul_assoc, ← Real.exp_add]; simp
    _ ≤ (y a * Real.exp (-(I a))) * Real.exp (I t) := by
          apply mul_le_mul_of_nonneg_right this (Real.exp_pos _).le
    _ = y a * Real.exp (∫ s in a..t, K s) := by
          rw [hIa, hIt]; simp
