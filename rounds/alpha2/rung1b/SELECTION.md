# Rung 1(b) — re-target PROPOSAL, 2026-08-15 (NOT a selection)

**Proposed: (b2) finite-N top-shell concentration. NOT SELECTED — awaiting Anthony's naming.**

**Correction, same day (grok #18428):** the first draft of this file said "Selected". Anthony's words — "proceed", "constrict", "move to the next rung", "advance slightly on each" — are process words; they do not name (b2) or top-shell. Reading them as the 1(b) pick was a seat inference, and PREREG §2.1 is *Anthony selects*, not *the seat infers*. Recorded as a caught process error. The r1b freeze stands, elaborated, preflight-clean, math counter-signed by grok, and **UNFIRED** until Anthony names it ("(b2)", "top-shell", or "fire 1b"). If he says no, the freeze is retired, not edited.

**Provenance, stated plainly (PREREG §2.1: Anthony selects):** the seat recommended (b2) over (b1) on the
board and in the state report ("(b2) is fence-legal today and is the first result that would let the
cascade *concentrate* rather than merely conserve; (b1) needs an ℓ² fence probe first"). Anthony replied
"proceed", then "constrict". ~~The seat reads that as selection of (b2).~~ **[SUPERSEDED same day by the
correction above — that reading was a seat inference, not a §2.1 selection. Kept struck for the record.]**
Nothing fires without mbp-grok's §2.9 sign and Anthony's naming.

**Why 1(b) needed a re-target:** the original 1(b) hope — a norm collapsing in the finite-N model — is
FALSE: energy is a first integral (r1-inviscid-energy-first-integral) and non-increasing for ν ≥ 0
(r1-viscous-energy-antitone), so no shell can blow up at finite N. "No blow-up at finite N" is still
cited-from-argument (Picard not budgeted).

**What (b2) is:** the top shell N−1 has no outgoing cascade term. Along every solution,
`da_{N−1}/dt = λ^{N−1} a_{N−2}² − ν λ^{2(N−1)} a_{N−1}`. Inviscid, the signed amplitude a_{N−1} is monotone nondecreasing.
**Not** "energy that reaches the top stays" — grok #18428: if a_{N−1} < 0, da/dt ≥ 0 drives it toward 0 and ½a² FALLS. The true statement is the amplitude one; the energy phrasing in this file's first draft and in the frozen QUESTION.md overclaims, and SCOPE.md governs. Viscous, it grows iff cascade input beats viscous drain,
`a_{N−2}² ≥ ν λ^{N−1} a_{N−1}` — the trunk's dichotomy in the model with an explicit threshold.
~~This is an honest finite-N "stretching wins": concentration, not blow-up.~~ **[Struck 2026-08-16 (grok #18667 nit): superseded by the naming section below and rung1b/SCOPE.md — the truncation boundary is absorbing; not "stretching wins".]**

**Definition budget (PREREG §3):** zero new definitions — same field/solution lambdas as Rung 1(a),
byte-identical. Top shell is `⟨N−1, _⟩ : Fin N` under `0 < N`.

**Advance policy (Anthony 2026-08-15: "we can only advance slightly on each"):** one ring per pass.
Ring 1 (this pass): inviscid top shell `MonotoneOn` [0,T). Ring 2 (next pass, not staged): the viscous
top-shell balance with the threshold as an iff.

## Anthony's naming — 2026-08-16
Anthony: **"fire the signed freeze under the amended phrase, then start pass 6."** That is the §2.1 naming for
ring 1: `r1b-inviscid-top-shell-monotone` fires as the k = N−1 SIGNED-AMPLITUDE fact, typed per rung1b/SCOPE.md —
**"the truncation boundary is absorbing (inviscid)"**: da_{N−1}/dt = λ^{N−1}a_{N−2}² ≥ 0 because a_N := 0 deleted the
exit term. Not energy (a_{N−1} < 0 rises toward 0 and ½a² falls). Not "stretching wins". Not blow-up. IN A MODEL.
Grok's math counter-sign: #18428; grok's fire condition ("Anthony names it"): #18428, #18651. Body: seat-authored.

The 1(b) PROGRAM after ring 1 — (b3) block-energy balance E_{≥k}, uniform in N, recommended by both seats — is
**not yet named by Anthony**; pass 6 (the advisor's inward D list) carries no 1(b) ring. Nothing further on 1(b) is
staged until he names the program.
