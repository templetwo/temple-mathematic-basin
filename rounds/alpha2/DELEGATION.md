# Alpha 2 — Delegation log (PREREG §2.8: every model call logged; generated bodies typed "generated")

Anthony, 2026-08-15: "deligate agents." · "now we're talking".

Until this entry Alpha 2 recorded **zero model calls**: every statement and proof body was written by the
seat in-conversation. From this entry on, proof bodies produced by delegated Claude subagents are model
calls under §2.8 and are typed **generated (claude subagent, seat-reviewed, kernel-checked)** in their
round's QUESTION.md and on the board. The kernel is still the court: a generated body ACCEPTs or it does
not; who typed it changes the type line, not the verdict.

## Trusted-path boundary
Agents write ONLY under `lean/tmp/agent_<rung>/`. They do not touch `rounds/`, do not run
`scripts/round.py`, do not commit, do not push, may not use sorry/native_decide/decide-on-open-goals.
The seat: reads their NOTES.md, re-checks the statement against the byte-identical lambdas
(`lean/tmp/LAMBDAS/*.txt`, asserted against frozen statements), stages the round, freezes, elaborates,
preflights, requests mbp-grok's §2.9 sign, fires only on sign. Brief: `lean/tmp/AGENT_BRIEF.md`.

## Pass 5 (delegated), launched 2026-08-15
| Agent | Rung | Target | model_requested | model_string_served |
|---|---|---|---|---|
| agent_0 | 0 | div(curl u) ≡ 0 for ContDiff ℝ 2 u | inherit (claude-fable-5 session) | as served by the Agent tool; recorded on completion |
| agent_1 | 1(a) | Σ a·field(ν,λ) = 0 ↔ a = 0, ν>0, λ≠0 | same | same |
| agent_2 | 2 | vector Grönwall ‖ω t‖ ≤ ‖ω a‖e^{K(t−a)} (Mathlib replication) | same | same |
| agent_3 | 3 | L^p scaling identity, real p | same | same |
| agent_4 | 4 | twoDwit: IsTwoD, non-constant curl, stretch ≡ 0 | same | same |

Rung 1(b) NOT delegated — awaiting Anthony's naming (rung1b/SELECTION.md).
Outcomes are appended below when each agent returns (closed / UNKNOWN), before staging.

### Pass 5 outcomes (all five agents returned, 2026-08-15)
model_string_served for all five: `claude-fable-5` (session model; Agent tool inherits, no override; the seat
cannot read a finer served string from the tool). Recorded in each round's `PROVENANCE.json` before staging.

| Agent | Round staged | Outcome | Notes (agent's own, seat-verified) |
|---|---|---|---|
| agent_0 | `r0-div-of-curl-zero` S=`c92e9198813dd846` | closed, exit 0, no warnings | Clairaut per component; PiLp coordinate extraction; ContDiff 2 load-bearing |
| agent_1 | `r1-dissipation-stops-only-at-rest` S=`795d53d3b02e135a` | closed | horth induction reused verbatim; ν>0, λ≠0 load-bearing; typed algebraic |
| agent_2 | `r2-vector-gronwall-replication` S=`539377f2419b3595` | closed | Mathlib replication; a≤b, 0≤K unused (declared) |
| agent_3 | `r3-lp-scaling-real-exponent` S=`99d6d3031da54c70` | closed | 0≤p not needed (Mathlib rpow at 0); no `ring` used, rpow/npow never conflated |
| agent_4 | `r4-twoD-nonlinear-witness` S=`ca30eefd155646fb` | closed | four conjuncts one theorem; no HasFDerivAt.div_const on pin → (−1/2)·x₁² |

Zero UNKNOWNs. Each round dir carries `PROVENANCE.json` (stamped into the ledger by round.py v3 on fire) and
`AGENT_NOTES.md` (the agent's honest typing, verbatim). Agents touched nothing under `rounds/` or
`scripts/`; the seat staged all five. Fire waits on mbp-grok's §2.9 sign of the five statements AND
counter-sign of the round.py v3 diff (PREREG supersession v3).

### Pass 5 fired 2026-08-15 on grok's two signs (#18571: v3 diff + five statements) — 5/5 ACCEPT
| Round | Verdict | Wall | Ledger provenance |
|---|---|---|---|
| `r0-div-of-curl-zero` | ACCEPT 01.txt | 21.4s | generated / claude-fable-5 |
| `r1-dissipation-stops-only-at-rest` | ACCEPT 01.txt | 22.0s | generated / claude-fable-5 |
| `r2-vector-gronwall-replication` | ACCEPT 01.txt | 16.4s | generated / claude-fable-5 |
| `r3-lp-scaling-real-exponent` | ACCEPT 01.txt | 19.0s | generated / claude-fable-5 |
| `r4-twoD-nonlinear-witness` | ACCEPT 01.txt | 22.3s | generated / claude-fable-5 |
All axioms {propext, Classical.choice, Quot.sound}; statement sha == FREEZE in every ledger; the `provenance`
field is the §2.8 receipt. Result lines (grok #18571 binding): R0 Clairaut/instrument, Biot–Savart role CITED ·
R1 algebraic nondegeneracy, NOT ODE uniqueness (directory name notwithstanding) · R2 replication, ω any curve,
shape not engine · R3 the rpow identity, Bochner 0=0 without integrability, p≤0 mostly that vacuity, NOT an
L^p-norm certificate, "p=3 in the real family" is interpretation · R4 non-constant ω is the content, Ladyzhenskaya CITED.

## Advisory call, 2026-08-16 — Anthony: "use a fable advisor"
One read-only advisor agent, model requested `fable` (Claude Fable 5), no proof body produced, no round
touched. Brief: strategic/adversarial read of the whole record — is the encirclement closing on the trunk
or decorating; overclaims grok missed; Rung 1(b) (b1)/(b2)/unnamed (b3); one highest-value next ring per
rung and one to refuse; the single fence extension worth its trust cost; process fragility; a draft honest
terminal statement. Output: `lean/tmp/advisor/ADVISORY.md`; the seat relays to Anthony and to the board.
Advice is advice: nothing it says is staged without the same freeze/elaborate/sign/fire path.

## Pass 6 (delegated, INWARD — the advisor's D list, grok-typed #18651), launched 2026-08-16
Anthony: "fire the signed freeze under the amended phrase, then start pass 6." Under the §2.9 ordering amendment:
type line ACKed by grok BEFORE freeze. Provenance: generated / claude-fable-5 (Agent tool inherit) on all five.
| Agent | Rung | Target | Type line (to be ACKed) |
|---|---|---|---|
| agent6_0 | 0 | curl((u·∇)u) = (u·∇)ω − (ω·∇)u + (div u)ω, C² u | pointwise identity where stretching emerges; NOT the vorticity equation |
| agent6_1 | 1(c) | E(a t) ≤ E(a 0)e^{−2νt}, λ ≥ 1, ν ≥ 0, every solution | exponential arrest with a rate, uniform in N, IN A MODEL, no Picard |
| agent6_2 | 2 | 1+log y ≤ (1+log y(a))e^{∫K} under y' ≤ Ky(1+log y) | the log-Grönwall step — BKM's shape, NOT its engine |
| agent6_3 | 3 | G(λu(λ·)) = G(u), G the Gagliardo Ḣ^{1/2} double integral | Ḣ^{1/2} object, scale-invariant; NOT Fourier Ḣ^{1/2}, NOT ESŠ |
| agent6_4 | 4 | (curl((u·∇)u))₂ = (u·∇)ω₂ + (div u)ω₂ for IsTwoD C² u | 2D transport identity; NOT the 2D vorticity equation, NOT Ladyzhenskaya |
No 1(b) ring in pass 6 (program not yet named). Outcomes appended on return.
