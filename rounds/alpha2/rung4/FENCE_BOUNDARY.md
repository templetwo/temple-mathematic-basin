# Rung 4 — where the fence ends, recorded exactly

The full 2D Ladyzhenskaya global-regularity theorem needs, and the pinned Mathlib (905b958) lacks:

| Needed | Status in Mathlib at pin |
|---|---|
| Sobolev spaces H^s(ℝ²) with norms | 3-file distribution sketch; no normed Sobolev space |
| Ladyzhenskaya inequality ‖u‖₄² ≤ C‖u‖₂‖∇u‖₂ | absent |
| Gagliardo–Nirenberg / Sobolev embedding on ℝ² | one `SobolevInequality.lean` file; not the needed forms |
| Leray–Hopf weak solutions, energy inequality for PDE | absent (Rung 1's energy inequality is for the ODE model) |
| Vorticity transport equation ∂ₜω + u·∇ω = νΔω in 2D | statable from Rung 0 defs + a time variable; not proven |
| Uniqueness / continuation for the PDE | absent |

Estimated library cost to state and prove 2D global regularity: months. This is the rung the LADDER wrote as "where the fence ends," and the census agrees.

**What Rung 4 certified instead** — the MECHANISM, inside the fence today: for any differentiable 2D field (u₂ ≡ 0, ∂₂u = 0), the vortex-stretching term is identically zero (`stretch_twoD_zero`). Combined with the Rung 0 stretch witness (3D, stretch ≠ 0) and Rung 2's Grönwall engine of BKM, the kernel now holds the three pieces of the standard argument for why 2D is regular and 3D is open: no stretching ⇒ ‖ω‖ controlled ⇒ BKM's ∫‖ω‖_∞ finite ⇒ regularity. The links between them (the PDE estimates) are cited, not checked.
