# Alpha 2 — Constriction phase 3 (Rungs 0–4), 2026-08-15

Anthony: "lets constrict further. rung 0-4". One ring per rung, each fence-legal, each a named
step closer to a trunk term than the phase-1/2 ring. Rung 1(b) is NOT touched — this constricts
1(a) and the model; the (b1)/(b2) re-target remains Anthony's.

| Round | Rung | Ring | S (sha256, 16) | Tightens |
|---|---|---|---|---|
| `r0-curl-of-gradient-zero` | 0 | curl(∇p) ≡ 0 for EVERY C² p (Clairaut via `isSymmSndFDerivAt`) | `76a35dbaad9311b2` | r0-curl-C3 (one gradient) → the class; pressure drops out of the vorticity equation |
| `r1-viscous-energy-antitone` | 1(a) | E(a t) `AntitoneOn` [0,T) along every solution, ν ≥ 0 | `91e11c34edc7c529` | rate ≤ 0 (algebra) + inviscid first integral → time-monotone for all ν ≥ 0 |
| `r2-gronwall-integral-form` | 2 | y(t) ≤ y(a)·exp(∫ₐᵗK), K continuous, via FTC | `82695011b274e464` | antiderivative-as-hypothesis → the literal integral (BKM's shape) |
| `r3-h1-scaling-identity` | 3 | ∫‖∇u_λ‖² = λ⁴λ⁻³∫‖∇u‖² on ℝ³ | `1340bcb06d7332ef` | s=½ tautology → Ḣ¹ (+½) and L² (−½) bracket Ḣ^{1/2} with real integrals |
| `r4-twoD-vorticity-vertical` | 4 | IsTwoD ∧ Differentiable → curl u x 0 = 0 ∧ curl u x 1 = 0 | `462ac4722cbac0e9` | stretch ≡ 0 → its mechanism: vorticity is a scalar |
| `r4-twoD-boundary-third-zero-not-enough` | 4 | u=(x₂,0,0): u₂≡0 but curl u 0 1 ≠ 0 | `c4896edc93df8014` | ∂₂u = 0 is load-bearing (positive negative control) |

State at staging: all six frozen (round.py), all six elaborate PASS, all six bodies preflight clean
(0 unused simp args, no PANIC, 0 errors), lake exit 0 on each source
(`rung*/phase3_*.lean`). ZERO attempts fired. Awaiting mbp-grok's §2.9 counter-sign.

Claim typing (every ring): machine-checked at its rung; toward the trunk, not the trunk. Rung 0 is
instrument; Rungs 1–4 trunk-track. Rung 1 result is IN A MODEL (rung1/SCOPE.md). Rung 2 is the
SHAPE of BKM, not its engine (rung2/SCOPE.md). Rung 3: Ḣ^{1/2} itself remains CITED (FENCE.md).
Rung 4: Ladyzhenskaya remains CITED (FENCE_BOUNDARY.md).
