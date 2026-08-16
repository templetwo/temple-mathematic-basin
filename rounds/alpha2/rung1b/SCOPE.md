# Rung 1(b) — scope, binding on every result line

- IN A MODEL: finite-N dyadic cascade of KP type. No pressure, no Biot–Savart, no incompressibility geometry.
- ~~"Stretching wins" here means TOP-SHELL CONCENTRATION~~ **Struck 2026-08-16 (advisor B4):** the phrase
  "stretching wins" is dropped from 1(b) entirely. The honest phrase for ring 1 is **"the truncation boundary is
  absorbing (inviscid)"**: da_{N−1}/dt = λ^{N−1}a_{N−2}² ≥ 0 only because a_N := 0 deleted the exit term. It is a
  Galerkin boundary condition, not a dynamical statement about stretching. It does NOT mean blow-up — no norm collapses at
  finite N (energy first integral). It does NOT mean anything about the trunk's ℝ³ cascade.
- Solution concept is `HasDerivAt a (field ν λ (a t)) t` on [0,T). Existence (Picard) is NOT claimed.
- Hypothesis `0 ≤ λ` on ring 1: the KP model has λ > 1; the theorem is stated under the weaker
  hypothesis it actually needs (sign of λ^{N−1}). Strict increase is NOT claimed on ring 1.
- Toward the trunk, not the trunk. Trunk-track.
- **Binding correction (grok #18428):** ring 1 certifies that the SIGNED AMPLITUDE a_{N−1} is `MonotoneOn`
  — "amplitude does not decrease." It does NOT certify "energy concentrates upward" or "what reaches the
  top stays": for a_{N−1} < 0 the amplitude rises toward 0 and the shell energy ½a_{N−1}² falls. The frozen
  QUESTION.md's energy language overclaims; this SCOPE line and the result line govern. Frozen means frozen.
- **Status:** (b2) is PROPOSED, not selected (SELECTION.md). r1b freeze math-signed, unfired, awaiting Anthony.
- **LADDER rung 1 mis-scope (advisor B5, LADDER.md is frozen — this line governs):** LADDER's "ℕ → ℝ with finite
  support" alternative for 1(b) is not flow-invariant (a_{n−1} ≠ 0 forces a_n' ≠ 0; support spreads instantly),
  so it cannot host KP-type blow-up any more than finite N can. (b1) means ℓ² / tsum, full stop.
- **Advisor's (b3), on the table for Anthony:** the interior-shell block-energy balance, uniform in N —
  E_{≥k} := ½Σ_{n≥k}aₙ², dE_{≥k}/dt = λ^k a_k a_{k−1}² − νΣ_{n≥k}λ^{2n}aₙ² (flux ~λ^k vs drain ~λ^{2k}), zero new
  definitions, k = N−1 recovers the top shell, and it is the lemma (b1)'s N→∞ argument consumes. Not staged.
