# Alpha 2 — Constriction phase 4 (one slight ring per rung; 1(b) PROPOSED, held), 2026-08-15

Anthony: "proceed" · "constrict" · "we gotta move to rung 3 / or the next rung. we can only advance
slightly on each." Policy from here: one slight ring per rung per pass; do not grind a rung.

Rung 1(b): (b2) finite-N top-shell concentration was PROPOSED by the seat and, in the first draft of this
pass, written as "selected" on the strength of Anthony's "proceed". **Grok #18428 ruled that a seat
inference, not a §2.1 selection** — Anthony's words were process words. Corrected: `rung1b/SELECTION.md` now
says PROPOSED; the r1b freeze is math-signed and UNFIRED until Anthony names it.

| Round | Rung | Ring | S (16) | Advance |
|---|---|---|---|---|
| `r1b-inviscid-top-shell-monotone` | 1(b) | top shell `MonotoneOn` [0,T), ν=0, 0≤λ, every solution | `18941c383dd7edfc` | first (b2) ring: the SIGNED top-shell amplitude does not decrease (not energy — grok #18428) |
| `r2-bkm-logical-shape` | 2 | bounded ∫ₐᵗK on [a,b) ⇒ y bounded on [a,b) | `cb9cc18067b1aae1` | BKM's contrapositive shape: blow-up needs ∫K = ∞ |
| `r3-vorticity-scaling` | 3 | curl u_λ (x) = λ²·curl u (λx) | `4e99ff340f35ba54` | vorticity exponent 2 (R0↔R3 bridge; ∫‖ω‖_∞dt scale-invariance CITED) |
| `r4-twoD-vorticity-nonzero` | 4 | rot is IsTwoD, differentiable, curl = (0,0,2) ≠ 0 | `20ac12f64fee5026` | vertical-vorticity ring is not vacuous |
| `r0-stretch-quadratic` | 0 | stretch(c·u) = c²·stretch u | `c184a6cd35f79cd1` | nonlinearity degree 2 on the vocabulary |

Sources: `rung1b/ring1_top_shell_monotone.lean`, `rung2/phase4_bkm_shape.lean` (also holds the R3, R4
theorems), `rung0/phase4_stretch_quadratic.lean`. All five frozen, elaborate PASS, preflight clean.
ZERO fired. Awaiting mbp-grok §2.9 sign.

Not staged (next pass): 1(b) ring 2 — viscous top-shell balance with the threshold `a_{N−2}² ≥ νλ^{N−1}a_{N−1}` as an iff.

## Fired 2026-08-15 on grok's counter-sign (#18428) — 4/4 ACCEPT; r1b HELD

| Round | Verdict | Wall | Axioms |
|---|---|---|---|
| `r2-bkm-logical-shape` | ACCEPT via 01.txt | 53.7s | {propext, Classical.choice, Quot.sound} |
| `r3-vorticity-scaling` | ACCEPT via 01.txt | 48.4s | same |
| `r4-twoD-vorticity-nonzero` | ACCEPT via 01.txt | 46.1s | same |
| `r0-stretch-quadratic` | ACCEPT via 01.txt | 54.9s | same |
| `r1b-inviscid-top-shell-monotone` | **UNFIRED** — math counter-signed, selection not made by Anthony | — | — |

### Result lines — grok's scope attacks binding (#18428)
- **R2** — machine-checked: bounded ∫ₐᵗK on [a,b) ⇒ y bounded on [a,b), K continuous, y ≥ 0 load-bearing. A NEW Ico ring, not a kernel corollary of the Icc freeze. Shape of BKM, not engine.
- **R3** — machine-checked: curl u_λ(x) = λ²·curl u(λx), the Jacobian identity, no sign on λ. Scale-invariance of ∫‖ω‖_∞dt is CITED; there is no time in the statement.
- **R4** — machine-checked: rot is a real 2D field with curl (0,0,2); content for the vertical-vorticity ring.
- **R0** — machine-checked: degree-2 homogeneity on the vocabulary. Instrument. Not a trunk fact about stretching winning.
- **R1b (held)** — if fired: machine-checked that the SIGNED AMPLITUDE a_{N−1} is MonotoneOn [0,T), ν=0, λ≥0. NOT "energy concentrates upward" (a_{N−1}<0 → ½a² falls). IN A MODEL. Not blow-up.

## r1b fired 2026-08-16 on Anthony's naming ("fire the signed freeze under the amended phrase")
`r1b-inviscid-top-shell-monotone` — ACCEPT via 01.txt, 105.4s, axioms {propext, Classical.choice, Quot.sound},
provenance seat-authored, S == FREEZE. **Result line:** machine-checked that the SIGNED amplitude a_{N−1} is
`MonotoneOn` [0,T) along every inviscid solution (0 < N, 0 ≤ λ) — the truncation boundary is absorbing because
a_N := 0 deletes the exit term. Not energy. Not "stretching wins". Not blow-up. IN A MODEL. Grok math-sign #18428.
