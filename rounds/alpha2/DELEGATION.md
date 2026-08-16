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

### Pass 6 fired 2026-08-16 on grok's type-line ACK (#18755) + §2.9 sign (#18763) — 5/5 ACCEPT
| Round | Verdict | Wall | Type line (in the frozen Q bytes) |
|---|---|---|---|
| `r0-vorticity-form-of-convection` S=`a84b7293c6f2ce20` | ACCEPT 01.txt | 24.7s | pointwise vorticity-form identity for a C² field; NOT the vorticity equation |
| `r1c-exponential-arrest` S=`41ac64e78ff57ca2` | ACCEPT 01.txt | 14.4s | exponential decay of model energy, λ≥1, ν≥0, uniform in N; NOT an NS estimate; no Picard |
| `r2-log-gronwall-step` S=`10e7e29164149fad` | ACCEPT 01.txt | 12.4s | log-Grönwall step, BKM's last-step shape; NOT the engine |
| `r3-gagliardo-h-half-invariance` S=`327c5c037f47d9d3` | ACCEPT 01.txt | 14.3s | dilation invariance of the GS Ḣ^{1/2} double integral; NOT Fourier Ḣ^{1/2}; NOT ESŠ |
| `r4-twoD-vorticity-transport-identity` S=`e99e14223216500d` | ACCEPT 01.txt | 16.6s | pointwise 2D transport identity; NOT the 2D vorticity equation; NOT Ladyzhenskaya |
All axioms {propext, Classical.choice, Quot.sound}; ledgers carry provenance generated / claude-fable-5; S == FREEZE.
Result lines binding (grok #18755/#18763): R0 holds without div-free, (u·∇)ω inlined · R1c λ≥1 load-bearing, ν=0 → E≤E₀ ·
R2 K≥0 unused, Icc · R3 "0/0" is totalization, off the result line · R4 both IsTwoD conjuncts load-bearing, div u=0 not assumed.
Process (grok): Q hashes moved after the ACK because the header wording was fixed — accepted once; next pass freeze the ACKed
file with no further edit, or ACK after the header is final.

**What pass 6 changed about the trunk score (advisor A, re-read):** vortex stretching now EMERGES from the operator in the
kernel (R0), not merely defined; viscous arrest has a RATE, uniform in N, in the model (R1c); BKM's actual last-step shape is
held (R2); a real Ḣ^{1/2} object is in the kernel and scale-invariant (R3); 2D transport is held (R4). Non-local pressure and
the geometry of incompressibility remain at zero kernel content — that is Alpha 2b's job (Fourier–Galerkin, Leray), held.

## 2026-08-16 — Anthony: "i want you to make those calls." Two calls made by the seat on that delegation
1. **Rung 1(b) program := (b3)** (rung1b/SELECTION.md). Ring 2 (algebraic block-flux identity) delegated now: agent7_1b.
2. **Alpha 2b opened** as a NEW preregistration per PREREG §1.2 (not a silent Alpha 2 rung): finite-mode Fourier–Galerkin
   Navier–Stokes on 𝕋³ with the Leray projector, ≤6 definitions, C1/C2/C3 on each — the route that puts non-local
   pressure and the geometry of incompressibility into the kernel (both at zero content after 46+11 ACCEPTs). Grok's
   hold condition (#18651: not while 1(b) unsigned and D unstarted) is met. Sequence: draft prereg + fence probe →
   grok counter-sign → tag alpha2b-prereg-v1 → then and only then a rung. Court unchanged (verdict.py pinned).
