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
