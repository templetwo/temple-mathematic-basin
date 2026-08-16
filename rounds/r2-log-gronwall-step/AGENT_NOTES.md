This statement is the logarithmic Grönwall step (linear Grönwall applied to 1 + log y), the shape of the last step of the Beale–Kato–Majda argument; it is not BKM's engine — the estimate ‖∇u‖_∞ ≲ ‖ω‖_∞(1 + log⁺‖ω‖_{H^s}) that produces the log is Calderón–Zygmund + a Sobolev inequality and is outside the fence, cited.

# agent6_2 — Rung 2, pass 6 (log-Grönwall / BKM double-exponential shape)

## (a) What is machine-checked

For real functions y, y', K on ℝ and a ≤ b: if K is continuous, y has derivative y' at every point of [a,b],
y ≥ 1 on [a,b], and y' ≤ K·y·(1 + log y) on [a,b], then for every t ∈ [a,b]

    1 + log (y t) ≤ (1 + log (y a)) · exp (∫_a^t K).

Equivalently (a reader may unwind, but the kernel did NOT check this rewrite):
y(t) ≤ exp((1 + log y(a))·e^{∫K} − 1) — the double-exponential bound. What is checked is exactly the
log-linear form above. Nothing about vorticity, ∇u, Calderón–Zygmund, Sobolev, or any PDE is in the statement;
the "1 + log" is a bare hypothesis on a scalar ODE inequality. Do not over-read this as "BKM formalized".

## (b) Load-bearing hypotheses

- `Continuous K` — used twice: FTC (`intervalIntegral.integral_hasDerivAt_right` for the antiderivative
  I(u) = ∫_a^u K) and interval integrability.
- `HasDerivAt y (y' t) t` on Icc — differentiates y, then `HasDerivAt.log` gives z' = y'/y for z = 1 + log y.
- `1 ≤ y t` on Icc — load-bearing for `y t ≠ 0` (so `HasDerivAt.log` applies and log y is the honest log, not
  Real.log's junk value at 0) and for `0 < y t` so `div_le_iff₀` turns y' ≤ K y (1+log y) into y'/y ≤ K(1+log y).
- `y' t ≤ K t * y t * (1 + log (y t))` — the log-linear differential inequality; the whole content.
- `a ≤ b` — carried for shape only (unused in the proof, as in r2-gronwall-integral-form; the conclusion is
  vacuous if a > b since Icc a b = ∅).

DROPPED hypothesis, per the parent's invitation: `∀ t ∈ Icc a b, 0 ≤ K t`. It is not needed. The Grönwall
step compares g := (1 + log y)·exp(−I) and shows g' = (y'/y − K(1+log y))·exp(−I) ≤ 0, which uses only
z' ≤ K z; no sign of K, and no sign of z either (z ≥ 0 is likewise not needed for this argument, though it
happens to hold since y ≥ 1). The theorem as delivered is therefore strictly stronger than the requested shape
with the K ≥ 0 conjunct; the statement is otherwise the requested shape verbatim. In BKM's application K = ‖ω‖_∞
is nonnegative anyway, so nothing is lost by the extra generality.

## (c) Mathlib names hunted

- `HasDerivAt.log` (needs `y s ≠ 0`), `HasDerivAt.const_add` (to get 1 + log ∘ y).
- `div_le_iff₀` (current name; `div_le_iff` is deprecated on this pin).
- Everything else is the body of rounds/r2-gronwall-integral-form/attempts/01.txt re-derived inline on z:
  `intervalIntegral.integral_hasDerivAt_right`, `Continuous.intervalIntegrable`,
  `Continuous.stronglyMeasurableAtFilter`, `antitoneOn_of_deriv_nonpos`, `interior_Icc`,
  `mul_nonpos_of_nonpos_of_nonneg`, `mul_le_mul_of_nonneg_right`, `Real.exp_add`, `Real.exp_pos`.

## (d) Not proven / UNKNOWN

Nothing left unproven for this target. Compile: `lake env lean tmp/agent6_2/work.lean` exit 0, no errors,
no warnings; `#print axioms` gives only [propext, Classical.choice, Quot.sound].
Not attempted (and out of scope by the type line): the y(t) ≤ exp((1+log y(a))e^{∫K} − 1) rewrite, and anything
resembling the CZ/Sobolev logarithmic inequality that would feed K and the log into this step.
