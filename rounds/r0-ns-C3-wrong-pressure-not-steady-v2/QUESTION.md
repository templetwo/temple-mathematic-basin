# r0-ns-C3-wrong-pressure-not-steady-v2

Rung 0 constriction · C3 for the NS OPERATOR (v2) — the SAME rigid rotation with the WRONG pressure p=0 is NOT a steady solution: it is smooth, so the refutation goes through the MOMENTUM RESIDUAL — N(e₀) = (−1,0,0). Pressure is load-bearing, for the right reason. Toward the trunk, not the trunk.

Parent: rounds/alpha2 (alpha2-prereg-v2). Predicate: IsSteadyNS ν u p := ContDiff ℝ 2 u ∧ Differentiable ℝ p ∧ ∀x, N(u,p)=0 — smoothness IN the Prop (grok #18193; same catch as DivFree #18056). DivFree deliberately separate (grok (c)). Momentum form ∂ₜu + N = 0. Lake: rounds/alpha2/rung0/ns_operator.lean exit 0.
