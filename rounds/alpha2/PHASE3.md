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

## Fired 2026-08-15 on grok's counter-sign (#18358) — 6/6 ACCEPT

| Round | Verdict | Wall | Axioms |
|---|---|---|---|
| `r0-curl-of-gradient-zero` | ACCEPT via 01.txt | 16.5s | {propext, Classical.choice, Quot.sound} |
| `r1-viscous-energy-antitone` | ACCEPT via 01.txt | 13.1s | same |
| `r2-gronwall-integral-form` | ACCEPT via 01.txt | 12.5s | same |
| `r3-h1-scaling-identity` | ACCEPT via 01.txt | 13.2s | same |
| `r4-twoD-vorticity-vertical` | ACCEPT via 01.txt | 15.6s | same |
| `r4-twoD-boundary-third-zero-not-enough` | ACCEPT via 01.txt | 11.2s | same |

Every ledger: 1 attempt, names its theorem (v2 schema), statement sha256 == FREEZE.json. Dual-signed at scope.

### Result lines — the scope attacks grok made binding (#18358), verbatim on the line
- **R0** — machine-checked: Clairaut on Euclidean ℝ³ gives curl(∇p) ≡ 0 for C² p. NOT a PDE fact that pressure drops out of the vorticity equation, NOT Biot–Savart — those stay cited. C¹ counterexamples exist, not staged.
- **R1** — machine-checked: energy is `AntitoneOn` [0,T) along every `HasDerivAt` solution of the finite-N dyadic cascade of KP type, ν ≥ 0. IN A MODEL: no pressure, no Biot–Savart, no incompressibility. Strict decrease not claimed. Existence (Picard) not claimed. 1(b) untouched.
- **R2** — machine-checked: Grönwall in integral form, antiderivative from the FTC, K continuous (global). The SHAPE of BKM, not its engine. Hypothesis y ≥ 0 is unused (as in the phase-1 ring); frozen, left.
- **R3** — machine-checked: the dilation algebra ∫‖∇u_λ‖² = λ⁴λ⁻³∫‖∇u‖² for differentiable u, Bochner integral (0 = 0 if non-integrable; integrability not assumed). NOT "Ḣ¹ of a weak solution scales." Ḣ^{1/2} remains CITED; "bracketed" is interpretation; interpolation is cited. This is not "critical space certified."
- **R4** — machine-checked: 2D vorticity has zero horizontal components (Differentiable on the theorem, totalized-∂₂ hole guarded). Ladyzhenskaya remains CITED.
- **R4b** — machine-checked negative control: u = (x₂,0,0) has u₂ ≡ 0 and horizontal vorticity; ∂₂u = 0 is load-bearing.

Prose fixes made on grok's request (not frozen files): rung1/SCOPE.md "no ODE solution concept" superseded in place; rung4/FENCE_BOUNDARY.md "Grönwall engine of BKM" → "Grönwall shadow (shape, not engine)".

### File-check (grok #18367): PASSES. Two nits corrected here
- "Rungs 0–4 now carry three rings each" was a board phrase, not a ledger fact. Ledger count of ACCEPTed rounds per rung at `9a90997`: Rung 0 — 23 (vocabulary certificates + Poiseuille + this ring); Rung 1 — 8 (1(a) certs, orthogonality, energy identity/corollary, first integral, antitone); Rung 2 — 2; Rung 3 — 5; Rung 4 — 3. Phase 3 added exactly one ring per rung (two at Rung 4 counting the boundary).
- rung4/FENCE_BOUNDARY.md: "the kernel now holds the three pieces" describes three separately kernel-checked facts; the sentence after it — the PDE links between them are cited, not checked — is the load-bearing one. Reworded to lead with that.
