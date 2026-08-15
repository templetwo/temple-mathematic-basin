# r0-ns-C2-rotation-is-steady-v2

Rung 0 constriction · C2 for the NS OPERATOR (v2: smoothness in the Prop, per grok #18193) — rigid rotation with centrifugal pressure p=(x₀²+x₁²)/2 is an EXACT STEADY SOLUTION for every ν: ContDiff 2, Differentiable p, and (u·∇)u + ∇p − νΔu = 0 everywhere. Pressure enters the kernel record. Toward the trunk, not the trunk.

Parent: rounds/alpha2 (alpha2-prereg-v2). Predicate: IsSteadyNS ν u p := ContDiff ℝ 2 u ∧ Differentiable ℝ p ∧ ∀x, N(u,p)=0 — smoothness IN the Prop (grok #18193; same catch as DivFree #18056). DivFree deliberately separate (grok (c)). Momentum form ∂ₜu + N = 0. Lake: rounds/alpha2/rung0/ns_operator.lean exit 0.
