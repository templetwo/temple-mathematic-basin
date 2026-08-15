import Mathlib

/-- R2 slight advance — BKM's logical shape: under y' ≤ K y with continuous K, a bounded ∫ₐᵗK on [a,b)
forces y bounded on [a,b). Contrapositive: y unbounded ⇒ ∫K unbounded (blow-up needs infinite ∫). -/
theorem r2_bkm_shape : ∀ (y y' K : ℝ → ℝ) (a b : ℝ), a ≤ b → Continuous K → (∀ t ∈ Set.Ico a b, HasDerivAt y (y' t) t) → (∀ t ∈ Set.Ico a b, y' t ≤ K t * y t) → (∀ t ∈ Set.Ico a b, 0 ≤ y t) → (∃ M : ℝ, ∀ t ∈ Set.Ico a b, ∫ s in a..t, K s ≤ M) → ∃ C : ℝ, ∀ t ∈ Set.Ico a b, y t ≤ C := by
  intro y y' K a b hab hK hy hineq hy0 ⟨M, hM⟩
  refine ⟨y a * Real.exp M, ?_⟩
  intro t ht
  -- Grönwall on [a,t] ⊂ [a,b)
  set I : ℝ → ℝ := fun u => ∫ s in a..u, K s with hIdef
  have hI : ∀ s, HasDerivAt I (K s) s := by
    intro s
    exact intervalIntegral.integral_hasDerivAt_right (hK.intervalIntegrable a s)
      (hK.stronglyMeasurableAtFilter MeasureTheory.volume (nhds s)) hK.continuousAt
  have hIa : I a = 0 := by simp [hIdef]
  set g : ℝ → ℝ := fun s => y s * Real.exp (-(I s)) with hg
  have hsub : Set.Icc a t ⊆ Set.Ico a b := fun u hu => ⟨hu.1, lt_of_le_of_lt hu.2 ht.2⟩
  have hg' : ∀ s ∈ Set.Icc a t, HasDerivAt g ((y' s - K s * y s) * Real.exp (-(I s))) s := by
    intro s hs
    have h1 := (hy s (hsub hs)).mul (((hI s).neg).exp)
    have hfun : (y * fun x => Real.exp ((-I) x) : ℝ → ℝ) = g := by
      funext x; simp [hg]
    rw [hfun] at h1
    exact h1.congr_deriv (by simp only [Pi.neg_apply]; ring)
  have hle : ∀ u ∈ interior (Set.Icc a t), deriv g u ≤ 0 := by
    rw [interior_Icc]
    intro u hu
    have hu' : u ∈ Set.Icc a t := Set.Ioo_subset_Icc_self hu
    rw [(hg' u hu').deriv]
    apply mul_nonpos_of_nonpos_of_nonneg
    · linarith [hineq u (hsub hu')]
    · exact (Real.exp_pos _).le
  have hcont : ContinuousOn g (Set.Icc a t) := fun u hu => (hg' u hu).continuousAt.continuousWithinAt
  have hdiff : DifferentiableOn ℝ g (interior (Set.Icc a t)) := by
    rw [interior_Icc]
    exact fun u hu => (hg' u (Set.Ioo_subset_Icc_self hu)).differentiableAt.differentiableWithinAt
  have hmono := antitoneOn_of_deriv_nonpos (convex_Icc a t) hcont hdiff hle ⟨le_refl a, ht.1⟩ ⟨ht.1, le_refl t⟩ ht.1
  simp only [hg] at hmono
  have hyt : y t ≤ y a * Real.exp (I t) := by
    calc y t = (y t * Real.exp (-(I t))) * Real.exp (I t) := by
            rw [mul_assoc, ← Real.exp_add]; simp
      _ ≤ (y a * Real.exp (-(I a))) * Real.exp (I t) := by
            apply mul_le_mul_of_nonneg_right hmono (Real.exp_pos _).le
      _ = y a * Real.exp (I t) := by rw [hIa]; simp
  have hIM : I t ≤ M := hM t ht
  have hya : 0 ≤ y a := hy0 a ⟨le_refl a, lt_of_le_of_lt (le_refl a) (lt_of_le_of_lt ht.1 ht.2)⟩
  calc y t ≤ y a * Real.exp (I t) := hyt
    _ ≤ y a * Real.exp M := by
          apply mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr hIM) hya

/-- R3 slight advance — vorticity scales with exponent 2 under u_λ(x) = λ u(λx):
curl u_λ (x) = λ² • curl u (λ x), for differentiable u. -/
theorem r3_curl_scaling : ∀ (lam : ℝ) (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)), Differentiable ℝ u → ∀ x : EuclideanSpace ℝ (Fin 3), (fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (x : EuclideanSpace ℝ (Fin 3)) => (WithLp.toLp 2 ![ ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 1 x) 2 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 2 x) 1, ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 2 x) 0 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 0 x) 2, ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 0 x) 1 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 1 x) 0 ] : EuclideanSpace ℝ (Fin 3))) ((fun (lam : ℝ) (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (x : EuclideanSpace ℝ (Fin 3)) => lam • u (lam • x)) lam u) x = (lam ^ 2) • (fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (x : EuclideanSpace ℝ (Fin 3)) => (WithLp.toLp 2 ![ ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 1 x) 2 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 2 x) 1, ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 2 x) 0 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 0 x) 2, ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 0 x) 1 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 1 x) 0 ] : EuclideanSpace ℝ (Fin 3))) u (lam • x) := by
  intro lam u hu x
  have hpt : fderiv ℝ (fun x => lam • u (lam • x)) x = (lam * lam) • fderiv ℝ u (lam • x) := by
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
  simp only [hpt]
  ext i
  fin_cases i <;> simp <;> ring

/-- R4 slight advance — 2D vorticity is NOT vacuous: a differentiable 2D field with nonzero curl.
rot(x) = (−x₁, x₀, 0): u₂ ≡ 0, ∂₂ = 0, curl = (0,0,2). -/
theorem r4_twoD_vorticity_nonzero : ∃ (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)), (fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) => (∀ x, u x 2 = 0) ∧ (∀ x, (fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 2 x = 0)) u ∧ Differentiable ℝ u ∧ ∃ x : EuclideanSpace ℝ (Fin 3), (fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (x : EuclideanSpace ℝ (Fin 3)) => (WithLp.toLp 2 ![ ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 1 x) 2 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 2 x) 1, ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 2 x) 0 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 0 x) 2, ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 0 x) 1 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 1 x) 0 ] : EuclideanSpace ℝ (Fin 3))) u x ≠ 0 := by
  let L : EuclideanSpace ℝ (Fin 3) →L[ℝ] EuclideanSpace ℝ (Fin 3) :=
    LinearMap.toContinuousLinearMap
      { toFun := fun x => WithLp.toLp 2 ![-(x 1), x 0, 0]
        map_add' := by intro x y; ext i; fin_cases i <;> simp <;> ring
        map_smul' := by intro c x; ext i; fin_cases i <;> simp }
  have hf : ∀ x, fderiv ℝ (⇑L) x = L := fun x => L.fderiv
  refine ⟨⇑L, ⟨?_, ?_⟩, L.differentiable, 0, ?_⟩
  · intro x; simp [L]
  · intro x; simp only [hf]; ext i; fin_cases i <;> simp [L]
  · intro h
    have := congrArg (fun v : EuclideanSpace ℝ (Fin 3) => v 2) h
    simp only [hf] at this
    simp [L] at this
