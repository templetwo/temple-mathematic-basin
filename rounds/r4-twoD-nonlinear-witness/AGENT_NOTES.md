# agent_4 — Rung 4 kernel witness: nonlinear 2D field, non-constant vorticity, zero stretching

## (a) What the theorem says (one sentence, claim-typed)

There exists a differentiable field u : ℝ³ → ℝ³ that is two-dimensional in the frozen sense (u₂ ≡ 0 and ∂₂u ≡ 0), whose curl takes two different values at two points (so vorticity is not constant, hence not the zero field and not a rigid rotation), and whose vortex-stretching term Σᵢ (curl u)ᵢ • ∂ᵢu vanishes at every point.

Witness: u x = (x₀·x₁, −x₁²/2, 0). Machine-checked facts about it, all inside the one theorem:
- ISTWOD u (both conjuncts, the ∂₂u = 0 one via the computed fderiv, not assumed);
- Differentiable ℝ u (from an explicit HasFDerivAt at every point — the totalization lesson: the derivative is real, not the fderiv-is-0-off-locus artifact);
- CURL u 0 ≠ CURL u e₀ (third component 0 vs −1; the derivative is genuinely x-dependent, so the field is nonlinear — the earlier witness rot is a CLM with constant vorticity (0,0,2));
- STRETCH u x = 0 for all x.

What a reader might over-read: this is NOT Ladyzhenskaya's 2D global regularity, nor a statement about NS solutions. It is one kernel-checked inhabitant of the 2D ring showing that the ∀-theorem in r4-twoD-zero-stretching (2D ⇒ zero stretching) has content beyond linear/constant-vorticity fields. Divergence-freeness of u is TRUE (∂₀u₀ + ∂₁u₁ = x₁ − x₁ = 0) but is NOT in the statement — the target shape did not ask for it. Ladyzhenskaya (2D ⇒ regular via BKM) remains CITED, not checked.

## (b) Load-bearing hypotheses

There are none in the ∀ sense — the theorem is purely existential. Internally load-bearing:
- The explicit HasFDerivAt (hD) drives everything: Differentiable, ∂₂u = 0, the per-direction partials hpd0/hpd1/hpd2, and via those both the curl-inequality and the stretch-vanishing. Without a real derivative, fderiv would be 0 and the curl-inequality conjunct would be false — that conjunct is what certifies the derivative is genuine.
- The choice of x = 0, y = e₀ for the curl inequality: curl u x = (0,0,−x₀), so the third component separates them.
- Stretch closes because ∂₂u = 0 (hpd2) and the horizontal curl components are 0 (both ∂ᵢu have zero third component and ∂₂u = 0), so every summand of Fin.sum_univ_three is either 0 • v or c • 0.

## (c) Mathlib names hunted

- No `HasFDerivAt.div_const` exists on this pin (only `HasDerivAt.div_const`). Rewrote −(x₁²)/2 as (−1/2) * x₁² in a `funext` equality (hf) and used `HasFDerivAt.const_mul` + `HasFDerivAt.pow` (derivative shape `(2 • x 1 ^ (2 - 1)) • proj 1`, taken as Lean gives it).
- `HasFDerivAt.mul` gives `x 0 • proj 1 + x 1 • proj 0` (that order); wrote the CLM in that order in hD rather than commuting.
- `HasFDerivAt.smul_const` yields `c'.smulRight v`; `ContinuousLinearMap.smulRight_apply` etc. are all default simp.
- Linter: `fin_cases i <;> simp <;> ring` triggers unnecessarySeqFocus when only one goal survives simp; split into `fin_cases i <;> simp` then `ring` on its own line.

## (d) Not proved / UNKNOWN

Nothing left unproved: all four conjuncts closed in one theorem. Compile: `lake env lean tmp/agent_4/work.lean` exit 0, no errors, no warnings. Divergence-free-ness of the witness was not part of the requested statement and is not claimed by the theorem (it is trivially true by the same hpd facts if a later round wants it: DIV u x = x₁ + (−x₁) + 0).
