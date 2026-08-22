# AGENTS.md — orientation for an AI agent working in this repo

Everything below is traceable to a file in this tree; each claim names its source. Where this
file and the spec disagree, the spec wins.

## Read order

Spec §0 gives it: **§0, §1, §13, §12** of [`basin-spec-v2.md`](basin-spec-v2.md) — the contract,
the hard rules, what this thing is blind to, and where the work stands. Everything between is
reference. Then [`basin-spec-s18-handoff-v3.md`](basin-spec-s18-handoff-v3.md) for the current
line (statement validity), and [`rounds/alpha2/HANDOFF-2026-08-16.md`](rounds/alpha2/HANDOFF-2026-08-16.md)
for where the last seat stopped.

## Authority ordering (spec §0, verbatim in substance)

1. The spec, at the repo copy. A chat draft that disagrees with the repo copy loses.
2. `runs/*.jsonl` and the kernel logs. **Receipts beat claims, including claims in the spec.**
3. Anything else — including any agent's summary of the above, and every review in the appendix.

One caveat the spec cannot state about itself: §9's repo-layout block predates the §18 pivot and
names files that do not exist here (`SPEC.md`, `arms.json`, `corpus/canary.jsonl`,
`corpus/open.jsonl`, `reports/`), and its STATUS-line grammar is not the STATUS line in the
README. §9 is stale on layout. It is not stale on authority, and §§0–8 and 10–16 are unaffected.

## Frozen vs working surface

**Frozen. Do not edit, move, rename, or delete.**

| Surface | Why |
|---|---|
| `basin-spec-v2.md`, `basin-spec-s18-handoff-v3.md` | Authoritative specs. §1 rule 7 and §0: supersede by adding a dated entry, never by editing in place. |
| `temple-mathematic-basin.md` | The founding document. History. |
| `corpus/pairs.jsonl`, `corpus/rejected.jsonl` | Byte-frozen at sha256 `dc3cde90d33a19ed…`; the s18 handoff closes with "Nothing in this document authorizes a corpus change, a commit, or a model call." Append-only after freeze (§5, §1 rule 4). |
| `runs/*.jsonl` | §1 rule 6: append-only, never edited, compacted, pruned, or deleted. |
| `t1/` | Alpha 1's frozen result receipts, dual-signed. `t1/RESULT.md` lists the sha256 of each artifact. |
| `rounds/*/QUESTION.md`, `statement.txt`, `FREEZE.json`, `*_ledger.json`, `elaborate_receipt.json`, `PROVENANCE.json`, `PREREG*` | The research record, including RETIRED rounds and dead-end attempts, which are kept on purpose (`round.py` docstring: "the ledger records what happened, never what was hoped"). `round.py freeze` refuses a re-freeze with different hashes; `attempt` refuses to run a statement whose bytes no longer match `FREEZE.json`. |
| `verdict.py` | The trusted kernel gate. See below. |

**Working surface.** `lean/tmp/` is "the only place in the repo that is written and thrown away"
(§9). `lean/.lake/` is fetched, not tracked. Everything else either states intent or records
what happened.

`verdict.py` is not frozen by decree, but it is called "the most-audited file in the repo" (§9),
and it is the single thing every result in this tree rests on. Changing its semantics
invalidates every prior receipt. Treat a change to it as a proposal to the human, never as a
patch.

## The trust chain

**Only an `ACCEPT` from `verdict.py` counts.** Nothing else in this repo is evidence of a
mathematical fact — not a `lake build` that compiled, not a model's claimed stance, not a
seat's summary, not this file. Spec §1 rule 1: whoever makes a claim does not get to grade it.

`verdict(P, claimed_stance, proof_body) -> ACCEPT | REJECT` + axiom list. Four gates, all
required (§4, and `rounds/alpha2/PREREG.md` §2.3):

1. Compiles under the pinned toolchain (`leanprover/lean4:v4.32.2`, Mathlib `905b9581…`),
   120 s timeout.
2. No `sorry` / `sorryAx`.
3. Axioms ⊆ `{propext, Classical.choice, Quot.sound}`.
4. No `native_decide`, nothing routing through `reduceBool`.

`P` always comes from the frozen file, byte-identical; the model supplies a body and nothing
else (§1 rule 2). `UNKNOWN` compiles nothing and is a legitimate terminal (§4, PREREG §2.6);
it is `REJECT` with reason `unknown_stance`, because abstention is not earned evidence.
Untrusted Lean runs only inside macOS Seatbelt; if the sandbox or the Lake environment cannot
be resolved, `verdict` fails closed without compiling model-controlled code.

**Honesty typing is part of the chain, not decoration.** Every result carries the four-line
type from PREREG §2.2: *machine-checked* / *cited, not checked* / *new mathematics claimed* /
*not established*. Alpha 1's is the worked example — `t1/RESULT.md` machine-checks that a
specific 9-point set is a cap of size 9, and **cites, does not check, that 9 is the maximum**
(Bose 1947). Claiming Basin proved maximality is the exact failure the typing exists to
prevent. PREREG §2.2 also bans maximality/optimality/resolution language for the trunk in any
rung's result.

**Every detector states what it cannot see.** §1 rule 5 requires it in code and in §13, and
`verdict.py` honours it: `_assemble_source`, `_parse_axioms`, `_detect_sorry`,
`_detect_banned_tactic`, `_detect_panic_or_fatal` and `_axioms_outside_allowlist` each carry a
"Blind spots" block. Read them before you trust a green result. §13 is the repo-level version
and is maintained live — adding to it is progress, not an admission.

**Negatives are proven positively** (PREREG §2.4). A failed attempt is never filed as a
refutation; it is `KERNEL_REJECT` / `ELABORATION_ERROR` / `TIMEOUT` /
`SANDBOX_OR_TRANSPORT_ERROR`. A negative control is a kernel-checked `¬P` with the witness
named.

## Seat protocol and standing law

The seat protocol is written in exactly one place: the **"Seat protocol (not in any file but
this one)"** paragraph of [`rounds/alpha2/HANDOFF-2026-08-16.md`](rounds/alpha2/HANDOFF-2026-08-16.md).
Read it there. In summary: a second seat (`mbp-grok`) counter-signs the frozen statement before
any attempt and is instructed to attack any `ACCEPT`; delegated agents receive a brief under
`lean/tmp/` and are confined to `lean/tmp/agent*/`; the seat stages, the agent does not; counts
are cited from ledgers, never from memory.

**That protocol's coordination lane is not reachable from outside this machine.** It runs
through a local sqlite file (`~/.claude/plugins/…/chronicle.db`) named in that same paragraph.
An external agent has no access to it and should not pretend otherwise. The surfaces that *are*
reachable from a clone are the in-tree ones: `runs/*.jsonl`, each round's `FREEZE.json`,
`attempts_ledger.json`, `elaborate_receipt.json` and `PROVENANCE.json`, the `PREREG.manifest`
files, and `t1/`'s ledgers. Cite those.

Standing law for the current round program is `rounds/alpha2/PREREG.md` §2 (rules 2.1–2.10),
plus its dated "Supersession — v2 / v3" entries and the "§2.9 ordering amendment — 2026-08-16".
The 2026-08-16 handoff summarises what that session added: type sentence in `QUESTION.md` →
grok ACK → freeze the ACKed file untouched; generated bodies carry `PROVENANCE.json`, stamped
by `round.py` v3; and §2.1, that Anthony selects, and "proceed" / "constrict" are process
words, not selections.

## What an agent may propose, and what only the human gates

**May do, unasked:** read anything; run the offline tests and the drift checkers; re-derive any
number from the ledgers and say if it does not reconcile; point at a contradiction between spec
and tree; write a proof body into `rounds/<name>/attempts/` for a round that is already frozen
and staged.

**Must not do** (spec §0, "What an arriving instance must not do"): restructure the repo; tidy
or prune `runs/`; delete anything; rewrite a frozen estimand; fan out into subagents without
being asked. And: "If the spec looks wrong, say so and wait."

**Human-gated. Propose, then stop.**

- **Selecting a rung.** PREREG §2.1: "Anthony selects the first rung. The seat does not."
- **Corpus changes, commits, and model calls.** The s18 handoff's closing line withholds all
  three. `sweep.py` spends money; PREREG §2.8 does not prohibit model calls but requires each
  one logged with `model_requested` / `model_string_served`.
- **The §7 ruling** on which sense of "committed stance" the spec means — s18 §18.12 lists it as
  unsigned and warns the record should not carry it as settled.
- **The name of the §18 line** — §18.12: "it is not a seat's to pick."
- **Whether the pivot is right at all** — §18.12: a seat disagreeing "should say so rather than
  implement it quietly."
- **Pilot or primary** — spec §16, decision 4, explicitly "Open, and yours."
- Anything touching `verdict.py` semantics, for the reason above.

## Commands

Prepare the Lean environment once (required; see README Quickstart for what failure looks like
without it):

```
cd lean && lake update && lake exe cache get && cd ..
```

Full suite — 79 tests, all green only with the prepared Lean environment:

```
PYTHONPATH=. python3 -m unittest discover -s tests
```

Offline subset — 36 tests, no Lean, no network:

```
PYTHONPATH=. python3 -m unittest tests.test_p2_redteam tests.test_p4_load_items \
  tests.test_t1_statements tests.test_v0_analyze_run_id
```

The live gate on its own:

```
PYTHONPATH=. python3 -m unittest tests.test_verdict -v
```

Single-source drift checkers (exit 0 = every byte-copy still matches its source):

```
python3 scripts/check_iff_defs.py
python3 scripts/check_rung0_defs.py
```

Corpus integrity — must print `dc3cde90d33a19ed…`, the value in the README STATUS line:

```
shasum -a 256 corpus/pairs.jsonl
```

Reproduce a recorded figure. `analyze.py` pools across `run_id`s by default and warns on
stderr when it does; the recorded P4 gate is one run inside a two-run file (s18 §18.11 debt 1):

```
python3 analyze.py runs/2026-08-11.jsonl --run-id 2026-08-11T07:49:50Z
```

Run a round (freeze before touch; every attempt lands in the ledger, dead ends included):

```
python3 scripts/round.py freeze    rounds/<name>
python3 scripts/round.py elaborate rounds/<name>
python3 scripts/round.py attempt   rounds/<name>
python3 scripts/round.py status    rounds/<name>
```

## Known-open, already recorded — do not "fix" these

- **12 of 79 tests fail on a clone without the prepared Lean environment.** That is the gate
  failing closed. See README Quickstart.
- **§18.11 lists five debts before V1**, including the `analyze.py` run-id reproducibility
  defect (partly addressed by `--run-id` and `tests/test_v0_analyze_run_id.py`) and "the rescue
  has no pointer" — a path in `basin-spec-s18-handoff-v3.md` §18.3 that resolves on no machine
  you have.
- **§13 is a live list of blind spots**, several of them unrecoverable by design: the corpus
  harvester was never committed, so the filter that selected parents 0021–0105 cannot be
  reconstructed; runs before `sweep.py` commit `ab5c19e` carry no `proof_body` and **must never
  be backfilled**, because a regenerated body is not the body that failed.
- **Frozen JSON receipts under `rounds/` and `t1/` contain absolute paths from the machine that
  produced them.** They are part of a hash-frozen record. §1 and PREREG §2.5 mean you report
  them, you do not rewrite them.
