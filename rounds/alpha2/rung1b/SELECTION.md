# Rung 1(b) — re-target selection, 2026-08-15

**Selected: (b2) finite-N top-shell concentration.**

**Provenance, stated plainly (PREREG §2.1: Anthony selects):** the seat recommended (b2) over (b1) on the
board and in the state report ("(b2) is fence-legal today and is the first result that would let the
cascade *concentrate* rather than merely conserve; (b1) needs an ℓ² fence probe first"). Anthony replied
"proceed", then "constrict". The seat reads that as selection of (b2). If that reading is wrong, this
entry is superseded by a dated correction and any 1(b) round is retired — nothing fires without
mbp-grok's §2.9 sign, so there is a veto window before any attempt.

**Why 1(b) needed a re-target:** the original 1(b) hope — a norm collapsing in the finite-N model — is
FALSE: energy is a first integral (r1-inviscid-energy-first-integral) and non-increasing for ν ≥ 0
(r1-viscous-energy-antitone), so no shell can blow up at finite N. "No blow-up at finite N" is still
cited-from-argument (Picard not budgeted).

**What (b2) is:** the top shell N−1 has no outgoing cascade term. Along every solution,
`da_{N−1}/dt = λ^{N−1} a_{N−2}² − ν λ^{2(N−1)} a_{N−1}`. Inviscid, it is monotone nondecreasing:
energy that reaches the top stays. Viscous, it grows iff cascade input beats viscous drain,
`a_{N−2}² ≥ ν λ^{N−1} a_{N−1}` — the trunk's dichotomy in the model with an explicit threshold.
This is an honest finite-N "stretching wins": concentration, not blow-up.

**Definition budget (PREREG §3):** zero new definitions — same field/solution lambdas as Rung 1(a),
byte-identical. Top shell is `⟨N−1, _⟩ : Fin N` under `0 < N`.

**Advance policy (Anthony 2026-08-15: "we can only advance slightly on each"):** one ring per pass.
Ring 1 (this pass): inviscid top shell `MonotoneOn` [0,T). Ring 2 (next pass, not staged): the viscous
top-shell balance with the threshold as an iff.
