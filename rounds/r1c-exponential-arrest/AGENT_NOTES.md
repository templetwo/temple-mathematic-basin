# agent6_1 — Rung 1(c), pass 6: viscous arrest WITH A RATE (E(t) ≤ E(0)·e^{−2νt}), uniform in N

This statement is exponential decay of the model energy along every HasDerivAt solution of the finite-N dyadic cascade of KP type with λ ≥ 1, ν ≥ 0, uniform in N; it is not a Navier–Stokes energy estimate (no pressure, no incompressibility, no Biot–Savart), and it does not claim solutions exist (no Picard).

## (a) What the theorem says (one sentence, typed honestly)

For every shell count N, every viscosity ν ≥ 0, every scale ratio λ ≥ 1, every horizon T, and every
map a : ℝ → (Fin N → ℝ) that satisfies SOL (HasDerivAt a (FIELD nu lam (a t)) t at every t ∈ [0,T)),
the model energy E(a t) = ½ Σₙ aₙ(t)² obeys

    E(a t) ≤ E(a 0) · exp(−2ν t)   for every t ∈ [0,T).

What is machine-checked:
- the derivative identity dE/dt = Σₙ aₙ·FIELDₙ along the solution (hasDerivAt_pi + product + sum rules);
- the cascade orthogonality Σₙ aₙ·CASCADEₙ = 0 (the `horth` induction on N, reused VERBATIM from
  rounds/r1-viscous-energy-antitone/attempts/01.txt);
- the pointwise bound dE/dt = −ν Σ λ^{2n} aₙ² ≤ −ν Σ aₙ² = −2ν E, using λ^{2n} ≥ 1 from λ ≥ 1;
- the Grönwall step: g(s) = E(a s)·exp(2νs) has derivative ≤ 0 on [0,t] ⊂ [0,T), hence g(t) ≤ g(0)
  (antitoneOn_of_deriv_nonpos on Icc 0 t), then unwind the integrating factor.

What a reader might over-read: this is a statement about a finite ODE system on Fin N → ℝ; there is no
PDE, no function space, no pressure/incompressibility/Biot–Savart, no existence or uniqueness of solutions
(if no solution exists on [0,T) the statement is vacuously true; if T ≤ 0 the statement is vacuous
because Ico 0 T is empty). "Uniform in N" means N is universally quantified and the constant in the
bound (namely 1, and the rate 2ν) does not depend on N — that is exactly what the ∀ N gives.

This is the first composition of two frozen rungs: Rung 1's energy identity (r1-viscous-energy-antitone)
supplies dE/dt ≤ −2νE, and Rung 2's Grönwall integrating-factor argument
(r2-gronwall-engine-of-bkm) turns it into the exponential bound. Neither frozen theorem is invoked by
name (harness forbids top-level defs / references), so both proofs are re-inlined; the shapes are the same.

## (b) Load-bearing hypotheses

- `1 ≤ lam` (λ ≥ 1): this is exactly where λ^{2n} ≥ 1 is used (`one_le_pow₀ hlam`), giving
  −ν λ^{2n} aₙ² ≤ −ν aₙ². Without it (e.g. 0 < λ < 1) the dissipation on high shells is weaker than ν
  and the rate 2ν is false in general (the honest rate would be 2ν·min_n λ^{2n} = 2ν λ^{2(N−1)}, which is
  NOT uniform in N). λ ≥ 1 is what makes the rate uniform in N.
- `0 ≤ nu` (ν ≥ 0): needed for the sign of the dissipation term (mul_nonneg hnu ...). ν = 0 gives the
  trivial bound E(a t) ≤ E(a 0)·exp(0) = E(a 0), consistent with the first integral of the inviscid
  cascade (energy conservation gives equality there; the ≤ is what this rung claims).
- SOL (HasDerivAt at every t ∈ Ico 0 T): supplies the coordinatewise derivatives via hasDerivAt_pi. The
  derivative is only used on [0,t] ⊂ [0,T); the endpoint 0 is in Ico 0 T because t ∈ Ico 0 T forces
  0 ≤ t < T, i.e. 0 < T.
- The cascade term never contributes: `horth` is a pure algebraic telescoping identity valid for every
  b : Fin N → ℝ and every λ (no hypothesis on λ or ν).

## (c) Mathlib names hunted for

- `one_le_pow₀ : 1 ≤ a → 1 ≤ a ^ n` (the current name for the old `one_le_pow_of_one_le'`).
- `hasDerivAt_id' : HasDerivAt (fun x => x) 1 x`, then `.const_mul (2 * nu)` and `.exp` give the
  derivative of exp(2νs) with the function already in the shape `fun x => Real.exp (2 * nu * x)`; the
  product `HasDerivAt.mul` produced the Pi-multiplication `(f * g)`, which was rewritten to `g` by
  `funext x; simp [hg]` exactly as in the r2 attempt.
- `antitoneOn_of_deriv_nonpos (convex_Icc 0 t)`, `interior_Icc`, `Set.Ioo_subset_Icc_self` — the same
  Grönwall scaffolding as rounds/r2-gronwall-engine-of-bkm/attempts/01.txt, but on Icc 0 t with the
  derivative hypotheses inherited from Ico 0 T via u ≤ t < T.
- `nlinarith` closed both the pointwise inequality (with the hint
  mul_nonneg (mul_nonneg hnu (sq_nonneg _)) (sub_nonneg.mpr hpow)) and the deriv g u ≤ 0 step (with the
  hint mul_le_mul_of_nonneg_right hr hex.le); linarith's monomial normal form treats the commuted products
  as the same atom.

## (d) What could NOT be proved

Nothing was dropped. The full target statement (as given in the task) compiles with exit 0, zero
warnings, on the first compile. No `sorry`, no `native_decide`, no `set_option`, only `import Mathlib`.

## Files

- work.lean, statement.txt, body.txt, gen.py (the generator that pastes the LAMBDAS verbatim; the
  asserts in gen.py check that CASC is a substring of FIELD and FIELD a substring of SOL).
