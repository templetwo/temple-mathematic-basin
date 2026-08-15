# agent_3 — L^p scaling identity on ℝ³ with a REAL exponent (Rung 3, critical scaling)

## (a) What the theorem says — one sentence, typed honestly

For every real `lam > 0`, every vector field `u : ℝ³ → ℝ³` (no regularity, no integrability assumed), and EVERY real exponent `p`,

    ∫ ‖lam • u(lam • x)‖^p dx  =  lam^p · (lam^3)⁻¹ · ∫ ‖u x‖^p dx

where `^p` is `Real.rpow` and `lam^3` is `Monoid.npow`, both integrals being Mathlib's Bochner integral against Lebesgue `volume` on `EuclideanSpace ℝ (Fin 3)`.

MACHINE-CHECKED: the dilation algebra of the Bochner integral — pointwise homogeneity of `‖·‖^p` under the scalar factor `lam` (`norm_smul` + `Real.mul_rpow`), pulling the constant out (`integral_const_mul`), and the change-of-variables `x ↦ lam • x` on a finite-dimensional space (`Measure.integral_comp_smul`, Jacobian `|(lam^finrank)⁻¹| = (lam^3)⁻¹` with `finrank_euclideanSpace_fin`).

WHAT A READER MIGHT OVER-READ:
- This is NOT "‖u_λ‖_{L^p} = λ^{1−3/p} ‖u‖_{L^p}" as a statement about L^p norms of integrable functions. Integrability is NOT a hypothesis. Mathlib's Bochner integral is total: if `‖u‖^p` is not integrable, both sides are `0 = lam^p (lam^3)⁻¹ · 0`, which is true but vacuous. The identity is genuine algebra of the (total) integral; it becomes the L^p norm-scaling law exactly when `‖u‖^p ∈ L¹`, and Mathlib's `integral_comp_smul` does transport integrability, so nothing is lost — but the theorem as stated does not certify integrability of anything.
- Nothing about Navier–Stokes, no dynamics, no time variable. This is the spatial dilation `u ↦ lam • u(lam • ·)` only (the parabolic `λ²t` half of the NS scaling is not present).
- "L³ is critical" is the specialisation `p = 3` where `lam^p (lam^3)⁻¹ = 1` (via `Real.rpow_natCast`); that specialisation is NOT a separate theorem here, it is one line downstream. Ḣ^{1/2} criticality is CITED (Rung 3 spec), not defined or certified in this ring.
- This extends the frozen ring `r3-lp-scaling-identity` (p : ℕ, `Monoid.npow`) to `p : ℝ` (`Real.rpow`), so the natural-number family and the real family now both exist; the ℕ ring is the `Real.rpow_natCast` image of this one.

## (b) Load-bearing hypotheses and why

- `0 < lam` — load-bearing twice: `abs_of_pos hlam` turns `‖lam • v‖ = |lam| ‖v‖` into `lam ‖v‖` (needed for the base of `Real.mul_rpow`, which requires `0 ≤ lam`), and `abs_of_pos (inv_pos.mpr (pow_pos hlam 3))` removes the absolute value on the Jacobian `|(lam^3)⁻¹|`. For `lam < 0` the RHS would need `|lam|^p · |lam^3|⁻¹`; for `lam = 0` `Real.rpow` conventions make `0^p` piecewise and the identity fails in general.

- `0 ≤ p` — DECIDED: NOT NEEDED, and therefore NOT included. The delivered statement quantifies over ALL `p : ℝ`. Reasoning:
  * `Real.mul_rpow : 0 ≤ x → 0 ≤ y → (x*y)^z = x^z * y^z` has NO hypothesis on the exponent `z`. So the pointwise identity `‖lam • v‖^p = lam^p ‖v‖^p` holds for every real `p`, including negative `p`, under `0 < lam` and `0 ≤ ‖v‖`.
  * The worry "‖u x‖ can be 0 and 0^p is problematic for p < 0" is real analytically but harmless in Mathlib: `Real.zero_rpow : x ≠ 0 → 0^x = 0`, and `0^0 = 1`. So at a zero of `u`, both sides of the pointwise identity are `0` (p ≠ 0) or `1 = lam^0 · 1` (p = 0). No case split needed; `Real.mul_rpow` already absorbs it.
  * `Measure.integral_comp_smul` has no hypothesis on `R` (it uses `|(R^n)⁻¹|`, which is `0` at `R = 0` and correct there too), so nothing on the integral side needs `p ≥ 0` either.
  * Analytically, negative `p` means `‖u‖^p` is `+∞`-ish near zeros of `u`, but Mathlib's `rpow` puts `0` there and the total Bochner integral makes the identity trivially valid whether or not anything is integrable. So the honest minimal hypothesis is just `0 < lam`. Adding `0 ≤ p` would be a spurious hypothesis that a reader might take as evidence the identity fails for negative `p` — it does not, under Mathlib's conventions.
  * The `0 ≤ p →` variant was ALSO compiled (exit 0, zero warnings) with the identical body except `intro lam hlam u p _`. If the ring wants the hypothesis for shape-matching with the parent's plan, that body is a drop-in; the file was not delivered to keep ONE theorem per the brief.

- No `Differentiable`/`ContDiff`/`Integrable`/`Measurable` on `u` — none needed; no derivative appears and the Bochner integral is total.

## (c) Mathlib names hunted / confirmed on this pin (Lean 4.32.2)

- `Real.mul_rpow : 0 ≤ x → 0 ≤ y → (x * y) ^ z = x ^ z * y ^ z` (exponent unconstrained).
- `MeasureTheory.Measure.integral_comp_smul (μ) (f) (R) : ∫ x, f (R • x) ∂μ = |(R ^ Module.finrank ℝ E)⁻¹| • ∫ x, f x ∂μ` — used instead of `integral_comp_smul_of_nonneg` (which the ℕ ring used) because it needs no sign hypothesis and produces the `|(lam^3)⁻¹|` form that `abs_of_pos` closes.
- `finrank_euclideanSpace_fin : Module.finrank 𝕜 (EuclideanSpace 𝕜 (Fin n)) = n` (one rewrite; the ℕ ring used `finrank_euclideanSpace` + `Fintype.card_fin`).
- `Real.zero_rpow`, `Real.rpow_natCast` — consulted for the (b) decision, not used in the proof.
- Rpow/npow hygiene: `ring` was NOT invoked at all; the final goal after `smul_eq_mul` is `lam ^ p * ((lam ^ 3)⁻¹ * ∫ ...) = lam ^ p * (lam ^ 3)⁻¹ * ∫ ...`, closed by `mul_assoc`. So no risk of `ring` conflating `lam ^ p` (rpow) with `lam ^ 3` (npow) — the rpow term stays an opaque atom throughout.

## (d) Not proved / UNKNOWN

Nothing left unproved for the stated target. Explicitly out of scope and NOT claimed: the L^p norm law for `eLpNorm`/`MeasureTheory.Lp` (would need `Memℒp` transport), the parabolic time-scaling half of the NS symmetry, and any Ḣ^{1/2} statement (CITED only; not in Mathlib per FENCE.md).

Compile: `lake env lean tmp/agent_3/work.lean` → exit 0, no output (zero errors, zero warnings). SCALE lambda pasted verbatim from `tmp/LAMBDAS/SCALE.txt` (byte-checked). `statement.txt` + `body.txt` reconstruct `work.lean` byte-for-byte.
