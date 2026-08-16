# Alpha 2b — the fence, measured (2026-08-16)

Same harness as Alpha 2 (`verdict.py` sha `2face698964787a1…`, Lean 4.32.2, Mathlib `905b95818eb32af7874a58b427f50c1711a5e96c`,
universe-monomorphic, Mathlib-only). Five 2b-shaped statements pushed through trusted `verdict.py` with a dummy body
(`fence_probe.json`), all before any definition was written:

| Probe | Elaborates? | universe error | unknown identifier |
|---|---|---|---|
| Leray projector kills the gradient direction, `k ≠ 0` | yes | no | no |
| Leray projector is a contraction `‖P w‖ ≤ ‖w‖` on `EuclideanSpace ℂ (Fin 3)` | yes | no | no |
| a Galerkin energy-shaped statement with `starRingEnd ℂ` and `∑ k ∈ B, ‖v k‖²` | yes | no | no |
| the projected convolution double sum with `Complex.I` and `if p + q = k` | yes | no | no |
| the incompressibility predicate `∀ k ∈ B, k·v̂_k = 0` | yes | no | no |

**So the harness sees every 2b carrier today.** The obstacle, as in Alpha 2, is not the fence but the definitions — which
is why the ladder's first rung is certificate work (§2.7). What the fence does NOT see and 2b does not claim: the PDE, its
solutions, the Fourier transform, the limit box → ℤ³.
