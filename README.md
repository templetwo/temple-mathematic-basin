# Basin

Basin is a pre-registered search in formal mathematics whose only trusted surface is a
Lean 4 kernel-checked acceptance gate. A model may claim anything; nothing counts until
`verdict.py` compiles the submitted proof body against the frozen statement, under a pinned
toolchain, inside an OS sandbox, and returns `ACCEPT` with an axiom list inside the allowlist.
The receipt is the product: no result here is stronger than the record that backs it, and
everything a receipt does not cover is written down as not covered.

See [`basin-spec-v2.md`](basin-spec-v2.md), the authoritative v2 specification.

STATUS: line=statement-validity(§18) trunk=alpha-1 result=9-cap-dual-signed corpus=dc3cde90 spec=v2+§17/§18 updated=2026-08-15

**First result:** [`t1/RESULT.md`](t1/RESULT.md) — a 9-cap in (ℤ/3ℤ)³, kernel-checked through trusted `verdict.py`, dual-signed at scope. Maximality cited, not checked. New mathematics: none. The receipt is the product.

E3 (the dissent estimand, §7) is set down, not killed — see §17 entry of 2026-08-12 and `basin-spec-s18-handoff-v3.md`.

> **On this file's length.** Spec §9 prescribes a README that is "pointer to SPEC.md + STATUS
> line. nothing else." That §9 layout block predates the §18 pivot and already differs from the
> tree in other ways (it names `SPEC.md`, `arms.json`, `corpus/canary.jsonl`, `corpus/open.jsonl`
> and `reports/`, none of which exist here under those names, and its STATUS-line grammar is not
> the STATUS line above). This README is expanded so a cold reader or an arriving agent can
> orient without a prior conversation. It adds orientation only. On anything substantive the
> spec, then the receipts under `runs/` and the round ledgers, remain authoritative — in that
> order, per §0.

---

## Quickstart

Requires macOS (the sandbox is macOS Seatbelt, `/usr/bin/sandbox-exec`), Python 3.12 or newer,
and [`elan`](https://github.com/leanprover/elan) on `PATH` so `lake` resolves.

```
git clone https://github.com/templetwo/temple-mathematic-basin.git
cd temple-mathematic-basin
```

**1. Prepare the pinned Lean environment.** This is not optional and it is not fast the first
time: `lake exe cache get` downloads prebuilt Mathlib `.olean`s, without which every kernel
check fails.

```
cd lean
lake update
lake exe cache get
cd ..
```

`lean/lake-manifest.json` is tracked on purpose, and `lake update` is a command that can rewrite
it. Check `git status` afterwards: if the manifest changed, understand why before running
anything against the new pin, because every receipt in this tree attests the old one.

**2. Run the tests.** Repo root on `PYTHONPATH` so the local `tests/` package wins:

```
PYTHONPATH=. python3 -m unittest discover -s tests
```

79 tests. All 79 pass only when the Lean environment above has been prepared.

**What failure looks like without it.** 12 of the 79 shell out to the real toolchain through
`verdict.py` and fail on an unprepared clone — 9 in `tests/test_verdict.py`, 1 in
`tests/test_p1_redteam.py`, 2 in `tests/test_p3_redteam.py`. The signature depends on how cold
the clone is:

- Mathlib fetched but not cached (`lake update` run, `lake exe cache get` not): `verdict()`
  returns `reject_reason="compile_error"` and the compile log reads
  `error: unknown module prefix 'Mathlib'`.
- No `lean/.lake` at all: `verdict()` cannot resolve the Lake environment and returns
  `reject_reason="sandbox_unavailable"` without compiling anything.
- Not macOS: `_sandbox_available()` is false, so `verdict()` returns `sandbox_unavailable` for
  every attempt without compiling anything. The failing set is then larger than the 12 above —
  tests that pin `reject_reason` to `compile_error` or `timeout` fail too. That set has not been
  measured here.

These are the gate failing closed, which is the designed behaviour. Do not "fix" the tests to
make a cold clone green.

**And do not read the other 67 as verified either.** Several negative-path tests in
`tests/test_verdict.py` assert only `REJECT` with `reject_reason="compile_error"`, or only that
a canary string is absent from the compile log. On an unprepared clone every input rejects with
`compile_error` and no log can contain a canary, so those assertions hold without exercising
what they name. A green run means something only after step 1.

**3. The 36 tests that need no Lean and no network** cover the aggregation rule, the mutation
operators, item loading, the T1 statement strings, and the run-id reproducibility gate:

```
PYTHONPATH=. python3 -m unittest tests.test_p2_redteam tests.test_p4_load_items \
  tests.test_t1_statements tests.test_v0_analyze_run_id
```

**Dependencies.** Python 3.12+, standard library only — every import in the repo root modules,
`scripts/` and `tests/` resolves to the stdlib or to a local module, so there is no
`requirements.txt` and nothing to `pip install`. The one exception in the whole tree is
`numpy` in `rounds/alpha2b/receipts/d4_cancellation_check.py`, a frozen one-off receipt for the
Alpha 2b D4 cancellation check; no test and no pipeline imports it. The Lean side is pinned in
`lean/` and fetched by `lake`.

---

## P0 acceptance surface

`verdict(P, claimed_stance, proof_body) -> ACCEPT | REJECT` plus axiom list.

Prepare the pinned Lean environment before running concurrent checks:

```
cd lean
lake update
lake exe cache get
cd ..
```

Run tests (repo root on `PYTHONPATH` so local `tests/` wins):

```
PYTHONPATH=. python3 -m unittest tests.test_verdict -v
```

Lean project: `lean/` (toolchain `leanprover/lean4:v4.32.2`, Mathlib `905b95818eb32af7874a58b427f50c1711a5e96c`).

Untrusted Lean runs under macOS Seatbelt (`/usr/bin/sandbox-exec`) with network,
child-process execution, persistent writes, and file-content reads under the home
and shared-temporary roots denied outside the Basin project and pinned Elan
toolchain. File metadata is not fully hidden; the sandbox is a content and
side-effect boundary, not a path-existence oracle. If the sandbox or pinned Lake
environment cannot be resolved, `verdict` fails closed without compiling
model-controlled code.

The four gates, all required, in order (spec §4): compiles under the pinned toolchain within
the 120 s timeout; no `sorry` / `sorryAx`; axioms a subset of `{propext, Classical.choice,
Quot.sound}`; no `native_decide` and nothing routing through `reduceBool`. No partial credit.

---

## Repo map

| Path | What it is |
|---|---|
| `basin-spec-v2.md` | AUTHORITATIVE spec. §0–§16 bind; the appendix holds §17 supersessions, four reviews, and the superseded v1/draft text. Frozen: supersede by dated entry, never edit in place. |
| `basin-spec-s18-handoff-v3.md` | AUTHORITATIVE §18 handoff: the pivot from the dissent estimand to statement validity, its kill criteria, governance, and the open debts. |
| `temple-mathematic-basin.md` | Founding document — eight rounds of proposal, review, and positioning that produced the spec. History, not a contract. |
| `verdict.py` | THE TRUSTED KERNEL GATE. Assembles a term-only harness, runs Lean under Seatbelt, parses the `collectAxioms` attestation, fails closed. Every detector enumerates its own blind spots in its docstring (§1 rule 5). |
| `analyze.py` | Aggregation and estimands. The single home of the 3-of-4 commit rule (§6, §10) and of E1; `--run-id` filtering so the tool that made a record reproduces it. |
| `arms.py` | Provider adapters and blind dispatch. One arm = one model behind one adapter; records `model_requested` and `model_string_served` separately; strict JSON parsing, everything unparseable lands MALFORMED with a reason. |
| `sweep.py` | The for loop (§12 P2): items × samples → sample → certify → record. Every slot appends exactly one §10 record to `runs/`, whatever happens. The only path that touches the network. |
| `mutate.py` | Seven deterministic text-level mutation operators plus refutation certification through the same `verdict.py` gate. Mutation is scripted, never model-generated (§5). |
| `eligibility.py` | Deep-mutation eligibility predicate — a DETECTOR, not an operator. Committed so the number it produces can be re-derived and disagreed with; its naming-convention blind spot is measured, not assumed. |
| `merge_pairs.py` | Merges certified mutants from a subset run back into `corpus/pairs.jsonl`. Refuses outright if the merge would change a parent, drop a mutant, or add an unknown `pair_id`. |
| `prompt.txt` | The verbatim single-shot prompt template. Results are not replicable without it. |
| `corpus/` | The frozen corpus. `pairs.jsonl` — 105 pairs, sha256 `dc3cde90…`, 66 of them carrying a certified REFUTABLE mutant beside the TRUE parent — and `rejected.jsonl` — 293 mutation candidates that failed certification (231 `refutation_not_found`, 62 `malformed_statement`). Append-only after freeze. |
| `runs/` | RECEIPTS, append-only: `2026-08-09.jsonl` (88 records) and `2026-08-11.jsonl` (272). Never edited, pruned, or compacted (§1 rule 6). |
| `rounds/` | The research record: 61 directories, of which 59 are rounds holding `QUESTION.md`, `statement.txt`, `FREEZE.json`, `attempts/`, `attempts_ledger.json`, `elaborate_receipt.json` and (post-§2.8) `PROVENANCE.json`. The other two, `alpha2/` and `alpha2b/`, are program directories — pre-registrations, manifests, ladders, advisories, and the seat handoff. Dead ends and `-RETIRED` rounds are kept on purpose. |
| `t1/` | Alpha 1's frozen result: `QUESTION.md`, `RESULT.md`, the witness and control ledgers, the blind `iscap_*.lean` formalizations, and `statements.py` (the Prop-term strings the harness elaborates). |
| `lean/` | The pinned Lake project: `lean-toolchain` (`leanprover/lean4:v4.32.2`), `lakefile.lean` (Mathlib at `905b9581…`), `lake-manifest.json`. `lean/tmp/` is the only written-and-discarded place in the repo; `lean/.lake/` is fetched, not tracked. |
| `scripts/` | Tooling around the gate: `round.py` (the round runner — freeze / elaborate / attempt / status), `t1_witness.py`, `t1_battery_run.py`, `t1_elaborate.py`, the `check_*_defs.py` single-source drift checkers, `preflight_body.py`, and the two `p4_*.sh` sweep launchers. |
| `tests/` | 79 unittest tests across seven modules. `test_verdict`, `test_p1_redteam` and `test_p3_redteam` reach the live gate and hold the 12 that need the prepared Lean environment; `test_p2_redteam`, `test_p4_load_items`, `test_t1_statements` and `test_v0_analyze_run_id` are 36 pure tests with no Lean and no network. |
| `AGENTS.md` | Orientation for an AI agent working this repo. |
| `LICENSE`, `NOTICE` | Apache-2.0 and the Temple NOTICE. |

---

## Running a round

`scripts/round.py` is the discipline made default. Freeze before touch, byte-identical
statements, ledger everything including dead ends:

```
python3 scripts/round.py freeze    rounds/<name>   # hash QUESTION.md + statement.txt -> FREEZE.json
python3 scripts/round.py elaborate rounds/<name>   # prove the statement type-checks at all
python3 scripts/round.py attempt   rounds/<name>   # every attempts/*.txt through verdict.py, in order
python3 scripts/round.py status    rounds/<name>
```

`freeze` refuses if a `FREEZE.json` already exists with different hashes. `attempt` refuses to
run if `statement.txt` no longer matches its frozen hash. A round that exits non-zero with a
full ledger is that round's honest no-result — UNKNOWN is a legitimate terminal.

A sweep (`sweep.py`, and the `scripts/p4_*.sh` wrappers) calls a model provider and costs money.
It reads its API key from the environment variable named by `--key-env` (default `XAI_API_KEY`)
and holds no credential in the tree. It is the only network path in the repo; nothing else here
makes an outbound request.

---

## For agents

Read [`AGENTS.md`](AGENTS.md) before touching anything. It states what is frozen versus working
surface, the trust chain, where the seat protocol and standing law live, what an agent may
propose versus what only the human gates, and the exact commands to run checks.

The short version, from spec §0: do not restructure the repo, do not tidy or prune `runs/`, do
not delete anything, do not rewrite a frozen estimand, do not fan out into subagents without
being asked. If the spec looks wrong, say so and wait.

---

## Status

STATUS line above, one line, parseable without reading prose. Trunk is Alpha 1, complete and
dual-signed. The active line is statement validity (§18), pivoted from the E3 dissent estimand
on 2026-08-12; E3 is set down, not killed. Alpha 2 and Alpha 2b are open round programs under
`rounds/`, with their pre-registrations, ladders, and manifests in
`rounds/alpha2/` and `rounds/alpha2b/`. The last seat handoff, including the ordered list of
what a next seat should do, is `rounds/alpha2/HANDOFF-2026-08-16.md`.

## Result

[`t1/RESULT.md`](t1/RESULT.md) — Alpha 1. In (ℤ/3ℤ)³ there exists a 9-point cap: the graph of
q(x, y) = x² + y² over (ℤ/3ℤ)², lifted to three coordinates. `ACCEPT` on first attempt, 43.8 s,
axioms exactly `{propext, Classical.choice, Quot.sound}`, zero model calls in the round.

The claim typing in that file is the point, and it is stated there in a table so it cannot be
quietly upgraded:

- **Machine-checked:** that specific 9-point set is a cap and has cardinality 9.
- **Cited, not checked:** that 9 is the *maximum* cap size in dimension 3 (Bose 1947). Basin did
  not prove this and must not be cited as having proved it.
- **New mathematics:** none. The answer was already known. The contribution is the receipt.
- **Not established:** optimality, scale, search capability, UNKNOWN discipline, anything for
  n ≥ 4.

The certificate is three labeled `decide`s on closed goals. The anisotropic-form argument in
`RESULT.md` is commentary, not a proof term. A decide-free structured proof is a later round's
shadow lane.

---

## License

Apache License 2.0 — see [`LICENSE`](LICENSE), and [`NOTICE`](NOTICE) for the Temple of Two
statement of intent and attribution. Copyright (c) 2025-2026 Anthony J. Vasquez Sr. /
AV Family Enterprise LLC. Claude is credited as co-author on Temple artifacts. Corrections to
this repository are made by supersession, not erasure: the history is the record.
