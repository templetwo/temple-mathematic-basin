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
| D2 | `leray k w := if k = 0 then w else w − (kdot k w / ksq k) • kvec k` | the Leray projector P(k) = I − kkᵀ/‖k‖² for k ≠ 0; **P(0) = Id, PIECEWISE IN THE DEFINITION** (grok #18828 (1): ksq 0 = 0 divides by zero; the mean mode is already divergence-free) |
| D3 | `IsIncompressible B v := ∀ k ∈ B, kdot k (v k) = 0` | k·v̂_k = 0 — the geometry of incompressibility, mode by mode |
| D4 | `bilin B v k := leray k (∑ p ∈ B, ∑ q ∈ B, if p + q = k then (I·kdot q (v p)) • v q else 0)` | the projected convolution nonlinearity P(k)[(u·∇)u]^_k, RAW advective form, p and q both in B, evaluated at k ∈ B (p advects, q is differentiated — grok #18828 signed the index roles). Kept raw after grok's (2): the exact energy cancellation on a truncated SYMMETRIC box holds for the raw form under IsIncompressible + reality + box symmetry — numeric receipt `receipts/d4_cancellation_check.{py,out.txt}` (⟨v,N⟩ = 0 to 1e−15 on 27- and 125-mode boxes; O(1) failure when any one hypothesis is dropped); the proposed 'skew form' ½Σ i[(v̂_p·q)v̂_q − (v̂_q·p)v̂_p] is identically zero (relabel p↔q) and is not adopted |
| D5 | `galerkin ν B v k := −ν·(ksq k) • v k − bilin B v k` | the Galerkin field: −ν|k|² v̂_k − P(k)N(v)_k |
| D6 | `energy B v := ½ ∑ k ∈ B, ‖v k‖²`, `enstrophy B v := ½ ∑ k ∈ B, (ksq k)·‖v k‖²` | the two quadratic invariants |
No seventh definition without a dated re-registration. D1 and D6 are PACKAGES (3 + 2 functions) — the budget is six SLOTS, C1/C2/C3 per slot (grok #18828). Reality v̂_{−k} = conj v̂_k, box symmetry −k ∈ B, the spectral gap κ ≤ ksq k, and 0 ∉ B enter as inline HYPOTHESES on the statements that need them, never as named definitions (no `boxSymmetric`, no seventh slot).

## Rungs
| Rung | Content | What it puts in the kernel | Type line, in advance |
|---|---|---|---|
| **2b.0** | C1/C2/C3 for D1–D6 | vocabulary certified non-vacuous, boundaries where the author believes | instrument |
| **2b.1** | `leray k (kvec k) = 0` (k ≠ 0); `‖leray k w‖ ≤ ‖w‖`; `leray k (leray k w) = leray k w`; `kdot k (leray k w) = 0` | pressure kills the gradient; **the projector is a contraction** (grok #18651: that phrase, not "depletion"); idempotent; range is divergence-free | machine-checked linear algebra on ℂ³ per mode |
| **2b.2** | `IsIncompressible B v → ∀ k ∈ B, kdot k (galerkin ν B v k) = 0` | the Galerkin field preserves incompressibility. Typed precisely (grok #18828): the PROJECTED nonlinearity `bilin` is divergence-free for any v (2b.1: kdot k (leray k w) = 0, k ≠ 0); it is the VISCOUS term −ν·ksq k • v k where IsIncompressible is load-bearing — the first theorem anywhere in the lab where div-free is a load-bearing hypothesis | machine-checked; not the PDE |
| **2b.3** | energy identity: `Re ⟨v, galerkin ν B v⟩ = −ν ∑ ksq k ‖v k‖²` under IsIncompressible ∧ (∀ k ∈ B, v (−k) = conj (v k)) ∧ (∀ k ∈ B, −k ∈ B) — three HYPOTHESES, inline, no new definition | **energy conserved BECAUSE k·v̂_k = 0** — incompressibility doing work in the kernel. Mechanism to be kernel-checked: with reality, ⟨v,N⟩ = Σ_{p+q+r=0, p,q,r∈B} i(v̂_p·q)(v̂_q·v̂_r); the constraint set is q↔r symmetric; relabel and add ⇒ 2⟨v,N⟩ = Σ i(v̂_p·(q+r))(…) = −Σ i(v̂_p·p)(…) = 0. Exact on the truncated box (receipt above); the three hypotheses are each necessary (receipt: dropping any one fails O(1)) | trunk-track; the LOAD-BEARING rung; in a model that KEEPS pressure and div-free; box-uniform |
| **2b.4** | enstrophy balance: `Re ⟨ksq • v, galerkin ν B v⟩ = −ν ∑ (ksq k)² ‖v k‖² − Re ∑_k (ksq k)·⟨v k, bilin B v k⟩` — the triple product WRITTEN, not named | the closest fence-legal object to the trunk's dichotomy with pressure present; the triple product is unsigned and is not called "stretching wins" (grok #18828) | trunk-track; content is what is uniform in the box |
| **2b.5** | exponential arrest along Galerkin solutions under `0 ∉ B` and a spectral gap hypothesis `∀ k ∈ B, κ ≤ ksq k` (κ > 0): `energy B (v t) ≤ energy B (v 0)·exp(−2νκt)` (2b.3 + Grönwall) — RETYPED per grok #18828 (3): with 0 ∈ B the mean mode is undamped (ksq 0 = 0) and full-energy exponential arrest is FALSE; the mean mode is constant under IsIncompressible | arrest with a rate 2νκ, in a model with pressure; Galerkin cannot blow up (finite modes) — content is box-uniformity |
| **∞** | the trunk | held verbatim; not on the ladder | — |

**Refused in advance:** any ring that upgrades 2b to "the Navier–Stokes equations"; any Fourier-side Ḣ^s claim beyond finite
sums; any Picard/global existence claim; any per-rung count on the board.
