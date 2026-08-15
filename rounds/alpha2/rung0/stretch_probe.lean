import Mathlib

/-!
Branch B probe — the vortex-stretching witness, worked in lake before freezing.

`w = rot + s`, with `rot x = (−x₁, x₀, 0)` (a CLM) and `s x = (x₀·x₁) • e₂`.
Not linear, so not a CLM — the first genuinely nonlinear field in the round.
div w = 0, curl w = (x₀, −x₁, 2), stretch w = (x₁, x₀, 0) ≠ 0 at e₀.
So `stretch` — the term the trunk question is ABOUT — has a nonzero
inhabitant and the C2 has content.
-/

noncomputable section

abbrev V := EuclideanSpace ℝ (Fin 3)
def e (i : Fin 3) : V := EuclideanSpace.single i 1
def pd (f : V → V) (i : Fin 3) (x : V) : V := fderiv ℝ f x (e i)
def curl (u : V → V) (x : V) : V :=
  WithLp.toLp 2
    ![ pd u 1 x 2 - pd u 2 x 1,
       pd u 2 x 0 - pd u 0 x 2,
       pd u 0 x 1 - pd u 1 x 0 ]
def stretch (u : V → V) (x : V) : V :=
  ∑ i : Fin 3, (curl u x i) • pd u i x

def rotL : V →L[ℝ] V :=
  LinearMap.toContinuousLinearMap
    { toFun := fun x => WithLp.toLp 2 ![-(x 1), x 0, 0]
      map_add' := by intro x y; ext i; fin_cases i <;> simp <;> ring
      map_smul' := by intro c x; ext i; fin_cases i <;> simp }

/-- scalar x₀·x₁ -/
def q (x : V) : ℝ := x 0 * x 1
/-- the saddle vertical component -/
def s (x : V) : V := q x • e 2
/-- the witness -/
def w (x : V) : V := rotL x + s x

theorem q_hasFDerivAt (x : V) :
    HasFDerivAt q ((x 1) • (EuclideanSpace.proj (0:Fin 3) : V →L[ℝ] ℝ)
                 + (x 0) • (EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ)) x := by
  have h0 : HasFDerivAt (fun y : V => y 0) (EuclideanSpace.proj (0:Fin 3) : V →L[ℝ] ℝ) x :=
    (EuclideanSpace.proj (0:Fin 3) : V →L[ℝ] ℝ).hasFDerivAt
  have h1 : HasFDerivAt (fun y : V => y 1) (EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ) x :=
    (EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ).hasFDerivAt
  have := h0.mul h1
  -- h0.mul h1 gives derivative  x₀ • proj₁ + x₁ • proj₀ ; commute the sum
  rw [add_comm] at this
  exact this

theorem w_differentiable : Differentiable ℝ w := by
  intro x
  apply DifferentiableAt.add rotL.differentiableAt
  exact (q_hasFDerivAt x).differentiableAt.smul_const (e 2)

/-- fderiv w x v = (−v₁, v₀, x₁·v₀ + x₀·v₁) -/
theorem fderiv_w_apply (x v : V) :
    fderiv ℝ w x v = rotL v + (x 1 * v 0 + x 0 * v 1) • e 2 := by
  have hs : HasFDerivAt s (((x 1) • (EuclideanSpace.proj (0:Fin 3) : V →L[ℝ] ℝ)
                 + (x 0) • (EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ)).smulRight (e 2)) x :=
    (q_hasFDerivAt x).smul_const (e 2)
  have hw : HasFDerivAt w (rotL + (((x 1) • (EuclideanSpace.proj (0:Fin 3) : V →L[ℝ] ℝ)
                 + (x 0) • (EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ)).smulRight (e 2))) x :=
    rotL.hasFDerivAt.add hs
  rw [hw.fderiv]
  simp [ContinuousLinearMap.smulRight_apply, add_smul, smul_smul, mul_comm]

/-- pd w i x for each basis direction: (−δ₁ᵢ, δ₀ᵢ, x₁δ₀ᵢ + x₀δ₁ᵢ) -/
theorem pd_w (i : Fin 3) (x : V) :
    pd w i x = rotL (e i) + (x 1 * e i 0 + x 0 * e i 1) • e 2 := by
  simp only [pd, fderiv_w_apply]

/-- C2 CONTENT: stretch w at e₀ is (0,1,0) ≠ 0. -/
theorem stretch_w_e0_ne_zero : stretch w (e 0) ≠ 0 := by
  intro h
  have := congrArg (fun v : V => v 1) h
  simp only [stretch, Fin.sum_univ_three, curl, pd_w] at this
  simp [rotL, e, PiLp.single_apply] at this

end
