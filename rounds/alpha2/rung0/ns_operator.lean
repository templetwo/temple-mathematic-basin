import Mathlib

/-!
# Rung 0 · constriction — the Navier–Stokes operator (the ladder's named gap)

The ladder's Rung 0 names "div-free, vorticity, the NS operator." The first
two were certified; the operator was scoped out at selection. Constricting
Rung 0 means certifying it.

The stationary incompressible NS operator, built ONLY from the already-
certified primitive `pd` (partial via `fderiv` on `EuclideanSpace ℝ (Fin 3)`):

  N(u, p) := (u·∇)u + ∇p − ν Δu
  (u·∇)u  := Σᵢ uᵢ · ∂ᵢu
  ∇p      := (∂₀p, ∂₁p, ∂₂p)
  Δu      := Σᵢ ∂ᵢ(∂ᵢu)

Time is deliberately absent: the fence has no ODE/PDE solution concept
(FENCE.md). A steady solution is a pair (u,p) with N(u,p) = 0 and DivFree u.
This is where PRESSURE enters the record for the first time.

C2 witness — an EXACT STEADY SOLUTION: rigid rotation u = (−x₁, x₀, 0) with
its centrifugal pressure p = (x₀² + x₁²)/2. Then (u·∇)u = −(x₀,x₁,0),
∇p = (x₀,x₁,0), Δu = 0, so N(u,p) = 0 for EVERY ν. Div-free (already certified).
C3 mutant — the SAME u with the WRONG pressure p = 0: N(u,0) = −(x₀,x₁,0) ≠ 0.
The operator distinguishes right pressure from wrong. Pressure is load-bearing.

Toward the trunk, not the trunk. Nothing about regularity. The vocabulary
of the equations, certified to mean what it says.
-/

noncomputable section

abbrev V := EuclideanSpace ℝ (Fin 3)
def e (i : Fin 3) : V := EuclideanSpace.single i 1
def pd {W : Type} [NormedAddCommGroup W] [NormedSpace ℝ W]
    (f : V → W) (i : Fin 3) (x : V) : W :=
  fderiv ℝ f x (e i)

/-- convection `(u·∇)u` -/
def convect (u : V → V) (x : V) : V := ∑ i : Fin 3, (u x i) • pd u i x
/-- pressure gradient `∇p` -/
def gradp (p : V → ℝ) (x : V) : V := WithLp.toLp 2 ![pd p 0 x, pd p 1 x, pd p 2 x]
/-- vector Laplacian `Δu = Σᵢ ∂ᵢ∂ᵢu` -/
def lap (u : V → V) (x : V) : V := ∑ i : Fin 3, pd (pd u i) i x
/-- the stationary NS operator -/
def nsOp (nu : ℝ) (u : V → V) (p : V → ℝ) (x : V) : V :=
  convect u x + gradp p x - nu • lap u x
/-- steady solution: operator vanishes everywhere -/
def IsSteadyNS (nu : ℝ) (u : V → V) (p : V → ℝ) : Prop := ∀ x, nsOp nu u p x = 0

/-! ## the witness pair -/
def rotL : V →L[ℝ] V :=
  LinearMap.toContinuousLinearMap
    { toFun := fun x => WithLp.toLp 2 ![-(x 1), x 0, 0]
      map_add' := by intro x y; ext i; fin_cases i <;> simp <;> ring
      map_smul' := by intro c x; ext i; fin_cases i <;> simp }
def rot : V → V := rotL
/-- centrifugal pressure -/
def pc (x : V) : ℝ := (x 0 ^ 2 + x 1 ^ 2) / 2

theorem pd_rot (i : Fin 3) (x : V) : pd rot i x = rot (e i) := by simp [pd, rot, rotL.fderiv]
theorem rot_apply (x : V) (i : Fin 3) : rot x i = (![-(x 1), x 0, 0] : Fin 3 → ℝ) i := by
  simp [rot, rotL]

/-- ∂ᵢ of a CLM's coordinate is constant, so ∂ᵢ∂ᵢ rot = 0: Δ rot = 0 -/
theorem lap_rot (x : V) : lap rot x = 0 := by
  simp only [lap]
  have h : ∀ i : Fin 3, pd (pd rot i) i x = 0 := by
    intro i
    have : pd rot i = fun _ => rot (e i) := funext (pd_rot i)
    simp only [this, pd, fderiv_const]
    simp
  simp [h]

/-- gradient of the centrifugal pressure: (x₀, x₁, 0) -/
theorem pd_pc (i : Fin 3) (x : V) : pd pc i x = (![x 0, x 1, 0] : Fin 3 → ℝ) i := by
  have h0 : HasFDerivAt (fun y : V => y 0) (EuclideanSpace.proj (0:Fin 3) : V →L[ℝ] ℝ) x :=
    (EuclideanSpace.proj (0:Fin 3) : V →L[ℝ] ℝ).hasFDerivAt
  have h1 : HasFDerivAt (fun y : V => y 1) (EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ) x :=
    (EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ).hasFDerivAt
  -- pc = (1/2) * (y0^2 + y1^2); take the derivative Lean computes and don't fight its shape
  have hpc : HasFDerivAt (fun y : V => (1/2 : ℝ) * (y 0 ^ 2 + y 1 ^ 2))
      ((1/2 : ℝ) • (((2 • x 0 ^ (2 - 1)) • (EuclideanSpace.proj (0:Fin 3) : V →L[ℝ] ℝ))
                  + ((2 • x 1 ^ (2 - 1)) • (EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ)))) x :=
    ((h0.pow 2).add (h1.pow 2)).const_mul (1/2 : ℝ)
  have hpc' : pc = fun y : V => (1/2 : ℝ) * (y 0 ^ 2 + y 1 ^ 2) := by
    funext y; simp [pc]; ring
  rw [hpc'] at *
  simp only [pd, hpc.fderiv]
  fin_cases i <;> simp [e] <;> ring

theorem gradp_pc (x : V) : gradp pc x = WithLp.toLp 2 ![x 0, x 1, 0] := by
  simp only [gradp, pd_pc]; rfl

/-- (rot·∇)rot = −(x₀, x₁, 0) -/
theorem convect_rot (x : V) : convect rot x = WithLp.toLp 2 ![-(x 0), -(x 1), 0] := by
  simp only [convect, pd_rot, Fin.sum_univ_three]
  ext i; fin_cases i <;> simp [rot_apply, e, PiLp.single_apply] <;> ring

/-- C2: rigid rotation with centrifugal pressure is an exact steady solution, every ν. -/
theorem rot_pc_steady (nu : ℝ) : IsSteadyNS nu rot pc := by
  intro x
  simp only [nsOp, convect_rot, gradp_pc, lap_rot, smul_zero, sub_zero]
  ext i; fin_cases i <;> simp

/-- C3: the same velocity with the WRONG pressure (p = 0) is NOT a steady solution —
at x = e₀ the operator is (−1, 0, 0). Pressure is load-bearing. -/
theorem rot_zero_pressure_not_steady (nu : ℝ) : ¬ IsSteadyNS nu rot (fun _ => 0) := by
  intro h
  have hx := h (e 0)
  have hg : gradp (fun _ : V => (0:ℝ)) (e 0) = 0 := by
    simp only [gradp, pd, fderiv_const]; ext i; fin_cases i <;> simp
  simp only [nsOp, convect_rot, hg, lap_rot, smul_zero, sub_zero, add_zero] at hx
  have := congrArg (fun v : V => v 0) hx
  simp [e, PiLp.single_apply] at this

/-- C1: IsSteadyNS is satisfiable — it cannot prove False. -/
theorem steadyNS_consistent (nu : ℝ) :
    ¬ (∀ (u : V → V) (p : V → ℝ), IsSteadyNS nu u p → False) :=
  fun h => h rot pc (rot_pc_steady nu)

end
