# Alpha 2b — the ladder (hypothesis space)

**Why a new ladder.** After Alpha 2's six passes, the trunk's terms *non-local pressure depletion* and *geometry of
incompressibility* have zero kernel content (advisor 2026-08-16 §A, grok #18651): pressure appears only leaving the
vorticity equation or as a matching field; div u = 0 is never a load-bearing hypothesis; the dyadic model deletes both by
design. Alpha 2b is the fence-legal object that keeps them: **a finite-mode Fourier–Galerkin truncation of the
incompressible Navier–Stokes equations on the torus 𝕋³, with the Leray projector.** Everything is a finite sum over a
box of wavevectors; no Fourier analysis, no distributions, no solutions of the PDE enter the kernel. "Galerkin
truncation of NS" is CITED as the model's name exactly as "of KP type" was for Alpha 2's cascade.

**Carriers (all concrete, universe-monomorphic, fence-probed — `fence_probe.json`):** wavevectors `k : Fin 3 → ℤ`; a
finite box `B : Finset (Fin 3 → ℤ)`; amplitudes `v : (Fin 3 → ℤ) → EuclideanSpace ℂ (Fin 3)`; ν : ℝ.

## Definition budget — SIX, named now (PREREG 2b §2.7: each is a statement, C1/C2/C3 before any theorem stands on it)
| # | Definition | Meaning |
|---|---|---|
| D1 | `kdot k w := ∑ᵢ (kᵢ : ℂ)·wᵢ`, `ksq k := ∑ᵢ kᵢ²`, `kvec k := (kᵢ : ℂ)ᵢ` | wavevector pairings |
| D2 | `leray k w := w − (kdot k w / ksq k) • kvec k` | the Leray projector P(k) = I − kkᵀ/‖k‖² (k ≠ 0; k = 0 by convention: mean mode) |
| D3 | `IsIncompressible B v := ∀ k ∈ B, kdot k (v k) = 0` | k·v̂_k = 0 — the geometry of incompressibility, mode by mode |
| D4 | `bilin B v k := leray k (∑ p ∈ B, ∑ q ∈ B, if p + q = k then (I·kdot q (v p)) • v q else 0)` | the projected convolution nonlinearity P(k)[(u·∇)u]^_k |
| D5 | `galerkin ν B v k := −ν·(ksq k) • v k − bilin B v k` | the Galerkin field: −ν|k|² v̂_k − P(k)N(v)_k |
| D6 | `energy B v := ½ ∑ k ∈ B, ‖v k‖²`, `enstrophy B v := ½ ∑ k ∈ B, (ksq k)·‖v k‖²` | the two quadratic invariants |
No seventh definition without a dated re-registration. Reality condition v̂_{−k} = conj v̂_k enters as a HYPOTHESIS where
needed (2b.3), not a definition.

## Rungs
| Rung | Content | What it puts in the kernel | Type line, in advance |
|---|---|---|---|
| **2b.0** | C1/C2/C3 for D1–D6 | vocabulary certified non-vacuous, boundaries where the author believes | instrument |
| **2b.1** | `leray k (kvec k) = 0` (k ≠ 0); `‖leray k w‖ ≤ ‖w‖`; `leray k (leray k w) = leray k w`; `kdot k (leray k w) = 0` | pressure kills the gradient; **the projector is a contraction** (grok #18651: that phrase, not "depletion"); idempotent; range is divergence-free | machine-checked linear algebra on ℂ³ per mode |
| **2b.2** | `IsIncompressible B v → ∀ k ∈ B, kdot k (galerkin ν B v k) = 0` | the Galerkin field preserves incompressibility — the first theorem anywhere in the lab where div-free is LOAD-BEARING | machine-checked; not the PDE |
| **2b.3** | energy identity: `Re ⟨v, galerkin ν B v⟩ = −ν ∑ ksq k ‖v k‖²` under IsIncompressible + reality + box symmetry | **energy conserved BECAUSE k·v̂_k = 0** — incompressibility doing work in the kernel (the nonlinear triple sum cancels; finite, algebraic, hard) | trunk-track; in a model that KEEPS pressure and div-free; box-uniform |
| **2b.4** | enstrophy balance with the stretching triple product explicit and UNSIGNED | the closest fence-legal object to "stretching vs arrest with pressure present" | trunk-track; content is what is uniform in the box |
| **2b.5** | exponential arrest of `energy` along Galerkin solutions (2b.3 + Grönwall) | arrest with a rate, in a model with pressure | trunk-track; Galerkin cannot blow up (finite modes) — content is box-uniformity |
| **∞** | the trunk | held verbatim; not on the ladder | — |

**Refused in advance:** any ring that upgrades 2b to "the Navier–Stokes equations"; any Fourier-side Ḣ^s claim beyond finite
sums; any Picard/global existence claim; any per-rung count on the board.
