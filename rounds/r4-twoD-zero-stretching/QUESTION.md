# r4-twoD-zero-stretching

Rung 4 constriction — **the mechanism of 2D regularity: two-dimensional fields have identically zero vortex stretching.** For any differentiable u : ℝ³ → ℝ³ with u₂ ≡ 0 and ∂₂u = 0, the term (ω·∇)u vanishes at every point. Vorticity in 2D is a scalar with only a vertical component, and there is nothing to stretch it along.

WHY THIS IS RUNG 4: Ladyzhenskaya's 2D global regularity is where the fence ends (rounds/alpha2/rung4/FENCE_BOUNDARY.md — Sobolev norms, Ladyzhenskaya inequality, weak solutions: months of library). Its MECHANISM is fence-legal and is the trunk's dichotomy in one line: no stretching in 2D (this round) vs. nonzero stretching in 3D (Rung 0's witness w, stretch (x₁,x₀,0) ≠ 0). Fed to BKM's engine (Rung 2), that is the standard reason 2D is regular and 3D is open — the links being cited, not checked.

Claim-typed: machine-checked = 2D ⇒ zero stretching. CITED = that this yields Ladyzhenskaya via BKM. NOT the 2D theorem. Toward the trunk, not the trunk.

Parent: rounds/alpha2 (alpha2-prereg-v2). Lake: rounds/alpha2/rung4/two_d_no_stretching.lean stretch_twoD_zero (exit 0, zero sorry).
