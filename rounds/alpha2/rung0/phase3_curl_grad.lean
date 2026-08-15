import Mathlib

noncomputable section
abbrev V := EuclideanSpace ℝ (Fin 3)
def e (i : Fin 3) : V := EuclideanSpace.single i 1
def pd {W : Type} [NormedAddCommGroup W] [NormedSpace ℝ W]
    (f : V → W) (i : Fin 3) (x : V) : W := fderiv ℝ f x (e i)
def curl (u : V → V) (x : V) : V :=
  WithLp.toLp 2 ![ pd u 1 x 2 - pd u 2 x 1, pd u 2 x 0 - pd u 0 x 2, pd u 0 x 1 - pd u 1 x 0 ]
def gradp (p : V → ℝ) (x : V) : V := WithLp.toLp 2 ![pd p 0 x, pd p 1 x, pd p 2 x]

theorem pd_differentiable (p : V → ℝ) (hp : ContDiff ℝ 2 p) (k : Fin 3) :
    Differentiable ℝ (fun y => pd p k y) := by
  have h1 : Differentiable ℝ (fderiv ℝ p) :=
    (hp.fderiv_right (m := 1) (by norm_num)).differentiable (by norm_num)
  exact fun y => ((h1 y).clm_apply (differentiableAt_const _))

/-- gradp p, as a function, is the CLE-symm of the pi function of partials. -/
theorem gradp_eq (p : V → ℝ) :
    gradp p = fun y => (WithLp.linearEquiv 2 ℝ (Fin 3 → ℝ)).symm (fun i => pd p i y) := by
  funext y; simp only [gradp]
  congr 1; funext i; fin_cases i <;> rfl

/-- second-partial symmetry: ∂ⱼ∂ᵢp = ∂ᵢ∂ⱼp for C² p -/
theorem pd_pd_symm (p : V → ℝ) (hp : ContDiff ℝ 2 p) (i j : Fin 3) (x : V) :
    fderiv ℝ (fun y => pd p i y) x (e j) = fderiv ℝ (fun y => pd p j y) x (e i) := by
  have h1 : Differentiable ℝ (fderiv ℝ p) :=
    (hp.fderiv_right (m := 1) (by norm_num)).differentiable (by norm_num)
  have hclm : ∀ k : Fin 3, fderiv ℝ (fun y => pd p k y) x = (fderiv ℝ (fderiv ℝ p) x).flip (e k) := by
    intro k
    simp only [pd]
    rw [fderiv_clm_apply (h1 x) (differentiableAt_const _)]
    simp
  rw [hclm i, hclm j]
  simp only [ContinuousLinearMap.flip_apply]
  exact (hp.contDiffAt.isSymmSndFDerivAt (by simp [minSmoothness_of_isRCLikeNormedField])) (e j) (e i)

theorem pd_gradp_coord (p : V → ℝ) (hp : ContDiff ℝ 2 p) (i j : Fin 3) (x : V) :
    pd (gradp p) j x i = fderiv ℝ (fun y => pd p i y) x (e j) := by
  rw [gradp_eq]
  simp only [pd]
  -- gradient field = L ∘ (pi of partials), L a CLE; fderiv of composition, then fderiv_pi
  let L : (Fin 3 → ℝ) →L[ℝ] V := (PiLp.continuousLinearEquiv 2 ℝ (fun _ : Fin 3 => ℝ)).symm
  have hL : (fun y => (WithLp.linearEquiv 2 ℝ (Fin 3 → ℝ)).symm (fun i => fderiv ℝ p y (e i)))
      = ⇑L ∘ (fun y (i : Fin 3) => fderiv ℝ p y (e i)) := by
    funext y; rfl
  have hpi : DifferentiableAt ℝ (fun y (i : Fin 3) => fderiv ℝ p y (e i)) x :=
    differentiableAt_pi.mpr (fun i => (pd_differentiable p hp i) x)
  rw [hL, fderiv_comp x L.differentiableAt hpi, L.fderiv]
  simp only [ContinuousLinearMap.comp_apply]
  have hd' : ∀ k : Fin 3, DifferentiableAt ℝ (fun y => fderiv ℝ p y (e k)) x :=
    fun k => (pd_differentiable p hp k) x
  rw [fderiv_pi hd']
  simp [L]

/-- THE RING: curl of a gradient is zero, for every C² scalar field. -/
theorem curl_gradp_zero (p : V → ℝ) (hp : ContDiff ℝ 2 p) (x : V) : curl (gradp p) x = 0 := by
  ext i
  simp only [curl]
  fin_cases i <;> simp [pd_gradp_coord p hp, pd_pd_symm p hp]

end
