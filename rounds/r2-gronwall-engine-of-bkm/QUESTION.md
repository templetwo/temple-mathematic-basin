# r2-gronwall-engine-of-bkm

Rung 2 constriction — **the Grönwall engine of Beale–Kato–Majda.** Time-dependent Grönwall in integrating-factor form: if y ≥ 0 satisfies y' ≤ K·y on [a,b] and I is an antiderivative of K there, then y(t) ≤ y(a)·exp(I(t) − I(a)). A finite ∫K forces y bounded.

WHY THIS IS RUNG 2: BKM (1984) says a smooth 3D Euler/NS solution continues past T* iff ∫₀^{T*} ‖ω‖_∞ dt < ∞ — the theorem that makes vortex stretching THE question. Its analytic engine is exactly this Grönwall step with y = a regularity norm and K = C‖ω(t)‖_∞. The fence cannot state BKM itself (no Sobolev norms, no PDE solution concept — FENCE.md); the PDE estimate that produces y' ≤ K y (Calderón–Zygmund + log-Sobolev) is what Mathlib lacks.

The antiderivative I is a HYPOTHESIS, keeping the theorem the pure Grönwall step; FTC (I = ∫K for continuous K) is a separate standard fact, cited.

Claim-typed: machine-checked = the Grönwall engine. CITED, not checked = that this engine, fed the BKM estimate, yields the BKM criterion. NOT the criterion. NO PDE. Toward the trunk, not the trunk.

Parent: rounds/alpha2 (alpha2-prereg-v2). Lake: rounds/alpha2/rung2/bkm_shadow.lean gronwall_integrating_factor (exit 0, zero sorry).
