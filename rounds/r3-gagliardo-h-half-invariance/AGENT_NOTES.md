# agent6_3 — Rung 3, pass 6: dilation invariance of the Ḣ^{1/2}(ℝ³) Gagliardo–Slobodeckij double integral

This statement is the dilation invariance of the Gagliardo–Slobodeckij Ḣ^{1/2}(ℝ³) double integral for the Navier–Stokes scaling (Bochner integral on ℝ³×ℝ³; 0 = 0 if non-integrable, integrability not assumed); it is not the Fourier-side Ḣ^{1/2} norm (their equivalence is cited), and it says nothing about solutions or about the Escauriaza–Seregin–Šverák criterion.

## (a) What the theorem says

For every λ > 0 and every u : ℝ³ → ℝ³ (no regularity, no integrability assumed),

  ∫∫ ‖u_λ(x) − u_λ(y)‖² / ‖x − y‖⁴ dx dy = ∫∫ ‖u(x) − u(y)‖² / ‖x − y‖⁴ dx dy,   u_λ(x) = λ u(λx),

where the integral is Mathlib's Bochner integral against `volume` on `EuclideanSpace ℝ (Fin 3) × EuclideanSpace ℝ (Fin 3)` (the product Lebesgue measure). Exponent 4 = n + 2s with n = 3, s = 1/2, so this is exactly the scale-invariance of the homogeneous Ḣ^{1/2} seminorm in its real-space (Gagliardo–Slobodeckij) form.

What is machine-checked: the pointwise identity `‖λu(λx) − λu(λy)‖²/‖x−y‖⁴ = λ⁶ · F(λ•z)` for F(z) = ‖u z.1 − u z.2‖²/‖z.1 − z.2‖⁴ (including the diagonal x = y, where both sides are 0 by Lean's 0/0 = 0 convention), and the change of variables z ↦ λ•z on ℝ⁶ = ℝ³ × ℝ³ under the add-Haar measure `volume` (Jacobian |λ⁻⁶|), so λ⁶ · λ⁻⁶ = 1.

What a reader might over-read:
- Integrability is NOT assumed. If either double integral diverges (u ∉ Ḣ^{1/2}, or u not measurable), Mathlib's Bochner integral is 0 and the identity is 0 = 0. The equality is genuine whenever u ∈ Ḣ^{1/2}, but the theorem does not certify finiteness.
- This is the real-space Gagliardo–Slobodeckij double integral, not the Fourier multiplier ‖ |ξ|^{1/2} û ‖_{L²}. Their equivalence (up to a dimensional constant) is a cited fact, not proved here.
- Nothing about Navier–Stokes solutions, the pressure, or the ESŠ / critical-space regularity criteria. It is the scaling identity for the *object* only.
- The Lean `‖·‖^2 / ‖·‖^4` uses natural-number powers of the Euclidean norm; the "1/2" lives only in the exponent 4 = 3 + 2·(1/2).

## (b) Load-bearing hypotheses

- `0 < lam` — needed for `abs_of_pos` (|λ| = λ in `norm_smul`), for `|(λ⁶)⁻¹| = (λ⁶)⁻¹`, and for `λ⁶ · (λ⁶)⁻¹ = 1` (λ ≠ 0). For λ < 0 the identity would still hold with |λ| but the proof as written uses positivity; λ = 0 would break the cancellation.
- No hypothesis on u at all: `Differentiable`, measurability, integrability are all absent because the pointwise identity is purely algebraic and `MeasureTheory.Measure.integral_comp_smul` holds for arbitrary f (both sides 0 when non-integrable).

## (c) Mathlib names hunted for

- The Haar instance on the product: instance search does NOT find `IsAddHaarMeasure` for `volume` on `V × V` automatically (`infer_instance` fails on this pin). Fix: supply it explicitly, `haveI : (volume : Measure (V × V)).IsAddHaarMeasure := MeasureTheory.Measure.prod.instIsAddHaarMeasure _ _` (the `to_additive` twin of `prod.instIsHaarMeasure` in `Mathlib/MeasureTheory/Group/Measure.lean`; `volume = volume.prod volume` is `rfl` via `prod.measureSpace`, `Measure.volume_eq_prod`). Rewriting the goal with `MeasureTheory.Measure.volume_eq_prod` then `infer_instance` also works.
- `Module.finrank_prod` + `finrank_euclideanSpace_fin` gives finrank ℝ (V × V) = 3 + 3, and the resulting `lam ^ (3 + 3)` is accepted by `pow_pos hlam 6` / `pow_ne_zero 6` (defeq 3+3 = 6).
- `Prod.smul_fst`, `Prod.smul_snd` for `(lam • z).1 = lam • z.1`; `smul_sub`, `norm_smul`, `Real.norm_eq_abs`, `mul_pow`.
- Diagonal case handled by `rcases eq_or_ne (‖z.1 - z.2‖ ^ 4) 0`; off-diagonal, `field_simp` (with the `ne` hypothesis and `hlam` in context) closes the rational identity by itself; a trailing `ring` is unnecessary and triggers "no goals".

## (d) What was and was not proved

- Required target (s = 1/2, exponent 4): PROVED. `work.lean` compiles exit 0, zero warnings.
- General s (factor λ^{2s−1}): IN REACH and verified as a probe, not delivered as the round statement. `probe_general_s.lean` in this directory proves, for all real s and λ > 0,
  ∫ ‖u_λ z.1 − u_λ z.2‖² / ‖z.1 − z.2‖ ^ (3 + 2s) = λ ^ (2s − 1) · ∫ ‖u z.1 − u z.2‖² / ‖z.1 − z.2‖ ^ (3 + 2s)   (rpow exponents),
  by the same route plus `Real.mul_rpow`, `Real.rpow_natCast`, `Real.rpow_add`, `Real.rpow_neg`, `ring_nf` on exponents. It also compiles exit 0 with no warnings. Only s = 1/2 was required, so the delivered statement is the s = 1/2 one with natural-number exponent 4, which is the exact shape requested.
- Nothing UNKNOWN for this rung.
