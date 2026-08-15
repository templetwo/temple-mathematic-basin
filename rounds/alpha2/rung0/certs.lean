import Mathlib

/-!
# Alpha 2 · Rung 0 — certificates for the definitions

Companion to `defs.lean` (byte-copies of the defs below, enforced by
`scripts/check_rung0_defs.py`).

The §18 certificate, per definition:
  C1 — the definition does not prove `False` (non-contradiction)
  C2 — a kernel-checked witness inhabits it, WITH CONTENT
  C3 — a mutant is refuted positively (boundary is where claimed)

Claim-typed: toward the trunk, not the trunk. Nothing here is a theorem
about Navier–Stokes; it is proof that the vocabulary means what it says.
-/

noncomputable section

abbrev V := EuclideanSpace ℝ (Fin 3)
def e (i : Fin 3) : V := EuclideanSpace.single i 1
def pd {W : Type} [NormedAddCommGroup W] [NormedSpace ℝ W]
    (f : V → W) (i : Fin 3) (x : V) : W :=
  fderiv ℝ f x (e i)
def div (u : V → V) (x : V) : ℝ :=
  ∑ i : Fin 3, pd u i x i
def DivFree (u : V → V) : Prop :=
  ∀ x, div u x = 0
def curl (u : V → V) (x : V) : V :=
  WithLp.toLp 2
    ![ pd u 1 x 2 - pd u 2 x 1,
       pd u 2 x 0 - pd u 0 x 2,
       pd u 0 x 1 - pd u 1 x 0 ]
def vorticity (u : V → V) : V → V := curl u
def stretch (u : V → V) (x : V) : V :=
  ∑ i : Fin 3, (vorticity u x i) • pd u i x

/-! ## C2 witnesses — positive kernel facts

`rot` is rigid rotation about the third axis, `x ↦ (−x₁, x₀, 0)`:
linear, hence smooth; divergence-free; vorticity `(0,0,2)` everywhere.
So `DivFree` is inhabited by something with NONZERO curl, which is what
makes the witness non-vacuous for the trunk's purposes.
-/

/-- Rigid rotation about the third axis, as a continuous linear map. -/
def rotL : V →L[ℝ] V :=
  LinearMap.toContinuousLinearMap
    { toFun := fun x => WithLp.toLp 2 ![-(x 1), x 0, 0]
      map_add' := by
        intro x y; ext i; fin_cases i <;> simp [PiLp.toLp_apply]
      map_smul' := by
        intro c x; ext i; fin_cases i <;> simp [PiLp.toLp_apply] }

def rot : V → V := rotL

theorem rot_apply (x : V) (i : Fin 3) :
    rot x i = (![-(x 1), x 0, 0] : Fin 3 → ℝ) i := by
  simp [rot, rotL, PiLp.toLp_apply]

theorem pd_rot (i : Fin 3) (x : V) : pd rot i x = rot (e i) := by
  simp [pd, rot, rotL.fderiv]

/-- C2 for `DivFree`: rigid rotation is divergence-free everywhere. -/
theorem rot_divFree : DivFree rot := by
  intro x
  simp only [div, pd_rot]
  simp [rot_apply, e, PiLp.single_apply, Fin.sum_univ_three]

/-- C2 content check: the witness has NONZERO vorticity — `curl rot = (0,0,2)`. -/
theorem rot_vorticity (x : V) (i : Fin 3) :
    vorticity rot x i = (![0, 0, 2] : Fin 3 → ℝ) i := by
  simp only [vorticity, curl, pd_rot]
  fin_cases i <;> simp [rot_apply, e, PiLp.single_apply, PiLp.toLp_apply] <;> norm_num

theorem rot_vorticity_ne_zero (x : V) : vorticity rot x ≠ 0 := by
  intro h
  have := congrArg (fun v : V => v 2) h
  simp [rot_vorticity] at this

/-! ## C3 — the boundary, refuted positively

`shear x = (x₀, 0, 0)` has divergence 1, so it is NOT divergence-free.
A kernel refutation `¬ DivFree shear` with the witness point named,
not a failed proof of `DivFree shear`.
-/

def shearL : V →L[ℝ] V :=
  LinearMap.toContinuousLinearMap
    { toFun := fun x => WithLp.toLp 2 ![x 0, 0, 0]
      map_add' := by intro x y; ext i; fin_cases i <;> simp [PiLp.toLp_apply]
      map_smul' := by intro c x; ext i; fin_cases i <;> simp [PiLp.toLp_apply] }

def shear : V → V := shearL

theorem shear_apply (x : V) (i : Fin 3) :
    shear x i = (![x 0, 0, 0] : Fin 3 → ℝ) i := by
  simp [shear, shearL, PiLp.toLp_apply]

theorem pd_shear (i : Fin 3) (x : V) : pd shear i x = shear (e i) := by
  simp [pd, shear, shearL.fderiv]

theorem shear_div (x : V) : div shear x = 1 := by
  simp only [div, pd_shear]
  simp [shear_apply, e, PiLp.single_apply, Fin.sum_univ_three]

/-- C3 for `DivFree`: a named non-example, refuted at a named point. -/
theorem shear_not_divFree : ¬ DivFree shear := by
  intro h
  have := h 0
  rw [shear_div] at this
  exact one_ne_zero this

/-! ## C1 — non-contradiction: `DivFree` is satisfiable, so it cannot prove `False`. -/
theorem divFree_consistent : ¬ (∀ u : V → V, DivFree u → False) :=
  fun h => h rot rot_divFree

end
