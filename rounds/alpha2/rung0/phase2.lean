import Mathlib

/-!
# Phase 2 constriction — grok's list, items #1, #2, #9

#1  ONE-SIGN curl mutant (tightens the coarse three-sign C3b of #18123):
    flip ONLY the sign of the second term of the z-component. On rigid rotation
    the mutant gives z = ∂₀u₁ + ∂₁u₀ = 1 + (−1) = 0 where the true curl gives 2.
    Refuted by a one-token edit — the boundary is tight.

#2  POISEUILLE-TYPE witness — a steady NS solution with Δu ≠ 0 (Rung 0.5, #18193(b)):
    u = (x₁², 0, 0), p = 2ν·x₀. Then (u·∇)u = 0 (u₀ depends only on x₁),
    ∇p = (2ν, 0, 0), Δu = (2, 0, 0), so N = 0 + 2ν − ν·2 = 0. Divergence-free.
    N = 0 ONLY because νΔu balances ∇p: with ν = 0 and the same p, N = (2ν,0,0)…
    i.e. this p is the wrong pressure for the inviscid equation. VISCOSITY IS
    LOAD-BEARING — the counterpart to rotation's "pressure is load-bearing."

#9  Differentiable INTO IsTwoD (#18249): the named 2D predicate now carries it,
    so ∂₂u = 0 is a real derivative and the predicate cannot be satisfied by
    junk. The frozen r4 theorem stays valid (it guarded with Differentiable);
    this makes the predicate itself honest for standalone use.
-/

noncomputable section

abbrev V := EuclideanSpace ℝ (Fin 3)
def e (i : Fin 3) : V := EuclideanSpace.single i 1
def pd {W : Type} [NormedAddCommGroup W] [NormedSpace ℝ W]
    (f : V → W) (i : Fin 3) (x : V) : W := fderiv ℝ f x (e i)
def curl (u : V → V) (x : V) : V :=
  WithLp.toLp 2 ![ pd u 1 x 2 - pd u 2 x 1, pd u 2 x 0 - pd u 0 x 2, pd u 0 x 1 - pd u 1 x 0 ]
def convect (u : V → V) (x : V) : V := ∑ i : Fin 3, (u x i) • pd u i x
def gradp (p : V → ℝ) (x : V) : V := WithLp.toLp 2 ![pd p 0 x, pd p 1 x, pd p 2 x]
def lap (u : V → V) (x : V) : V := ∑ i : Fin 3, pd (pd u i) i x
def nsOp (nu : ℝ) (u : V → V) (p : V → ℝ) (x : V) : V := convect u x + gradp p x - nu • lap u x
def IsSteadyNS (nu : ℝ) (u : V → V) (p : V → ℝ) : Prop :=
  ContDiff ℝ 2 u ∧ Differentiable ℝ p ∧ ∀ x, nsOp nu u p x = 0

/-! ## #1 one-sign mutant -/
def curlOneSign (u : V → V) (x : V) : V :=
  WithLp.toLp 2 ![ pd u 1 x 2 - pd u 2 x 1, pd u 2 x 0 - pd u 0 x 2, pd u 0 x 1 + pd u 1 x 0 ]

def rotL : V →L[ℝ] V :=
  LinearMap.toContinuousLinearMap
    { toFun := fun x => WithLp.toLp 2 ![-(x 1), x 0, 0]
      map_add' := by intro x y; ext i; fin_cases i <;> simp <;> ring
      map_smul' := by intro c x; ext i; fin_cases i <;> simp }
def rot : V → V := rotL
theorem pd_rot (i : Fin 3) (x : V) : pd rot i x = rot (e i) := by simp [pd, rot, rotL.fderiv]
theorem rot_apply (x : V) (i : Fin 3) : rot x i = (![-(x 1), x 0, 0] : Fin 3 → ℝ) i := by simp [rot, rotL]

theorem oneSign_mutant_refuted : curlOneSign rot 0 ≠ curl rot 0 := by
  intro h
  have := congrArg (fun v : V => v 2) h
  simp only [curlOneSign, curl, pd_rot] at this
  simp [rot_apply, e] at this
  norm_num at this

/-! ## #2 Poiseuille-type witness -/
/-- u = (x₁², 0, 0) -/
def pois : V → V := fun x => WithLp.toLp 2 ![x 1 ^ 2, 0, 0]
/-- p = 2ν x₀ -/
def ppois (nu : ℝ) : V → ℝ := fun x => 2 * nu * x 0

theorem pois_hasFDerivAt (x : V) :
    HasFDerivAt pois ((EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ).smulRight
      ((2 * x 1) • e 0)) x := by
  have h1 : HasFDerivAt (fun y : V => y 1) (EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ) x :=
    (EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ).hasFDerivAt
  have hsq := (h1.mul h1)
  have hf : pois = fun y : V => (y 1 * y 1) • e 0 := by
    funext y; ext i; fin_cases i <;> simp [pois, e, sq]
  rw [hf]
  have hprod : ((fun y : V => y 1) * fun y : V => y 1 : V → ℝ) = fun y : V => y 1 * y 1 := by
    funext y; simp
  rw [hprod] at hsq
  have := hsq.smul_const (e 0)
  refine this.congr_fderiv ?_
  ext v; simp [add_smul, smul_smul]; ring

theorem pd_pois (i : Fin 3) (x : V) : pd pois i x = (2 * x 1 * e i 1) • e 0 := by
  simp only [pd, (pois_hasFDerivAt x).fderiv, ContinuousLinearMap.smulRight_apply]
  simp [smul_smul]
  congr 1; ring

theorem pois_contDiff : ContDiff ℝ 2 pois := by
  have hf : pois = fun y : V => (y 1 * y 1) • e 0 := by
    funext y; ext i; fin_cases i <;> simp [pois, e, sq]
  rw [hf]
  have h1 : ContDiff ℝ 2 (fun y : V => y 1) := (EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ).contDiff
  exact (h1.mul h1).smul_const (e 0)

theorem ppois_differentiable (nu : ℝ) : Differentiable ℝ (ppois nu) := by
  have : ppois nu = fun y : V => (2 * nu) * y 0 := by funext y; simp [ppois]
  rw [this]
  exact ((EuclideanSpace.proj (0:Fin 3) : V →L[ℝ] ℝ).differentiable).const_mul _

/-- (pois·∇)pois = 0: u₀ depends only on x₁ and only u₀ ≠ 0, so u₀·∂₀u = 0. -/
theorem convect_pois (x : V) : convect pois x = 0 := by
  simp only [convect, Fin.sum_univ_three, pd_pois]
  ext i; fin_cases i <;> simp [pois, e]

theorem gradp_ppois (nu : ℝ) (x : V) : gradp (ppois nu) x = WithLp.toLp 2 ![2 * nu, 0, 0] := by
  have hd : ∀ i, pd (ppois nu) i x = 2 * nu * e i 0 := by
    intro i
    have : ppois nu = fun y : V => (2 * nu) * y 0 := by funext y; simp [ppois]
    simp only [pd, this]
    have h0 : HasFDerivAt (fun y : V => y 0) (EuclideanSpace.proj (0:Fin 3) : V →L[ℝ] ℝ) x :=
      (EuclideanSpace.proj (0:Fin 3) : V →L[ℝ] ℝ).hasFDerivAt
    rw [(h0.const_mul (2 * nu)).fderiv]
    simp
  simp only [gradp, hd]
  ext i; fin_cases i <;> simp [e]

/-- Δpois = (2, 0, 0): ∂₁∂₁ of x₁² -/
theorem lap_pois (x : V) : lap pois x = WithLp.toLp 2 ![2, 0, 0] := by
  simp only [lap, Fin.sum_univ_three]
  have h : ∀ i : Fin 3, pd (pd pois i) i x = (2 * e i 1 * e i 1) • e 0 := by
    intro i
    have : pd pois i = fun y => (2 * y 1 * e i 1) • e 0 := funext (pd_pois i)
    rw [this]
    simp only [pd]
    have h1 : HasFDerivAt (fun y : V => y 1) (EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ) x :=
      (EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ).hasFDerivAt
    have hl : HasFDerivAt (fun y : V => (2 * y 1 * e i 1) • e 0)
        (((EuclideanSpace.proj (1:Fin 3) : V →L[ℝ] ℝ).smulRight ((2 * e i 1) • e 0))) x := by
      have := ((h1.const_mul 2).mul_const (e i 1)).smul_const (e 0)
      refine this.congr_fderiv ?_
      ext v; simp [smul_smul, ContinuousLinearMap.smulRight_apply, mul_comm, mul_left_comm]
    rw [hl.fderiv]
    simp [smul_smul]
    congr 1; ring
  simp only [h]
  ext i; fin_cases i <;> simp [e]

/-- C2 (Rung 0.5): the Poiseuille-type pair is a steady solution — Δu ≠ 0, viscosity balances pressure. -/
theorem pois_steady (nu : ℝ) : IsSteadyNS nu pois (ppois nu) := by
  refine ⟨pois_contDiff, ppois_differentiable nu, ?_⟩
  intro x
  simp only [nsOp, convect_pois, gradp_ppois, lap_pois, zero_add]
  ext i; fin_cases i <;> simp <;> ring

/-- Δpois ≠ 0: this witness genuinely exercises the viscous term. -/
theorem lap_pois_ne_zero (x : V) : lap pois x ≠ 0 := by
  intro h; have := congrArg (fun v : V => v 0) h; simp [lap_pois] at this

/-- VISCOSITY IS LOAD-BEARING: with the SAME pressure but ν' ≠ ν, not steady. -/
theorem pois_wrong_viscosity (nu nu' : ℝ) (h : nu ≠ nu') : ¬ IsSteadyNS nu' pois (ppois nu) := by
  intro ⟨_, _, hs⟩
  have hx := hs 0
  simp only [nsOp, convect_pois, gradp_ppois, lap_pois, zero_add] at hx
  have := congrArg (fun v : V => v 0) hx
  simp at this
  exact h (by linarith)

/-! ## #9 Differentiable INTO IsTwoD -/
def IsTwoD (u : V → V) : Prop :=
  Differentiable ℝ u ∧ (∀ x, u x 2 = 0) ∧ (∀ x, pd u 2 x = 0)

end
