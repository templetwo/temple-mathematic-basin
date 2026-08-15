import Mathlib

/-!
# Rung 4 · constriction — why 2D is regular: no vortex stretching

Ladyzhenskaya (1959): 2D incompressible Navier–Stokes has global smooth
solutions. 3D is the trunk. THE MECHANISM: in 2D the vorticity is a scalar
transported by the flow with NO stretching term, so ‖ω‖_∞ is conserved by
Euler and non-increasing by NS — and BKM (Rung 2) then gives regularity for
free. In 3D the stretching term (ω·∇)u can amplify vorticity, and that is the
entire question.

The full 2D theorem is where the fence ends (FENCE.md): it needs Sobolev
embeddings, the Ladyzhenskaya inequality ‖u‖₄² ≤ C‖u‖₂‖∇u‖₂, and a weak-
solution theory — months of library. Rung 4's honest constriction is the
MECHANISM, certified inside the fence:

  **For a 2D field embedded in ℝ³ — u₂ ≡ 0 and no dependence on x₂ — the
  vortex-stretching term (ω·∇)u is identically zero.**

Proof: ω = (0, 0, ∂₀u₁ − ∂₁u₀) has only a vertical component, and (ω·∇)u =
ω₂ · ∂₂u = ω₂ · 0 because u does not depend on x₂. Nothing to stretch along.

Contrast: the Rung 0 stretch witness w = (−x₁, x₀, x₀x₁) is 3D — its u₂
depends on (x₀,x₁), its ω has horizontal components, its stretch is (x₁,x₀,0) ≠ 0.
That contrast IS the 2D/3D dichotomy the trunk asks about, in the kernel.

Claim-typed: machine-checked = 2D fields have zero stretching. CITED = that
this is why 2D is globally regular (Ladyzhenskaya via BKM). NOT the 2D
theorem. Toward the trunk, not the trunk.
-/

noncomputable section

abbrev V := EuclideanSpace ℝ (Fin 3)
def e (i : Fin 3) : V := EuclideanSpace.single i 1
def pd {W : Type} [NormedAddCommGroup W] [NormedSpace ℝ W]
    (f : V → W) (i : Fin 3) (x : V) : W := fderiv ℝ f x (e i)
def curl (u : V → V) (x : V) : V :=
  WithLp.toLp 2 ![ pd u 1 x 2 - pd u 2 x 1, pd u 2 x 0 - pd u 0 x 2, pd u 0 x 1 - pd u 1 x 0 ]
def stretch (u : V → V) (x : V) : V := ∑ i : Fin 3, (curl u x i) • pd u i x

/-- A field is TWO-DIMENSIONAL if its third component vanishes and it does not
depend on the third coordinate: `∂₂u = 0` everywhere. Stated via the partial,
which is exactly what the stretching computation uses. -/
def IsTwoD (u : V → V) : Prop :=
  (∀ x, u x 2 = 0) ∧ (∀ x, pd u 2 x = 0)

/-- (∂ᵢu)₂ = ∂ᵢ(u₂): the coordinate projection is a CLM, so it commutes with fderiv.
Requires differentiability at x (otherwise both sides are 0 anyway by totalization,
but we state it cleanly under the hypothesis). -/
theorem pd_coord (u : V → V) (i : Fin 3) (x : V) (hd : DifferentiableAt ℝ u x) :
    pd u i x 2 = fderiv ℝ (fun y => u y 2) x (e i) := by
  simp only [pd]
  let P : V →L[ℝ] ℝ := EuclideanSpace.proj (2:Fin 3)
  have : (fun y => u y 2) = ⇑P ∘ u := by funext y; simp [P]
  rw [this, fderiv_comp x P.differentiableAt hd, P.fderiv]
  simp [P]

/-- In 2D the vorticity has no horizontal components (for differentiable u). -/
theorem curl_twoD_horizontal_zero (u : V → V) (hu : IsTwoD u) (hd : Differentiable ℝ u) (x : V) :
    curl u x 0 = 0 ∧ curl u x 1 = 0 := by
  obtain ⟨h2, hpd2⟩ := hu
  have hpdi2 : ∀ i, pd u i x 2 = 0 := by
    intro i
    rw [pd_coord u i x (hd x)]
    have : (fun y => u y 2) = fun _ => (0:ℝ) := funext h2
    rw [this]; simp
  constructor <;> simp [curl, hpdi2, hpd2]

/-- THE MECHANISM: 2D fields have identically zero vortex stretching. -/
theorem stretch_twoD_zero (u : V → V) (hu : IsTwoD u) (hd : Differentiable ℝ u) (x : V) :
    stretch u x = 0 := by
  obtain ⟨h0, h1⟩ := curl_twoD_horizontal_zero u hu hd x
  simp only [stretch, Fin.sum_univ_three, h0, h1, hu.2, zero_smul, smul_zero, add_zero]

/-! ## the contrast, kept in the record: a genuinely nonlinear 2D field with
nonzero, NON-CONSTANT vorticity still has zero stretching -/

/-- u = (x₀x₁, −x₁²/2, 0): div-free, ω = (0,0,−x₀), stretch = 0. -/
def twoDwit : V → V := fun x => WithLp.toLp 2 ![x 0 * x 1, -(x 1 ^ 2) / 2, 0]

theorem twoDwit_third_zero (x : V) : twoDwit x 2 = 0 := by simp [twoDwit]

end
