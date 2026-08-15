import Mathlib

/-!
# Rung 0 · constriction — the Navier–Stokes operator (the ladder's named gap)

The ladder's Rung 0 names "div-free, vorticity, the NS operator." The first
two were certified; the operator was scoped out at selection. Constricting
Rung 0 means certifying it.

**Momentum form** (grok #18193 (a)): the evolution equation is
  ∂ₜu + (u·∇)u + ∇p = νΔu,
so with N(u,p) := (u·∇)u + ∇p − νΔu it reads ∂ₜu + N(u,p) = 0, and a
STEADY solution is N(u,p) = 0. Sign convention verified against that form.

The stationary operator, built ONLY from the already-certified primitive
`pd` (partial via `fderiv` on `EuclideanSpace ℝ (Fin 3)`):

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
/-- steady solution: operator vanishes everywhere — WITH SMOOTHNESS IN THE PROP.

The first draft was `∀ x, nsOp ν u p x = 0` alone, and mbp-grok (#18193) caught
it as vacuous the SAME WAY DivFree was (#18056): every term is totalized
`fderiv`, which is `0` off the differentiable locus, so a discontinuous u with
any p satisfies N = 0. `ContDiff ℝ 2 u` is required for `lap` to be the real
Laplacian (a second derivative); `Differentiable ℝ p` for `gradp` to be the
real gradient. DivFree is deliberately NOT here (grok (c)): momentum residual
≠ incompressibility; compose `DivFree u ∧ IsSteadyNS ν u p` where both are
meant. The totalization trap does not teach itself — it must be checked every
time a predicate is built on `fderiv`. -/
def IsSteadyNS (nu : ℝ) (u : V → V) (p : V → ℝ) : Prop :=
  ContDiff ℝ 2 u ∧ Differentiable ℝ p ∧ ∀ x, nsOp nu u p x = 0

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
theorem pc_differentiable : Differentiable ℝ pc := by
  intro x
  have h0 : HasFDerivAt (fun y : V => y 0) (EuclideanSpace.proj (0:Fin 3) : V →L[ℝ] ℝ) x :=
    (EuclideanSpace.proj (0:Fin 3) : V →L[ℝ] ℝ).hasFDerivAt
  have h1 : HasFDerivAt (fun y : V => y 1) (EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ) x :=
    (EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ).hasFDerivAt
  have hpc' : pc = fun y : V => (1/2 : ℝ) * (y 0 ^ 2 + y 1 ^ 2) := by funext y; simp [pc]; ring
  rw [hpc']
  exact (((h0.pow 2).add (h1.pow 2)).const_mul (1/2 : ℝ)).differentiableAt

theorem rot_contDiff : ContDiff ℝ 2 rot := rotL.contDiff

theorem rot_pc_steady (nu : ℝ) : IsSteadyNS nu rot pc := by
  refine ⟨rot_contDiff, pc_differentiable, ?_⟩
  intro x
  simp only [nsOp, convect_rot, gradp_pc, lap_rot, smul_zero, sub_zero]
  ext i; fin_cases i <;> simp

/-- C3: the same velocity with the WRONG pressure (p = 0) is NOT a steady solution —
at x = e₀ the operator is (−1, 0, 0). Pressure is load-bearing. -/
theorem rot_zero_pressure_not_steady (nu : ℝ) : ¬ IsSteadyNS nu rot (fun _ => 0) := by
  intro ⟨_, _, h⟩
  have hx := h (e 0)
  have hg : gradp (fun _ : V => (0:ℝ)) (e 0) = 0 := by
    simp only [gradp, pd, fderiv_const]; ext i; fin_cases i <;> simp
  simp only [nsOp, convect_rot, hg, lap_rot, smul_zero, sub_zero, add_zero] at hx
  have := congrArg (fun v : V => v 0) hx
  simp [e, PiLp.single_apply] at this

/-- C3b — grok's vacuity mutant, refuted: a discontinuous velocity (e₀ off the
origin, 0 at it) with ANY pressure fails `ContDiff ℝ 2` at 0. Under the OLD
predicate (∀x, N=0 alone) it was provably "steady" — `junk_old_steady` below
keeps that as the record of what the definition admitted. -/
def junk : V → V := fun x => if x = 0 then 0 else e 0

theorem junk_not_continuousAt : ¬ ContinuousAt junk 0 := by
  intro hc
  have h1 : Filter.Tendsto junk (nhds 0) (nhds (junk 0)) := hc
  simp only [junk, if_true] at h1
  have hlim : Filter.Tendsto (fun n : ℕ => junk ((1 / ((n:ℝ) + 1)) • e 0))
      Filter.atTop (nhds (e 0)) := by
    have hne : ∀ n : ℕ, junk ((1 / ((n:ℝ) + 1)) • e 0) = e 0 := by
      intro n; simp only [junk]; rw [if_neg]
      intro h; have := congrArg (fun v : V => v 0) h
      simp [e] at this
      exact absurd this (by positivity)
    simp only [hne]; exact tendsto_const_nhds
  have hto0 : Filter.Tendsto (fun n : ℕ => (1 / ((n:ℝ) + 1)) • e 0) Filter.atTop (nhds (0:V)) := by
    have h : Filter.Tendsto (fun n : ℕ => (1 / ((n:ℝ) + 1))) Filter.atTop (nhds (0:ℝ)) :=
      tendsto_one_div_add_atTop_nhds_zero_nat
    simpa using h.smul_const (e 0)
  have := tendsto_nhds_unique (h1.comp hto0) hlim
  have := congrArg (fun v : V => v 0) this
  simp [e] at this

/-- What the OLD predicate admitted (kernel-verified vacuity, kept on record):
with every fderiv totalized to 0 off the differentiable locus, N(junk, p) = 0
everywhere for any p — including p = 0. -/
theorem junk_old_steady_at_origin : nsOp 0 junk (fun _ => 0) 0 = 0 := by
  -- at the origin junk is not differentiable → all pd = 0; the convection sum,
  -- gradp of a constant, and lap all vanish
  have hnd : ¬ DifferentiableAt ℝ junk 0 := fun hd => junk_not_continuousAt hd.continuousAt
  simp only [nsOp, convect, gradp, lap, pd, fderiv_zero_of_not_differentiableAt hnd, fderiv_const]
  simp

theorem junk_not_steady (nu : ℝ) (p : V → ℝ) : ¬ IsSteadyNS nu junk p :=
  fun ⟨hc, _, _⟩ => junk_not_continuousAt (hc.continuous.continuousAt)

/-- C1: IsSteadyNS is satisfiable — it cannot prove False. Witnessed by the SMOOTH
pair (rot, pc), not by junk. -/
theorem steadyNS_consistent (nu : ℝ) :
    ¬ (∀ (u : V → V) (p : V → ℝ), IsSteadyNS nu u p → False) :=
  fun h => h rot pc (rot_pc_steady nu)

end
