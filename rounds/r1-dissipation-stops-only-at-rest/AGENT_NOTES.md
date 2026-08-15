# agent_1 — Rung 1(a): viscous energy rate vanishes only at the zero state

## (a) What the theorem says (one sentence, typed honestly)

For every shell count N, every viscosity nu > 0 and every nonzero scale ratio lam, and every state
a : Fin N → ℝ, the instantaneous energy rate of the finite-N dyadic cascade of KP type,
Σ_n a_n · FIELD(nu, lam, a)_n, is zero if and only if a = 0.

Reading: **in the model, viscous dissipation stops only at rest — every nonzero state loses energy.**

What is machine-checked: the algebraic identity Σ a·field = −ν Σ (lam^n a_n)² (cascade part is
orthogonal to a) plus the fact that a finite sum of the strictly-positive-weighted squares vanishes
iff every coordinate vanishes. That is all.

What a reader might over-read: this is a statement about a finite ODE model (FIELD is a polynomial
vector field on ℝ^N with a diagonal damping term and a bilinear nearest-neighbour cascade). It has
no pressure, no Biot–Savart, no incompressibility, no spatial derivatives, no infinite-dimensional
limit. It is NOT a statement about the Navier–Stokes trunk. It says nothing about time evolution by
itself (no ODE solution appears in the statement) — only about the sign/vanishing of the energy
functional's rate along the vector field at a single state.

## (b) Load-bearing hypotheses

- `0 < nu` — strictly positive viscosity. Load-bearing for the → direction: with nu = 0 the rate is
  identically 0 for every a (that is exactly the inviscid first-integral rung), so the ↔ would be false.
  Only `hnu.le` is used for the nonnegativity of the terms and `hnu.ne'` for cancelling nu.
- `lam ≠ 0` — needed so that lam^n ≠ 0 for every shell index n; if lam = 0 the shells n ≥ 1 carry
  weight lam^{2n} = 0 and are invisible to the rate, so a nonzero a supported on those shells would have
  zero rate. Used through `pow_ne_zero`.
- The cascade orthogonality Σ b·cascade(b) = 0 is proved inline (the `horth` induction block reused
  VERBATIM from rounds/r1-viscous-energy-antitone/attempts/01.txt); it is what removes the cascade term
  and leaves only −ν Σ lam^{2n} a_n².
- Free `N : ℕ` bound by the outer ∀ (N : ℕ); the horth induction is on N with `b` universally
  quantified inside so the induction hypothesis has the right shape.

## (c) Mathlib names hunted / used

- `Finset.sum_eq_zero_iff_of_nonneg` — sum of nonneg terms is 0 iff each is 0 (statement over
  `∀ i ∈ s`, so the nonneg fact must be given as `∀ n ∈ Finset.univ, 0 ≤ ...`).
- `Finset.sum_neg_distrib`, `Finset.sum_add_distrib`, `neg_eq_zero`, `pow_ne_zero`, `mul_nonneg`,
  `sq_nonneg`, `Fin.val_castSucc` (not the deprecated `Fin.coe_castSucc`).
- Nothing exotic; `simpa [hnu.ne', hl] using hn` closes `nu * (lam^n * a n)^2 = 0 → a n = 0`
  (simp splits the product with `mul_eq_zero`, `pow_eq_zero_iff`).
- Note: I did not need `pow_mul` / `sq_pos_of_ne_zero`; rewriting the term as `nu * (lam ^ n.val * a n) ^ 2`
  by `ring` (as in the antitone rung's `hdiss`) sidesteps the `lam ^ (2 * n.val)` shape entirely.

## (d) Not proved / UNKNOWN

Nothing left unproved. Compile: `lake env lean tmp/agent_1/work.lean` → exit 0, no errors, no warnings
(empty output). No sorry / native_decide / decide / axiom / set_option; only `import Mathlib`.
