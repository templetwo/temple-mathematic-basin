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
  Differentiable ℝ u ∧ ∀ x, div u x = 0
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
        intro x y; ext i; fin_cases i <;> simp <;> ring
      map_smul' := by
        intro c x; ext i; fin_cases i <;> simp }

def rot : V → V := rotL

theorem rot_apply (x : V) (i : Fin 3) :
    rot x i = (![-(x 1), x 0, 0] : Fin 3 → ℝ) i := by
  simp [rot, rotL]

theorem pd_rot (i : Fin 3) (x : V) : pd rot i x = rot (e i) := by
  simp [pd, rot, rotL.fderiv]

/-- C2 for `DivFree`: rigid rotation is differentiable and divergence-free everywhere. -/
theorem rot_divFree : DivFree rot := by
  refine ⟨rotL.differentiable, ?_⟩
  intro x
  simp only [div, pd_rot]
  simp [rot_apply, e, PiLp.single_apply, Fin.sum_univ_three]

/-- C2 content check: the witness has NONZERO vorticity — `curl rot = (0,0,2)`. -/
theorem rot_vorticity (x : V) (i : Fin 3) :
    vorticity rot x i = (![0, 0, 2] : Fin 3 → ℝ) i := by
  simp only [vorticity, curl, pd_rot]
  fin_cases i <;> simp [rot_apply, e] <;> norm_num

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
      map_add' := by intro x y; ext i; fin_cases i <;> simp
      map_smul' := by intro c x; ext i; fin_cases i <;> simp }

def shear : V → V := shearL

theorem shear_apply (x : V) (i : Fin 3) :
    shear x i = (![x 0, 0, 0] : Fin 3 → ℝ) i := by
  simp [shear, shearL]

theorem pd_shear (i : Fin 3) (x : V) : pd shear i x = shear (e i) := by
  simp [pd, shear, shearL.fderiv]

theorem shear_div (x : V) : div shear x = 1 := by
  simp only [div, pd_shear]
  simp [shear_apply, e, PiLp.single_apply, Fin.sum_univ_three]

/-- C3 for `DivFree`: a named smooth non-example, refuted at a named point.
`shear` is differentiable (a CLM), so the refutation goes through the divergence
conjunct — it fails for the RIGHT reason, not by failing the smoothness guard. -/
theorem shear_not_divFree : ¬ DivFree shear := by
  intro ⟨_, h⟩
  have := h 0
  rw [shear_div] at this
  exact one_ne_zero this

/-! ## C3b — the vacuity mutant, refuted (mbp-grok #18056)

`junk x = if x = 0 then 0 else e₀`. Under the OLD definition (∀ x, div u x = 0
alone) this was provably DivFree — Lean's `fderiv` is `0` at the discontinuity
and off it `junk` is locally constant. `junk_old_divFree` below is that
kernel-verified vacuity, kept as the record of what the definition WAS
admitting. Under the NEW definition it is refuted: `junk` is not differentiable
at `0`, so the `Differentiable ℝ` conjunct fails — `junk_not_divFree`.
The mutant is now on the right side of the boundary. -/

def junk : V → V := fun x => if x = 0 then 0 else e 0

theorem junk_not_differentiableAt : ¬ DifferentiableAt ℝ junk 0 := by
  intro hd
  have h1 : Filter.Tendsto junk (nhds 0) (nhds (junk 0)) := hd.continuousAt
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

/-- What the OLD definition admitted (kernel-verified vacuity, kept on record). -/
theorem junk_old_divFree : ∀ x, div junk x = 0 := by
  intro x
  simp only [div, pd]
  by_cases hx : x = 0
  · subst hx
    rw [fderiv_zero_of_not_differentiableAt junk_not_differentiableAt]
    simp
  · have hloc : junk =ᶠ[nhds x] fun _ => e 0 := by
      have : {y : V | y ≠ 0} ∈ nhds x := isOpen_ne.mem_nhds hx
      filter_upwards [this] with y hy
      simp [junk, hy]
    rw [hloc.fderiv_eq]
    simp

/-- C3b: under the corrected definition, the vacuity mutant is refuted. -/
theorem junk_not_divFree : ¬ DivFree junk :=
  fun ⟨hd, _⟩ => junk_not_differentiableAt (hd 0)

/-! ## C1 — non-contradiction: `DivFree` is satisfiable, so it cannot prove `False`. -/
theorem divFree_consistent : ¬ (∀ u : V → V, DivFree u → False) :=
  fun h => h rot rot_divFree

end
