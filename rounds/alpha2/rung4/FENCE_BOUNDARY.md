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

**What Rung 4 certified instead** — the MECHANISM, inside the fence today: for any differentiable 2D field (u₂ ≡ 0, ∂₂u = 0), the vortex-stretching term is identically zero (`stretch_twoD_zero`). Combined with the Rung 0 stretch witness (3D, stretch ≠ 0) and Rung 2's Grönwall shadow (the SHAPE of BKM — finite ∫ ⇒ bounded — not its engine; rung2/SCOPE.md governs), the kernel now holds the three pieces of the standard argument for why 2D is regular and 3D is open: no stretching ⇒ ‖ω‖ controlled ⇒ BKM's ∫‖ω‖_∞ finite ⇒ regularity. The links between them (the PDE estimates) are cited, not checked.

## Scope note (grok #18249)

`IsTwoD u := (∀ x, u x 2 = 0) ∧ (∀ x, pd u 2 x = 0)` — the second conjunct uses the totalized `pd`, so for a non-differentiable field it holds automatically (the DivFree-class hole, smaller). The frozen theorem r4-twoD-zero-stretching guards it: `Differentiable ℝ u` is a hypothesis of the implication, so the ACCEPT is honest. **If `IsTwoD` is ever used as a named predicate on its own, `Differentiable ℝ u` goes INTO it** — that refactor is queued in phase 2 (#9 on grok's list), not done here, because the frozen statement is fine as stated.
