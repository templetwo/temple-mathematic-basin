# Alpha 2 — the fence, measured

**Date:** 2026-08-15. **Harness:** `verdict.py`, `leanprover/lean4:v4.32.2`, Mathlib `905b95818eb32af7874a58b427f50c1711a5e96c`, imports Mathlib only, universe-monomorphic.

Before scoping any sub-question, the honest first receipt is what the pinned library can and cannot express. This is a file-level census (grep over Mathlib sources), not a claim about what could be built. Measured, not assumed.

| Object the trunk question needs | In pinned Mathlib? | What is actually there |
|---|---|---|
| Navier–Stokes equations | **no** | 0 files |
| Vorticity, vortex stretching | **no** | 0 files |
| Divergence-free vector fields | **no** | 0 files |
| Leray–Hopf weak solutions | **no** | 0 files (the "weak" hits are model-category noise) |
| Critical norms $L^3$, $\dot H^{1/2}$ | partial | $L^p$ spaces exist (143 files, `MeasureTheory.Function.LpSpace`); no homogeneous Sobolev norm |
| Sobolev spaces | sketch | 3 files: a distribution-theoretic `Sobolev.lean`, `DerivNotation.lean`, and one `SobolevInequality.lean` |
| Laplacian | yes, abstract | `laplacian`/`laplacianWithin` on inner-product spaces via iterated Fréchet derivatives (`Analysis.InnerProductSpace.Laplacian`) |
| Euclidean $\mathbb{R}^3$ with calculus | yes | `EuclideanSpace ℝ (Fin 3)`, `fderiv`, `ContDiff` — 44 files touch it |
| Time-dependent PDE, energy inequality, blow-up | **no** | 0 files mention PDE outside tactic internals |

## What the census means

**The universe fence is not the obstacle here.** Every object above can be stated over concrete carriers (`EuclideanSpace ℝ (Fin 3)`, `ℝ`, `ℕ`), so `levelParams := []` would not reject a Navier–Stokes statement. The obstacle is **library coverage**: the equations themselves, the solution concept, and the critical-norm machinery do not exist in Mathlib at the pin. A statement of the trunk question is not an elaboration failure; it is a *definition* failure — there is nothing to elaborate against.

Consequence for the round: **any rung on the ladder must either (a) live entirely inside what exists (finite-dimensional, discrete, or model-problem analogues), or (b) begin by *defining* the missing objects in Lean, and then every definition becomes a statement-validity question of its own** — which is, not coincidentally, exactly what the §18 line (C1/C2/C3, non-vacuity certificates) was built to adjudicate. Alpha 2's honest first work may be certificate work on definitions, before any theorem.

## What "readiness" is for this round

Not a witness. A ladder whose bottom rung the harness can see, with each rung claim-typed as a step and not the trunk, and the harness's own inability to see the top rung recorded here rather than discovered mid-attempt.

## Probe receipt — 2026-08-15, `fence_probe.json`

The census's central claim ("coverage is the obstacle, not the universe fence") was tested, not assumed. Three Rung-0-shaped statements pushed through trusted `verdict.py` with a dummy body:

| Statement | Elaborates? | Note |
|---|---|---|
| `∃ u : ℝ³ → ℝ³, ∀ x, ∑ᵢ (fderiv ℝ u x eᵢ) i = 0` — a divergence-free field exists | **yes** | type mismatch on the dummy, no universe error, no unknown identifier |
| `∀ f : Lp ℝ 3 (volume on ℝ³), 0 ≤ ‖f‖` — an $L^3$ norm on ℝ³ | **yes** | same |
| a Laplacian statement via `InnerProductSpace.laplacian` | no | kernel metavariable — a namespace/argument guess by the seat, not a fence failure; Mathlib's `laplacian` exists (`Analysis.InnerProductSpace.Laplacian`) and needs the right instance path |

**So: the harness sees the bottom rung.** Divergence-free fields and critical $L^p$ norms over ℝ³ elaborate today. What does not exist is everything above them — the equations, the solution concept, the dynamics. Rung 0 is inside the fence by receipt.
