import Mathlib

/-!
# Alpha 2 · Rung 0 — the definitions the trunk needs and Mathlib lacks

Written 2026-08-15 under alpha2-prereg-v1 §2.7: **definitions are
statements.** Every definition here is subject to the §18 certificate
before any theorem stands on it:
  C1 non-contradiction — the definition does not prove `False`
  C2 witness            — a kernel-checked term inhabits it (non-vacuous)
  C3 content/boundary   — a mutant is refuted, so the boundary is where
                          the author believes it is

Carriers are concrete (`EuclideanSpace ℝ (Fin 3)`, `ℝ`); no universe
parameters, so `verdict.py`'s fence admits every statement below.
Nothing here is Navier–Stokes. It is the vocabulary Navier–Stokes is
written in, certified to mean what it says. Claim-typed: **toward the
trunk, not the trunk.**

Conventions: `V := EuclideanSpace ℝ (Fin 3)`; a vector field is `V → V`;
the `i`-th partial of `f` at `x` is `fderiv ℝ f x (e i)` with
`e i := EuclideanSpace.single i 1`. All operators are total (Lean's
`fderiv` is `0` where `f` is not differentiable), which is exactly the
totalization trap §18.5 warns about. The first draft of this header said
the `Differentiable` hypothesis would live on theorems, not in the
definition — and mbp-grok (board #18056) proved that choice vacuous with
a discontinuous field that was provably `DivFree`. So `DivFree` now
carries `Differentiable ℝ u` IN THE PROP; the header is corrected to
match (grok #18077 caught the stale text). `div`, `curl`, `stretch`
themselves stay total operators; the Prop-level predicates carry the
smoothness guard.
-/

noncomputable section
open scoped Matrix

abbrev V := EuclideanSpace ℝ (Fin 3)

/-- The standard basis direction. -/
def e (i : Fin 3) : V := EuclideanSpace.single i 1

/-- `i`-th partial derivative of a scalar or vector field at `x`. -/
def pd {W : Type} [NormedAddCommGroup W] [NormedSpace ℝ W]
    (f : V → W) (i : Fin 3) (x : V) : W :=
  fderiv ℝ f x (e i)

/-- **Divergence** of a vector field: `∑ᵢ ∂ᵢ uᵢ`. -/
def div (u : V → V) (x : V) : ℝ :=
  ∑ i : Fin 3, pd u i x i

/-- **Divergence-free** (incompressible) on all of `V`.

Carries `Differentiable ℝ u` IN THE PROP. Without it, Lean's totalized
`fderiv` (which returns `0` wherever `u` is not differentiable) makes every
discontinuous or nowhere-differentiable field trivially "divergence-free" —
kernel-verified by `junk_divFree` in `certs.lean` (mbp-grok's attack,
board #18056, 2026-08-15). A definition that admits Weierstrass junk does
not mean incompressible. This is §18.5's totalization trap, caught by the
other seat before any theorem stood on it. -/
def DivFree (u : V → V) : Prop :=
  Differentiable ℝ u ∧ ∀ x, div u x = 0

/-- **Curl** (vorticity) as a vector field, via the standard cross-product
formula `(∂₂u₃ − ∂₃u₂, ∂₃u₁ − ∂₁u₃, ∂₁u₂ − ∂₂u₁)`. Built with Mathlib's
`crossProduct` on the underlying `Fin 3 → ℝ`, treating the partial-derivative
operator symbolically: `curl u x = ∇ ⨯₃ u` where `∇` is realized as the
matrix of partials `Jᵢⱼ = ∂ⱼ uᵢ`. -/
def curl (u : V → V) (x : V) : V :=
  WithLp.toLp 2
    ![ pd u 1 x 2 - pd u 2 x 1,
       pd u 2 x 0 - pd u 0 x 2,
       pd u 0 x 1 - pd u 1 x 0 ]

/-- **Vorticity** is the curl of the velocity. Named separately because the
trunk question is *about* it. -/
def vorticity (u : V → V) : V → V := curl u

/-- **Vortex stretching term** `(ω · ∇) u` — the term the trunk question
asks whether can win. -/
def stretch (u : V → V) (x : V) : V :=
  ∑ i : Fin 3, (vorticity u x i) • pd u i x

end
