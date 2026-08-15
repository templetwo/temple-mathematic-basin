# agent_2 — Rung 2, the BKM shadow (vector-valued Grönwall, constant K)

## (a) What the theorem says (one sentence, typed honestly)

If `w : ℝ → EuclideanSpace ℝ (Fin 3)` is differentiable on `[a,b]` with derivative `w'` and `‖w' t‖ ≤ K‖w t‖` there for a constant `K ≥ 0`, then `‖w t‖ ≤ ‖w a‖ · exp(K (t − a))` for all `t ∈ [a,b]`.

**Machine-checked:** exactly that ODE-inequality statement about an arbitrary curve in ℝ³ (Euclidean norm), constant `K`, closed interval.

**What a reader might over-read, and must not:**
- This is the **SHAPE** of Beale–Kato–Majda (a bound on the growth rate of vorticity controls vorticity), **not its engine**. Nothing here is a PDE. `w` is any curve; nothing ties it to a velocity field, to `curl`, or to a Navier–Stokes/Euler solution. The vorticity-stretching commutator estimate (Biot–Savart + Calderón–Zygmund + the log-Sobolev bound producing `‖ω'‖ ≤ K‖ω‖`) is outside the fence and is NOT supplied here — the growth-rate bound is a HYPOTHESIS.
- `K` is a **constant**. The time-dependent-`K` (integrating-factor) case is the earlier scalar rings (`rounds/alpha2/rung2/bkm_shadow.lean`, `gronwall_integrating_factor`); this ring does not subsume them and they do not subsume this one (this one is vector-valued, norm-shaped).
- Same reading discipline as `rounds/alpha2/rung2/SCOPE.md`: an ACCEPT here is Grönwall, never "we have BKM's engine."

## PRIOR ART — this is a REPLICATION of Mathlib

The whole content is `norm_le_gronwallBound_of_norm_deriv_right_le` (Mathlib.Analysis.ODE.Gronwall) with `ε = 0`, plus `gronwallBound_ε0 : gronwallBound δ K 0 x = δ * exp (K * x)`. Signature on this pin (all of `δ K ε a b` implicit, `E` any normed space):

```
theorem norm_le_gronwallBound_of_norm_deriv_right_le {f f' : ℝ → E} {δ K ε : ℝ} {a b : ℝ}
    (hf : ContinuousOn f (Icc a b)) (hf' : ∀ x ∈ Ico a b, HasDerivWithinAt f (f' x) (Ici x) x)
    (ha : ‖f a‖ ≤ δ) (bound : ∀ x ∈ Ico a b, ‖f' x‖ ≤ K * ‖f x‖ + ε) :
    ∀ x ∈ Icc a b, ‖f x‖ ≤ gronwallBound δ K ε (x - a)
```

The body's only work is transport: `HasDerivAt` on `Icc` ⇒ `ContinuousOn` on `Icc` (via `continuousAt.continuousWithinAt`) and `HasDerivWithinAt … (Ici x) x` on `Ico` (via `.hasDerivWithinAt` + `Ico_subset_Icc_self`); the bound is padded with `+ 0` to match Mathlib's `ε` slot; `δ := ‖w a‖` with `le_rfl`; then `rwa [gronwallBound_ε0]`.

## (b) Load-bearing hypotheses

- `∀ t ∈ Icc a b, HasDerivAt w (w' t) t` — load-bearing: gives both `ContinuousOn w (Icc a b)` and the right-derivative on `Ico a b` that Mathlib's lemma consumes. (Mathlib only needs the derivative on `Ico` and continuity on `Icc`; the statement asks slightly more, on the closed interval, which is the natural fence-shape.)
- `∀ t ∈ Icc a b, ‖w' t‖ ≤ K * ‖w t‖` — load-bearing: it IS the Grönwall input (only the `Ico` part is used).
- `a ≤ b` — **unused** by the proof (Mathlib's lemma quantifies over `Icc a b`, which is empty when `b < a`). Kept because it is in the requested statement shape; introduced as `_`.
- `0 ≤ K` — **unused** by the proof. Mathlib's `norm_le_gronwallBound_of_norm_deriv_right_le` holds for any real `K` (with `K < 0` the bound is a decay bound and still true). Kept for statement shape; introduced as `_`. Same class as the unused `y ≥ 0` noted in rung2/SCOPE.md.

## (c) Mathlib names hunted

- `norm_le_gronwallBound_of_norm_deriv_right_le` — `/lean/.lake/packages/mathlib/Mathlib/Analysis/ODE/Gronwall.lean` line 134; confirmed all scalar params implicit on this pin.
- `gronwallBound_ε0` — same file, line 78: `gronwallBound δ K 0 x = δ * exp (K * x)`.
- `Set.Ico_subset_Icc_self`, `HasDerivAt.hasDerivWithinAt`, `HasDerivAt.continuousAt`, `ContinuousAt.continuousWithinAt` — standard.

## (d) Not proved / UNKNOWN

Nothing left unproved for the stated target. Compile: `lake env lean tmp/agent_2/work.lean` exit 0, no errors, no warnings (verified statement.txt + body.txt reassemble byte-for-byte to work.lean modulo trailing whitespace).

What this ring cannot do (by design, not failure): produce the hypothesis `‖w' t‖ ≤ K‖w t‖` for actual vorticity from the Navier–Stokes/Euler equations. That is the BKM engine and it is outside the fence.
