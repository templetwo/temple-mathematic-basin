# Basin

**Basin — An Acceptance-Invariance Instrument for Counter-Consensus in Formal Mathematics**

**Spec version:** v2, Aug 8 2026. Supersedes v1 in full.
**Status:** unbuilt. No phase started. No data exists.
**Scope:** this is not `/grand-challenge-sandbox/`. It is the one instrument that has to work before that sandbox is worth building.

> **This file:** §0 through §16 are the spec and are authoritative. Everything after them is
> an appendix holding the four reviews, the superseded v1 spec, and the superseded draft.
> Both corrections that v1 left unabsorbed are absorbed here: the E3 null is rebuilt in §7,
> and the stance/certificate split is in §4 and §6. What v2 changed, and what it corrected
> in the reviews themselves, is listed at the top of the appendix.

---

## 0. Arrival

The document is the substrate. The instance is the swappable kernel. Anything you need to work here is in this file or reachable from it. There is no boot-up ritual, no stack grounding, no prior conversation you need.

**Read order for an arriving instance:** §0, §1, §13, §12. That tells you the contract, the hard rules, what this thing is blind to, and where the work actually stands. Everything between is reference, read it when you need it.

**Vocabulary.** Three stances, used identically everywhere: `PROVABLE`, `REFUTABLE`, `UNKNOWN`. The word FALSE does not appear as a stance or a stratum name in v2. If you find it, you are reading superseded text.

**Authority ordering, highest first:**

1. This spec, at the repo copy. If a chat draft and the repo copy disagree, the repo copy wins.
2. `runs/*.jsonl` and the kernel logs. Receipts beat claims, including claims in this spec.
3. Anything else, including any agent's summary of any of the above, and including every review in the appendix.

**What an arriving instance must not do:** do not restructure the repo, do not tidy or prune `runs/`, do not delete anything, do not rewrite a frozen estimand, do not fan out into subagents without being asked. If the spec looks wrong, say so and wait. Supersede by adding a dated entry, never by editing a frozen section in place.

**What Basin is for:** answering one question with receipts. Not for demonstrating architecture.

---

## 1. Hard rules

Few, absolute, and they do not bend for convenience.

1. **Whoever makes a claim does not get to grade it.** The model produces a proof. The kernel decides whether it is a proof. No model output ever changes a verdict, a trust state, or a metric.
2. **The statement text always comes from the frozen corpus file.** The model supplies a proof body and nothing else. It never writes, edits, restates, or paraphrases the proposition.
3. **Claimed stance and certified stance are recorded separately and never collapsed.** What an arm believes and what its evidence earns are two different observations. Reporting one as the other is the failure this instrument exists to measure.
4. **A REFUTABLE item does not enter the corpus until a compiled refutation sits next to it.** No exceptions, no "obviously false."
5. **Every detector and every parser enumerates what it cannot see**, in code and in §13. A blind spot you have written down is a limitation. One you have not is a defect.
6. **Runs are append-only.** Nothing under `runs/` is ever edited, compacted, pruned, or deleted.
7. **Estimands are frozen before the first sweep and never changed after seeing data.** Supersede with a dated entry and a reason; do not overwrite.
8. **A sweep completes or is discarded.** Never truncate mid-sweep for budget. A partial sweep is unbalanced across arms and is worthless for §7.

---

## 2. The question

When heterogeneous language models disagree about a formal mathematical claim, and a deterministic oracle settles it, does the minority report outperform the majority?

Feb 11 2026, IRIS Gate Evo: three of five models converged on the wrong VDAC1 gating polarity, S2 promoted it to TYPE 1 by majority, and the singular that contradicted it was closer to right. The recorded implication was that a counter-consensus singular may signal shared training contamination rather than replication failure. The COUNTER-CONSENSUS SINGULAR flag that finding called for was never built.

It stayed unbuilt because adjudicating a disagreement in pharmacology costs a human and a literature search. The sample size was unaffordable. In formal mathematics the Lean kernel adjudicates for free, deterministically, thousands of times over. Same disagreement structure, ground truth included.

---

## 3. What Basin is, and what it does not claim

A fixed acceptance surface, a varying set of search kernels, and a corpus with machine-checked ground truth in both directions. The model varies. The acceptance surface does not. Same shape as the ECS work: hold the substrate external and real, treat the model as a swappable transducer inside it.

**The novelty claim, narrowed.** v1 said "nobody else is oriented on this question." That was wrong, and the corrected version is stronger because it is specific.

The minority-truth phenomenon is established. Minority Sentinel (arXiv 2606.29270, Jun 28 2026) reports that in roughly one in four divergent multi-agent debate cases the minority holds the correct answer, and attributes it to shared pretraining corpora producing correlated errors. Auditing Multi-Agent LLM Reasoning Trees (arXiv 2602.09341, Feb 2026) targets the same failure under the name confabulation consensus. Nine Judges, Two Effective Votes (arXiv 2605.29800, May 28 2026) quantifies it with Kish effective sample size against a Condorcet null and finds panel accuracy falling 8 to 22 points short of what independent voting would achieve.

Basin's claim is therefore not that the phenomenon exists. It is:

> Basin moves the counter-consensus question into formal mathematics, where disagreement is adjudicated by a fixed deterministic proof kernel rather than by a human label, an LLM judge, or a benchmark answer key. Blind heterogeneous families, singleton dissent, a frozen acceptance surface.

Every prior result above adjudicates with something that shares failure modes with the thing being measured. Minority Sentinel says so explicitly: GPT-4o as arbiter performed worse than no intervention because it shares blind spots with the debaters. Basin's oracle shares no blind spots with anything, which is the entire point and the only thing here that is new.

**What Basin does not claim.** Nothing about relative model quality. Nothing about novelty of any statement or proof. Nothing about mathematical significance. It is not a discovery instrument and must never be reported as one.

---

## 4. Acceptance surface

A bare Lake project. Not `formal-conjectures` in v1; that arrives with the OPEN stratum. Pin `lean-toolchain` and the Mathlib commit and record both hashes in every data record.

Every corpus item is a closed proposition `P`. One primitive:

```
verdict(P, claimed_stance, proof_body) -> ACCEPT | REJECT + axiom_list + compile_log
```

Assembly, per claimed stance:

- `PROVABLE`  → `theorem basin_target : P := <proof_body>`
- `REFUTABLE` → `theorem basin_target : ¬ P := <proof_body>`
- `UNKNOWN`   → nothing is compiled; any Lean text in the response is ignored

`P` is always pulled from the frozen corpus file. That single line of string assembly is the entire goalpost lock, and it closes the most common autoformalization failure without any receipt machinery.

This symmetry is the fix v1 was missing. In v1 the primitive only knew how to test a proof of the statement, so PROVABLE claims were kernel-adjudicated and REFUTABLE claims were taken at the model's word. Now both directions are certified by the same gate, and the TRUE and REFUTABLE strata are measured identically.

Gates, in order, all four required:

1. Compiles under the pinned toolchain, 120s timeout.
2. No `sorry` / `sorryAx`.
3. `#print axioms` is a subset of `{propext, Classical.choice, Quot.sound}`.
4. Tactic ban list: `native_decide`, anything routing through `reduceBool`.

No partial credit. Each attempt compiles in its own generated module under a temp directory; there is no shared scratch file, because the sweep runs four compiles in parallel and a shared file would race.

---

## 5. Corpus

**Paired construction.** TRUE and REFUTABLE items are not generated independently. Each parent Mathlib lemma yields exactly one certified-refutable mutant, and the pair keeps a shared id:

```
true_0041  <->  refutable_0041
```

Every refutable item therefore has a direct true control with nearly identical mathematical surface form. This controls for theorem family and syntax, lets you ask whether an arm that gets the parent right gets its near-neighbour wrong, and turns memorization of the parent from pure contamination into an experimental variable. One mutant per parent: multiple mutants from one parent produce clustered observations and confidence intervals that look stronger than they are. If a later version uses several per parent, bootstrap by parent, not by item.

**TRUE (n=60).** Real Mathlib lemmas, proof stripped. Ground truth: PROVABLE. Record the commit date each lemma entered Mathlib.

**REFUTABLE (n=60, from ~180 candidates).** Scripted mutations, one per parent. Ground truth: REFUTABLE, proven so before entry per hard rule 4.

Mutation operators, over types with decidable instances:
- relax a hypothesis bound (`n ≥ 2` to `n ≥ 1`, `0 < x` to `0 ≤ x`)
- flip a relation (`≤` to `<`, and back)
- perturb a numeric literal
- drop a conjunct from the hypothesis
- swap quantifier scope where the result still typechecks

The operator that produced each item is recorded, because §7 stratifies by it. Mutation is scripted, never model-generated: a model-generated mutant shares priors with the arms and contaminates the stratum.

Candidates that fail certification are written to `corpus/rejected.jsonl` with the reason, not discarded. They are the selection mechanism §13 flags, and they are the only evidence about how the operators behave.

**CANARY (n=20, ten per polarity).** Propositions with zero corpus mass, constructed from a sealed random draw so they exist in no training corpus anywhere. Record the seed, the algorithm, and the mapping; seal the derivation procedure alongside the draw so a third party can reproduce it without having been present.

Construction: draw random constants of a size where `decide` times out but `norm_num` or `omega` closes it, so the item tests tactic selection rather than recall. The refutable polarity is the same construction with one constant perturbed. Both machine-certified before entry.

This is the two-sided calibration gate, and it subsumes the TRUE-synthetic mini-stratum Review C proposed: a sealed random draw is a stricter zero-corpus-mass anchor than hand-written non-Mathlib truths, and it covers both polarities instead of one. Without it, a clean TRUE-stratum result cannot be told apart from memorization.

**OPEN (n=30).** Statements from `google-deepmind/formal-conjectures`. No ground truth. Not measured, not sampled, and not paid for in v1. They exist so a calibrated instrument has somewhere to point.

**Difficulty is a tuning knob, not a given.** The frequency of 4-1 splits is a function of per-arm accuracy. Too easy and every item is 5-0; too hard and every arm answers UNKNOWN. Target per-arm accuracy of 0.75 to 0.80 on the REFUTABLE stratum. If a calibration pass lands above that, add mutations that break a deep invariant rather than a surface inequality; if below, the parents are too hard. Prefer Mathlib lemmas added in the last six months, which are both less memorized and more varied in difficulty.

---

## 6. Protocol

Five primary arms, one per model family. Arms are not named in this spec, because model strings churn faster than the spec should. The selection criterion is: five distinct pretraining lineages, no two from the same vendor. Actual strings are pinned in `arms.json` at freeze and recorded in every data record.

Blind: identical prompt, no shared context, no arm sees another arm's output. This is PULSE's contract. The prompt template lives in the repo verbatim; results are not replicable without it.

Single-shot. No repair loop, no multi-turn. Repair loops measure capability under iteration, which is a different question.

Response schema:

```json
{
  "stance": "PROVABLE" | "REFUTABLE" | "UNKNOWN",
  "proof_body": "...",
  "reasoning": "..."
}
```

One field for the proof body, not two. Which theorem it gets assembled into is decided by `stance`, per §4.

**Aggregation.** Four samples per arm per item. An arm holds a **committed stance** only if 3 or 4 of its samples agree; anything else is UNKNOWN. Modal voting was v1's rule and it was too loose, since a 2/1/1 distribution would have been reported as a confident stance. The four samples exist to separate uncertainty from confident error, and only the 3-of-4 rule makes them do that.

**Temperature.** Fixed at one stated value above zero across all arms, recorded in every record. Review B asked for temperature 0 or a fixed seed; that is incompatible with the sampling design, because at temperature 0 all four samples collapse and the aggregation rule above becomes vacuous. Sampling variance is part of what is being measured, not noise to be removed.

**Consistency is reported.** Per arm, the fraction of items where all four samples agreed. A dissenter that is internally certain and contradicts the majority is a different object from one that is flailing, and §7 separates them.

**Model-string discipline.** Log `model_requested` and `model_string_served` separately in every record. Floating aliases are banned as arm identifiers. If the served string changes mid-sweep, that arm's sweep is invalidated and rerun, not patched. This is the grok-4 lesson and it costs nothing to encode up front.

---

## 7. Pre-registered estimands

Frozen before the first sweep, at a tagged commit, with the tag recorded here. Nothing below changes after data exists.

Let `G(i)` be ground truth, `S(m,i)` arm m's committed stance.

**A note on what the kernel does here.** On the measured strata the kernel is not discovering ground truth. Ground truth was certified when the item entered the corpus. The kernel's job is to check whether an arm's *evidence* earns its *claim*. The kernel's independent-adjudicator role only bites on OPEN, which v1 does not run. Saying otherwise would overclaim, so E5 is named for ground truth rather than for the kernel.

**Two observations per arm per item, never collapsed:**
- **claimed stance** — what the search kernel believes. Primary, because the Feb 11 phenomenon was epistemic disagreement.
- **certified stance** — what its submitted proof body actually earns at the acceptance surface. Secondary, and the gap between the two is itself a finding: it measures confident assertion without demonstration, which is the VDAC1 failure in miniature.

**E1. Per-arm accuracy.** `P(S(m,i) = G(i))`, reported for claimed and certified separately, and per stratum. Baseline, not a finding. `p` from this estimand feeds E3b.

**E2. Majority accuracy.** Committed-stance majority across the five primary arms, same measure.

**E3. Counter-consensus. The primary estimand.**

*Eligibility.* An item is a **committed 4-1 event** iff all five primary arms hold a committed stance, exactly four hold one of `{PROVABLE, REFUTABLE}`, and exactly one holds the other. An UNKNOWN singleton is uncertainty, not dissent, and does not qualify. The sixth correlation arm is excluded from eligibility and from the count, because adding it changes the split geometry.

*E3a. Dissenter win rate.* `P(dissenter matches G | committed 4-1)`. Null is **0.5**, since majority and dissenter are opposing binary claims on these events. Above 0.5 means the counter-consensus singular literally beats majority voting.

*E3b. Counter-consensus lift.* Same numerator, against the independence null. Under five arms with independent errors and per-arm accuracy `p`, conditional on a 4-1 split:

```
P(dissenter right | 4-1 split) = (1-p)³ / [p³ + (1-p)³]
```

Derivation, since the whole experiment turns on it. Four-correct-one-wrong has probability `5p⁴(1-p)`; four-wrong-one-correct has probability `5p(1-p)⁴`. The dissenter is right only in the second case, so the conditional is `p(1-p)⁴ / [p⁴(1-p) + p(1-p)⁴]`, and dividing through by `p(1-p)` gives the expression above. At p = 0.8 it is 1.5%; at p = 0.7, 7.3%. Under independence the majority's advantage is cubed and the dissenter essentially never wins.

Estimate `p` from E1 on the same stratum being analysed, since accuracy differs by stratum. Report the observed rate against both thresholds with confidence intervals.

v1 said "against the null of the pooled individual error rate." That was wrong. The pooled error rate is not conditioned on the 4-1 split at all and sits between the two real thresholds, which is the one place a null must never sit.

*Pre-committed interpretation, three-way, fixed before data:*

- E3a interval entirely above 0.5 → the strong claim holds. The minority beats the majority outright on committed dissent events, and the February flag is confirmed in its strong form.
- E3a interval contains 0.5 but E3b interval entirely above the independence null → the weak claim holds. Errors are correlated enough that dissent carries real information, though the majority still wins on average. This is the more likely outcome and it is still a result.
- Neither → the flag is closed as negative at this n, with the required n stated. Written up the same as a positive result.

*Stratification, reported separately, not pooled:*
- by stratum. A wrong majority on TRUE can be explained by shared memorization of adjacent literature; on REFUTABLE it cannot, since mutants exist in no corpus. A 4-1 wrong majority on REFUTABLE is evidence of a shared *reasoning* attractor rather than a data attractor.
- by mutation operator. If one operator produces most of the wrong majorities, that is a map of where these models' shared attractors live, and it may be the most citable output of the instrument.
- by dissenter consistency (4/4 versus 3/4 samples).

**E4. Arm correlation.** A sixth arm, a second checkpoint of an existing family. Report Kish effective sample size against a Condorcet null, following Nine Judges, Two Effective Votes, so the number is comparable to published work rather than an ad-hoc agreement rate. If effective sample size is far below five, every majority number in E2 and every null in E3b is weaker than its nominal value, and that is a finding about the field and not only about Basin.

**E5. Ground-truth-versus-majority disagreement log.** Every item where the committed majority is wrong, written out in full and readable by hand.

**Power and the growth rule.** One-sided binomial against 0.5: 25 events gives roughly 50% power at a true rate of 0.70; 50 events gives roughly 85 to 90%; 50 events at a true rate of 0.65 gives roughly 60 to 70%. Review D's figures check out to within a few points under a normal approximation with continuity correction, but `analyze.py` computes the exact binomial before freeze rather than inheriting either estimate.

- **Pilot threshold: 25 eligible events.**
- **Primary analysis threshold: 50 eligible events.**

Grow the paired corpus in fixed batches of 40 pairs until 50 eligible events occur or a pre-registered maximum of 160 pairs is reached. Complete every batch before checking the stopping rule. Never stop because the effect looks good.

**Expected yield, and why the budget does not close.** Under independence at p = 0.75 with a per-arm commit rate of 0.85, the fraction of items producing an eligible event is about `0.85⁵ × 0.41 ≈ 0.18`. At 120 measured items that is roughly 22 events, which clears the pilot gate and misses the primary gate. Correlated errors push it lower, because correlated arms fail together into 5-0 rather than splitting 4-1. So the corpus almost certainly needs two growth batches, and the pilot budget in §8 does not cover them. That is stated here rather than discovered at the end of a sweep.

---

## 8. Knobs v1

Starting values, set from stance. Change any of them before freeze; none after.

| Knob | Value | Why |
|---|---|---|
| Primary arms | 5 families | A 4-1 split is meaningful at 5; matches PULSE |
| Correlation arm | 1, excluded from E3 | Second checkpoint of one family, for E4 only |
| Samples per arm per item | 4 | 3-of-4 commit rule needs 4 |
| Commit rule | 3/4 or 4/4 | Anything looser reports uncertainty as confidence |
| Temperature | fixed, above zero, recorded | Zero collapses the samples |
| TRUE stratum | 60, paired | Parent lemmas, Mathlib, recent-first |
| REFUTABLE stratum | 60, paired (from ~180 candidates) | One certified mutant per parent |
| CANARY stratum | 20 (10 per polarity) | Two-sided zero-corpus-mass anchor |
| OPEN stratum | 30, not run | Not measured and not paid for in v1 |
| Measured items, pilot | 140 | 60 + 60 + 20 |
| Pilot sweep calls | 3,360 | 140 x 6 arms x 4 samples |
| Smoke test first | 10 items, ~$25 | Project full cost before committing |
| Pilot budget cap | $350 | Sweep does not start if the smoke test projects over |
| Primary analysis, if authorized | up to 160 pairs, ~8,200 calls, ~$900 | Separate authorization; see §7 |
| Target per-arm accuracy | 0.75-0.80 on REFUTABLE | Below and arms abstain, above and splits vanish |
| Lean compile timeout | 120s | Generous; most finish under 30s |
| Compile parallelism | 4 | Per-attempt temp modules, no shared scratch |
| Axiom allowlist | propext, Classical.choice, Quot.sound | Mathlib standard |
| Pilot gate | 25 eligible events | Descriptive |
| Primary gate | 50 eligible events | Powered |
| Disagreement log read-back cap | 40 items | Above that, sample; see §11 |

If the smoke test projects over the pilot cap, **shrink the corpus before starting**. Do not start and truncate; hard rule 8.

---

## 9. Repo layout

Authority is annotated, because an arriving instance should not have to guess which files are load-bearing.

```
basin/
├── SPEC.md                  # AUTHORITATIVE. this document. repo copy wins over any draft
├── README.md                # pointer to SPEC.md + STATUS line. nothing else
├── arms.json                # pinned model strings, frozen at freeze
├── prompt.txt               # the verbatim prompt template. results are not replicable without it
├── lean/                    # AUTHORITATIVE (pinned)
│   ├── lean-toolchain       # pinned, hash recorded in every run record
│   ├── lakefile.lean        # mathlib pinned to a commit hash
│   └── tmp/                 # per-attempt generated modules, disposable, never read back
├── corpus/                  # AUTHORITATIVE, append-only after freeze
│   ├── pairs.jsonl          # parent + mutant together, shared id, operator, both certificates
│   ├── canary.jsonl         # proposition, polarity, seed, derivation, seal
│   ├── rejected.jsonl       # mutation candidates that failed certification, with reason
│   └── open.jsonl           # not run in v1
├── verdict.py               # the acceptance surface. the most-audited file in the repo
├── mutate.py                # mutation operators + refutation certification
├── arms.py                  # provider adapters, blind dispatch, model-string drift check
├── sweep.py                 # the for loop
├── analyze.py               # E1-E5 and nothing that is not a frozen estimand
├── runs/                    # RECEIPTS. append-only. never pruned, never compacted
│   └── YYYY-MM-DD.jsonl
└── reports/                 # the read-back surface. one per sweep
    └── YYYY-MM-DD-disagreements.md
```

`lean/tmp/` is the only place in the repo that is written and thrown away. Everything else either states intent or records what happened.

**STATUS line format**, one line in README.md, parseable without reading prose:

```
STATUS: phase=<P0..P7> gate=<open|closed> events=<n eligible> spec=<v2> updated=<YYYY-MM-DD>
```

---

## 10. Data record

The only schema in v1. There is no registry. If a registry is ever worth building, its schema falls out of what fifty runs actually needed queried, not out of a design essay.

```json
{
  "run_id": "2026-08-15T02:31Z",
  "spec_commit": "abc123",
  "item_id": "refutable_0041",
  "pair_id": "0041",
  "stratum": "REFUTABLE",
  "mutation_op": "relax_bound",
  "ground_truth": "REFUTABLE",
  "arm": "family-c",
  "arm_role": "primary",
  "model_requested": "...",
  "model_string_served": "...",
  "temperature": 0.7,
  "sample_idx": 2,
  "stance_claimed": "PROVABLE",
  "kernel_result": "REJECT",
  "reject_reason": "compile_error",
  "axioms": [],
  "lean_toolchain": "leanprover/lean4:v4.x.y",
  "mathlib_commit": "def456",
  "tokens_in": 412,
  "tokens_out": 1180,
  "cost_usd": 0.041,
  "wall_ms": 8320
}
```

Committed stance and certified stance are derived by `analyze.py` from the four sample records; they are not stored, so there is one place the aggregation rule lives.

---

## 11. Read-back policy

A pilot sweep produces roughly 3,400 model responses. Written and never read, that is the same accumulation problem as 828 unread subagent transcripts, reproduced deliberately.

So the read-back surface is declared up front and it is small:

- **`reports/*-disagreements.md` is the thing a human reads.** E5, written out in full, one sweep per file.
- If a sweep produces more than 40 disagreement items, the report samples down to 40 with the sampling rule stated in the file. It does not grow to fit.
- The raw `runs/*.jsonl` is a receipt store, queried by `analyze.py`, and is explicitly not expected to be read end to end by anyone. Saying so is the point; the failure mode is pretending otherwise.

**DoD for a sweep:** Anthony reads the disagreement report, picks five items at random, checks ground truth and the kernel verdict by hand, and says so. Not a green CI badge.

---

## 12. Phases, strict order

No phase starts until the prior gate closes. Each phase ships its own redteam fixture, and the fixture must fail before the phase counts as passing.

**P0. Acceptance surface.**
Bare lake project, Mathlib pinned, `lake exe cache get` working, per-attempt temp modules.
*Gate:* `verdict(P, stance, body)` returns ACCEPT/REJECT plus an axiom list on hand-written cases in all three stance branches.
*Redteam:* a body containing `sorry`; a body using `native_decide`; a body that proves a different proposition than `P`; a `REFUTABLE` claim whose body actually proves `P`. All four refused, and the third refused by construction rather than by detection.

**P1. TRUE stratum, small.**
Twenty Mathlib lemmas, each verified to compile with its original proof, then stripped.
*Gate:* twenty items in `pairs.jsonl` with the parent side populated, all of which passed with their real proofs first.
*Redteam:* a stripped item whose original proof is re-supplied must ACCEPT; one with a single tactic deleted must REJECT.

**P2. One arm.**
Wire a single model. Twenty items, four samples, aggregation rule applied.
*Gate:* `runs/` holds a real jsonl, and one arm's claimed and certified accuracy are both known.
*Redteam:* a malformed response and a refusal both land as MALFORMED rather than crashing or silently dropping.

**At the close of P2 the project has produced data.** If the work stalls, it stalls here and not before.

**P3. Mutation and pairing.** Operators, certification, `rejected.jsonl`, 60 pairs. *Redteam:* a mutant that is still true must be rejected by the certification step.

**P4. Calibration.** Run the single P2 arm across the finished pair corpus. Measure per-arm accuracy on the REFUTABLE side.
*Gate:* accuracy lands in 0.75 to 0.80. If it is higher, harden the mutations; if lower, soften the parents. Do not proceed on an untuned corpus; the whole event yield depends on this number.

**P5. Canary draw**, sealed, both polarities. *Redteam:* the seal is reproducible from the recorded seed and derivation by someone who was not present.

**P6. Remaining arms.** Four more primary, blind dispatch, model-string drift check, `arms.json` pinned. *Redteam:* a mid-sweep alias change invalidates that arm.

**P7. Freeze and sweep.** Tag the estimands. Smoke test, project cost, then pilot sweep. `analyze.py`. Then the correlation arm and E4. Then, and only then, the growth batches or the decision to stop at pilot.

OPEN is not run in v1 under any circumstances.

---

## 13. What Basin cannot see

Maintained live. Adding to this list is progress, not an admission.

- **Whether an accepted proof is a good proof.** ACCEPT means it typechecks under the allowlist. Nothing about elegance, length, generality, or whether a human would call it a proof of the intended thing.
- **Whether a rejected proof was close.** No partial credit, so a proof failing on one tactic and a proof that is nonsense record identically.
- **Anything about novelty.** No claim that any proposition or proof is new.
- **Whether the arms are actually independent.** E4 catches same-vendor correlation. Shared pretraining corpora across vendors are not caught, and cannot be, from inside this instrument. Published work says provider diversity does not restore independence, so treat five families as fewer than five measurements by an unknown amount that E4 only lower-bounds.
- **Whether the prompt is neutral across arms.** One prompt, written once, fits some arms better than others. Basin therefore says nothing about relative model quality.
- **Convention-fill.** Where the prompt is silent, arms fill the gap with shared convention, and agreement then measures convention rather than mathematics. Every silence in the prompt is a place E2 and E3 measure something other than what they claim.
- **Selection on acceptance.** The REFUTABLE stratum contains only mutants that could be refuted in practice, which is non-random and enriches for cleanly checkable falsehood. It does not bias E3 against ground truth, since truth is known either way, but it inflates event rates relative to a natural distribution of false statements, and the write-up must say so.
- **Temperature confound.** The commit rate, and therefore eligibility, depends on the sampling temperature. Basin cannot separate "this arm is uncertain" from "this arm is temperature-sensitive."
- **Compile-time variance under load.** A cluster of timeouts on one night is infrastructure, not model signal. Wall time and reject reason are recorded so the two can be told apart after the fact, but not during.
- **UNKNOWN as a strategy.** An arm that abstains often is never wrong and never right. Abstention rate is reported alongside accuracy so it cannot hide, but E1 through E3 do not otherwise penalize it.
- **Anything about the OPEN stratum.** Zero measurements, by design.
- **Why a rejected proof failed.** Added 2026-08-11. Until `sweep.py` commit `ab5c19e`, `parsed.proof_body` was passed to `verdict()` and discarded; records carried `reject_reason` and nothing of the proof itself. Runs written before that commit — the P2 sweep of 2026-08-09 and the first P4 calibration of 2026-08-11 — are permanently unforensicable at the proof level, and their bodies must never be reconstructed or backfilled, because a regenerated body is not the body that failed. Every hypothesis advanced about the first calibration's 84 compile errors was therefore inferred from metadata about the attempts rather than the attempts; four were advanced and all four died. Runs from `ab5c19e` forward persist `proof_body` and a capped `compile_log_snippet` on every sample, successes included.
- **The corpus selection rule.** Added 2026-08-11. Parents 0021–0105 were harvested from Mathlib by a tool that was never committed and cannot be reproduced. Each pair remains individually checkable — the certificate, the axioms, the toolchain pin, the source module — but the FILTER that chose these parents and rejected others is unrecoverable. Every arm measured against this corpus inherits a selection rule nobody can inspect, and no amount of per-pair verification recovers it. A reconstruction would be a hypothesis about the filter, never the filter.

  **What inspection of the parents does establish, 2026-08-11:** the rule did NOT implement this section's own recency preference. Parent `added` dates span 2022-12-16 to 2026-06-30, and **68% of the measured REFUTABLE items (45 of 66) derive from parents older than six months**, including sixteen from 2022–2023. §5 prefers "Mathlib lemmas added in the last six months, which are both less memorized and more varied in difficulty"; the P1 twenty honoured that and the uncommitted expansion to 105 did not. This is compositional fact, not inference. What is NOT established is any contamination effect from it: certified accuracy on older parents ran 0.600 versus 0.524 on recent, and claimed 0.933 versus 0.905, both directions consistent with a memorisation advantage and neither remotely significant (two-sided Fisher p = 0.601 and 0.650, n = 45 vs 21). The exposure is real and documented; the effect is unmeasured, and at this corpus size this design cannot measure it.
- **Whether an operator is weak or merely unreachable.** Added 2026-08-11. Operator yield and admitted-item composition are jointly selected by mutation applicability and certification reachability; zero yield cannot distinguish weak mutation from unreachable proof shape. Demonstrated the same day: `flip_strictness` read as a dead operator across 105 parents and was in fact overdetermined by three independent mechanisms — last position in `OPERATORS` so `per_parent_cap` truncated it, mutants quantifying two variables where the ladder supplied one witness, and applicability. Per-operator analysis of wrong majorities carries this confound; the within-corpus stratification of §7 survives it, cross-operator comparability does not.

---

## 14. Limitations carried in from prior work

Not new. Paid for elsewhere, applying here unchanged.

- **Seat independence thins under shared design context.** Arms receiving a prompt written by one model, describing a task designed by that model, are less independent than the vendor list suggests. Name it; do not claim to have solved it.
- **Agreement is evidence about the shared hypothesis space, not about its completeness.** Four arms agreeing establishes what four correlated systems find natural. It does not establish that the fifth option was considered.
- **A quantized metric bounds its own resolution.** E3 is a proportion over eligible events, so its precision is capped by how many the corpus produces. A thin cell reads as weak whether or not the effect is real.
- **PASS on a calibration gate is necessary, not sufficient.** A green canary means the harness is not obviously broken. FAIL stays informative; PASS is weak clearance and gets reported as such.
- **Correlated errors get worse with scale.** Published work reports that larger and more accurate models have more strongly correlated errors than smaller ones, across architectures and providers. Basin's independence null in E3b is therefore an upper bound on how surprising a dissenter win should be, and the gap between the two nulls is where the honest reading lives.

---

## 15. Recording

Insights, catches, and reversals go to the Sovereign Stack under domain `basin`, layer per the usual convention. The stack is not a runtime dependency: Basin runs, and Basin's results stand, with the stack down.

Corrections get recorded as corrections. A superseded finding keeps its original entry and gains a dated one pointing at it. Nothing is quietly fixed.

---

## 16. Decisions

**Closed in v2.** All four reviews reached the same position on these, and the reasoning rather than the count is what closed them.

1. **Standard mode, not reasoning mode, for the first sweep.** The object of measurement is the disagreement structure. Raising every arm's accuracy compresses the split space and starves E3 of events, and the target accuracy band in §5 says so numerically. Reasoning mode is a planned second condition, and it carries its own question: does increased capability reduce counter-consensus events, or make correlated consensus more confident?
2. **Inherit PULSE's protocol, write a fresh runtime.** The blind-dispatch contract is the hard-won part. Model strings and SDK surfaces are mechanical. Do not turn reuse into a week of resurrecting Evo.
3. **Name: Basin.** Repo `basin`. Full title at the top of this file. The acceptance basin is the fixed object; the metaphor is doing real work.

**Open, and yours.**

4. **Pilot or primary.** §7 shows the pilot corpus clears the 25-event gate and misses the 50-event gate, and §8 prices the difference at roughly $350 versus roughly $900. Running the pilot and stopping produces a descriptive result. Running to the primary gate produces a powered one. Deciding now is better than deciding after the pilot returns a number you like.

---
---

# Appendix — the review record

## 17. Supersessions

Dated entries against frozen sections, per §0: supersede by adding, never by editing in place. Each entry names what it supersedes and why. A superseded line keeps its original text above; this section governs.

### 2026-08-11 — §5 and §12 P4: WHICH accuracy the calibration band governs

**Supersedes nothing in wording; resolves an ambiguity that reverses the prescribed action.**

§5 says "Target per-arm accuracy of 0.75 to 0.80 on the REFUTABLE stratum. If a calibration pass lands above that, add mutations that break a deep invariant rather than a surface inequality; if below, the parents are too hard." §12 P4 says "accuracy lands in 0.75 to 0.80. If it is higher, harden the mutations; if lower, soften the parents." Neither says whether "accuracy" means CLAIMED or CERTIFIED. §12 P2's gate names both as distinct quantities ("one arm's claimed and certified accuracy are both known"), so the distinction exists in the spec and the P4 band does not pick one.

The first calibration made the ambiguity load-bearing rather than academic. Run `2026-08-11T07:49:50Z`, family-x, 66 REFUTABLE items:

| reading | value | position vs band | §5 prescribes |
|---|---|---|---|
| certified | 0.5758 | below | soften the parents |
| claimed | 0.9242 | above | harden the mutations |

**The two readings prescribe opposite corpus surgery on the same data.** Acting on either without pinning the term first would have reshaped the instrument on a coin-flip, and the direction of the error would have been invisible afterward, because a wrongly-tuned corpus still produces a plausible number.

**Not resolved here.** Pinning this is a design decision with the authority ordering of §0 behind it, and it is Anthony's. What this entry fixes is that the ambiguity is now named, dated, and impossible to resolve silently by whichever seat runs the next sweep. Until it is pinned, no tuning action is authorised in either direction.

**Recorded for whoever pins it:** §5's stated rationale is split structure — "the frequency of 4-1 splits is a function of per-arm accuracy. Too easy and every item is 5-0; too hard and every arm answers UNKNOWN" — and §7's yield model at the same section uses commit rate and accuracy as SEPARATE parameters (`0.85⁵ × 0.41`). Whichever term is pinned, the yield model's `p` and its commit rate must be pinned to the same reading or the projection is incoherent.

### 2026-08-11 — §6 and §10: the aggregation rule is already specified

**No change. Recorded to close a question, not to open one.**

The rule for aggregating four samples into a committed stance was raised as unwritten. It is written, in three places: §6 ("An arm holds a committed stance only if 3 or 4 of its samples agree; anything else is UNKNOWN"), the §8 knobs table ("Commit rule | 3/4 or 4/4"), and §10 ("Committed stance and certified stance are derived by `analyze.py` from the four sample records; they are not stored, so there is one place the aggregation rule lives"). `analyze.py`'s `committed_stance()` implements exactly that and is applied PER ITEM to `stance_claimed` for the claimed figure and to `certified_sample_stance` for the certified figure. Granularity is therefore already per-item throughout; no supersession is required for either.

Verified against the first calibration rather than assumed: 66 items, 61 claimed-correct, 38 certified-correct, and the certified set is a strict SUBSET of the claimed set (checked, not inferred from the definitions).

### 2026-08-11 — §7: conditional certification, computed and available today

**Additive. Frozen estimands unchanged.**

Certification given a correct committed stance, per item, on run `2026-08-11T07:49:50Z`: **38/61 = 0.6230**. Twenty-three items carried a correct committed stance with no checking proof.

This quantity separates the two capabilities the single word "accuracy" fuses: epistemic stance (does the arm know the statement is false) and Lean certification (can it produce a proof that checks, one shot, no repair loop). It required no new sampling. It is reported as a derived diagnostic and is NOT promoted to a frozen estimand here, for the reason in the next entry.

### 2026-08-11 — §7: contamination guard on any stance-only measurement

**Constraint on future amendment, not an amendment.**

If claimed stance is ever split out as a headline measurement, it needs a contamination control before it is reported, because claimed stance is the memorization-vulnerable quantity and certification is what makes it load-bearing. On a corpus built from Mathlib lemmas, an arm that has memorised the parent can produce the correct stance without any reasoning about the mutant. Certification is expensive to fake and stance is not. §5 already gestures at this by preferring lemmas added in the last six months; that is a mitigation, not a control. Do not promote the easier-to-fake number without a guard that is stated before the number is read.

### 2026-08-11 — §16: repository name

**Supersedes §16's "Repo `basin`."**

The repository is **`temple-mathematic-basin`**, remote `https://github.com/templetwo/temple-mathematic-basin` (private). §16 named it `basin` before the working directory existed. The directory, all twelve commits, the Sovereign Stack chronicle domain, and every cross-reference written to date use `temple-mathematic-basin`; renaming now forks every existing reference to save a word. The metaphor §16 defends — the acceptance basin as the fixed object — is untouched by the longer name.

---

Everything below is prior material, kept for provenance. **It is not authoritative.**
§0–§16 above wins over anything here, per the authority ordering in §0.

---

## What v2 changed

**Both corrections v1 left unabsorbed are now absorbed.**

**1. The E3 null (raised by Review C, seconded by Review D) — ABSORBED in §7.**
v1 compared the dissenter win rate against "the pooled individual error rate," which is not
conditioned on the 4-1 split. §7 now carries two nulls: E3a against 0.5 (does the dissenter
beat the majority outright) and E3b against the independence null `(1-p)³ / [p³ + (1-p)³]`
with `p` estimated from E1 per stratum. The derivation is written out in §7 and checks:
four-correct-one-wrong is `5p⁴(1-p)`, four-wrong-one-correct is `5p(1-p)⁴`, and dividing the
conditional through by `p(1-p)` gives the stated form. A three-way pre-committed
interpretation replaces the single threshold.

**2. Stance/certificate separation (raised by Review D) — ABSORBED in §4 and §6.**
Every corpus item is now a closed proposition `P`, the primitive is
`verdict(P, claimed_stance, proof_body)`, and the stance vocabulary is uniform
(`PROVABLE | REFUTABLE | UNKNOWN`). Claimed and certified stance are recorded separately and
hard rule 3 forbids collapsing them. The stratum formerly called FALSE is now REFUTABLE.

**Also absorbed, previously listed as raised-and-absent:**
- Paired TRUE/REFUTABLE corpus, one mutant per parent, shared id, bootstrap by parent (Review D) — §5.
- Per-arm consistency across the four samples as a reported metric (Review B) — §6.

**Further review items absorbed:**
- 3-of-4 commit rule replacing modal aggregation (Review D) — §6.
- 4-1 eligibility restricted to five committed arms with an opposite-stance singleton; correlation arm excluded (Reviews C and D) — §7.
- Stratification by stratum, by mutation operator, and by dissenter consistency (Review C) — §7.
- Pilot 25 / primary 50 gates, fixed-batch growth, complete-the-batch stopping rule (Review D) — §7.
- Corpus difficulty as a tuning knob, target 0.75–0.80 per-arm accuracy, calibration phase (Review B) — §5, §12 P4.
- Prompt template stored verbatim in the repo (Review B) — §9.
- Compile only on PROVABLE or REFUTABLE, ignore Lean text on UNKNOWN (Review B) — §4.
- Compile-time variance under load as a named blind spot (Review B) — §13.
- Narrowed novelty claim with prior art (Review D) — §3.
- Call arithmetic corrected; OPEN not sampled and not paid for (Reviews C and D) — §8.
- Name kept, standard mode first, inherit PULSE's protocol (all four reviews) — §16.

**Three review items were corrected rather than absorbed.**

- **Temperature 0 (Review B) is incompatible with the sampling design.** At temperature 0 the
  four samples collapse and the commit rule becomes vacuous. §6 fixes temperature above zero
  and records it. Within-arm sampling variance is part of the measurement.
- **Review D's power figures were checked, not inherited.** They reproduce to within a few
  points under a normal approximation with continuity correction (n=25 at a true rate of 0.70
  gives roughly 50% power against a critical value of k≥18). §7 requires `analyze.py` to
  compute the exact binomial before freeze rather than carrying either estimate forward.
- **Review C's TRUE-synthetic mini-stratum is subsumed by the canary stratum**, which is a
  stricter zero-corpus-mass anchor and covers both polarities. Not added as a fifth stratum.

**Raised by no review, found on re-read:**
- A single shared `Scratch.lean` races against parallelism 4. §4 and §9 use per-attempt temp modules.
- "Abort the run if the budget is exceeded" produces an unbalanced partial sweep. Hard rule 8 now requires sweeps to complete or be discarded, and §8 shrinks the corpus before starting instead.
- Failed mutation candidates are recorded in `corpus/rejected.jsonl` rather than discarded; they are the selection mechanism §13 flags.
- Arms are specified by selection criterion in the spec and pinned as strings in `arms.json` at freeze, so the spec survives model churn.
- On the measured strata the kernel verifies claims against ground truth already certified; it does not discover ground truth. E5 is renamed accordingly, and the kernel's adjudicator role is noted as biting only on OPEN.
- E4 reports Kish effective sample size against a Condorcet null, following published method, rather than an ad-hoc agreement rate.
- The expected event yield does not reach the primary gate within the pilot budget. §7 states the arithmetic and §16 turns it into a decision rather than a surprise.

**Open after v2:** the pilot-versus-primary budget decision in §16.

---

## Review A — "the correct first instrument"

*Endorses the design and the scope discipline. Names the three core strengths: fixed
acceptance surface with varying kernels, the assembly rule as goalpost lock, and the
self-certifying FALSE stratum. Sequencing: Basin first, then build the sandbox around the
measured weight function.*

**Basin is the correct first instrument.**

It isolates the exact question that has been carrying since February 11: when heterogeneous models disagree on a formal claim and a deterministic oracle settles it, does the minority report systematically outperform the majority? The VDAC1 polarity case was suggestive but under-powered because adjudication was expensive. Formal mathematics removes that cost. The Lean kernel gives you ground truth for free, at high volume, under a fixed acceptance surface. That is the right experimental frame.

The design is tight. The scope discipline is the most important part of the document.

### Core strengths

**1. Fixed acceptance surface, varying kernels**  
This is the entire methodological commitment, and it is correctly prioritized. Everything else in the larger architecture (registry, trust levels, adversarial review, novelty gates) is downstream of whether this asymmetry is real and measurable. By pinning the toolchain, the Mathlib commit, the assembly rule, and the four gates, you make the oracle invariant. The only variable is the search kernel. That is what makes the counter-consensus singular rate interpretable.

**2. Assembly rule (statement from corpus, proof body from model)**  
This is the cheapest and most effective goalpost lock available. One string concatenation eliminates the dominant autoformalization failure mode without any of the heavier receipt machinery. It is exactly the right minimal intervention for v1.

**3. Self-certifying FALSE stratum**  
Requiring a compiled refutation before a mutant enters the corpus is the correct integrity rule. It prevents the stratum from being poisoned by statements that remain true under mutation. Combined with the note that the FALSE stratum is structurally free of training contamination, this is where the headline measurement should live.

**4. Blind, single-shot, modal stance across four samples**  
PULSE already exists. Reusing the blind-dispatch pattern is efficient. Four samples is enough to distinguish “confidently wrong” from “unsure.” The design correctly refuses multi-turn repair loops; those measure capability under iteration, which is a different question.

**5. Explicit non-goals**  
The list of what is *not* in v1 is as important as what is in it. Registry, orchestration, novelty gate, agentic loops, trust protocol documents—all of those become meaningful only after you know whether the counter-consensus signal exists and how strong it is. Building them first would have been the classic error of constructing the cathedral before confirming the foundation.

### On the measurements

The five metrics are well-ordered. Metric 3 (counter-consensus singular rate) is the scientific payload. The power requirement (≥25 singleton-dissent events, preferably 50) is realistic and correctly treated as a growth condition on the FALSE stratum rather than a reason to lower the bar.

Metric 4 (family-correlation arm) is necessary. Without it, any majority accuracy number remains confounded by correlated training. Metric 5 (kernel-vs-majority disagreement log) will be the most readable and durable output; it should be treated as a primary scientific artifact, not a debugging dump.

Accuracy split by Mathlib lemma age on the TRUE stratum is the right contamination control. Lean on the FALSE stratum for the headline claim.

### Decisions left open

**1. Reasoning mode vs standard mode**  
I agree with the inclination: standard mode for the first full sweep. The object of interest is the *structure of disagreement*, not the ceiling accuracy of any single arm. Reasoning mode will raise every arm’s accuracy, compress the disagreement space, and cost several times more. That is useful as a later replication (does the singular advantage survive when every model is thinking harder?), but it is the wrong first measurement. Run standard mode, grow the corpus if needed to hit power, then do one reasoning-mode replication on a subset.

**2. Reuse PULSE or write fresh**  
Reuse the blind-dispatch and provider-adapter pattern; refresh the model strings and SDK surfaces. The cost of fixing stale adapters is lower than the cost of re-deriving the isolation guarantees. The scientific value is in the protocol, not in the plumbing being novel.

**3. The name**  
“Basin” works. It correctly signals a fixed surface that collects varying flows. Alternatives that stay in the same register:  
- **Verdict Surface** (too literal)  
- **Acceptance Invariance Probe** (accurate but heavy)  
- **Singular** (too narrow; the instrument measures more than the singular)  

Basin is fine. Keep it.

### Risks already named, plus two subtler ones

The five failure modes listed are the right ones. Two additional points of vigilance:

- **Prompt sensitivity across families.** Even with an identical prompt, some families will systematically under- or over-refuse formal tasks. The design correctly treats this as a limitation rather than something to tune away. Report malformed and refusal rates per arm; do not hide them.
- **Compile-time variance under load.** With parallelism of 4 and a 120 s timeout, overnight runs are feasible, but transient Lake/Mathlib cache pressure can produce spurious REJECTS. Record wall time and reject reason carefully; a cluster of “timeout” or “cache miss” rejects on one night is not model signal.

### Relation to the larger architecture

Basin does not replace the three-plane design or the Temple positioning. It is the empirical precondition for them.  

If the counter-consensus singular reliably outperforms the majority on the FALSE stratum, then the later decision to treat multi-model output as a *scheduling and challenge signal* rather than a truth signal is empirically grounded. If it does not, the February flag can be retired cleanly instead of remaining an open intuition. Either result is progress.

The instrument also supplies the first real data on how different model families behave under a fixed, hard acceptance surface—the exact condition the larger lab will later enforce at scale.

### Recommendation

Build it exactly as specified, in the session order given.

- Session 1–3 get you to real data with one arm.  
- Session 4–6 produce the first full sweep and the five metrics.  
- Session 7 adds the correlation arm.  
- Only then point anything at OPEN.

Do not expand scope. Do not introduce the registry, the novelty gate, or any of the grand-challenge machinery until Basin has answered its question with a confidence interval.

This is the right next object. It is small enough to finish, expensive enough in the right places (kernel adjudication is free; model calls are the real cost), and scientifically pointed at the precise asymmetry the rest of the architecture depends on.

---

## Review B — statistical power and the difficulty knob

*Accepts the design, pushes on statistics. Corpus difficulty is the hidden tuning knob:
too easy and 4–1 splits never fire, too hard and the minority signal is noise. Flags the
FALSE-item submission ambiguity and proposes per-arm consistency as a metric.*

This is exactly right. You've built a minimal instrument that answers the one question the whole `/grand-challenge-sandbox/` project hinges on, and you've done it with a $300 budget, a single Lake project, and a JSONL file. The counter‑consensus singular metric is what every multi‑model system should have been measuring since February. I'd like to push on a few statistical and engineering details, but the design is sound enough to start building tonight.

### What I'd keep exactly as written

- **The acceptance surface as the fixed point.** Freezing the toolchain and having `verdict(statement, proof)` be the only gate is beautiful. It moves the entire correctness burden onto deterministic machinery and leaves the models as pure signal generators.
- **The corpus integrity rule for the FALSE stratum.** Making every mutant carry a compiled refutation before it enters the corpus prevents the most subtle failure mode—a mutation that is accidentally true—without any external oracle. That's self‑certifying and cheap.
- **The build order with hard gates.** You only need to get through Session 3 to have produced data; after that you can stop, pivot, or scale. That's the right risk profile.
- **The `not in v1` list.** All of those things are good, but they would delay the one measurement that tells you whether the larger sandbox is even oriented correctly. Kill them.

### Statistical power: the corpus difficulty is the hidden tuning knob

The headline metric requires at least 25–50 singleton‑dissent events (4‑1 splits). The frequency of those splits is a direct function of per‑arm accuracy and inter‑arm correlation. If all five arms are, say, >90% accurate on your corpus, 4‑1 splits will be rare because most items will be 5‑0. With 120 items you'd need roughly p ≈ 0.8–0.85 to hit 30+ splits. If the corpus is too easy, you get almost no dissent events and the metric doesn't fire. If it's too hard (arms near chance), splits are plentiful but the minority signal might be random noise.

You need to **tune corpus difficulty** so that the arms are neither ceiling‑high nor floor‑low on the FALSE stratum, because that's where the cleanest signal lives. I'd recommend adding a small calibration step after you have the first arm's data (Session 3), and again after the mutation set is built: run a handful of items through a cheap baseline (e.g., a 7‑8B open prover) and check the error rate. Aim for a FALSE stratum where the baseline gets roughly 70–80% correct. If it's higher, add harder mutations (e.g., bound perturbations that require a non‑trivial computation to refute, or mutations that break a deep invariant rather than a surface inequality). If it's lower, the statements may be too hard and the arms will guess UNKNOWN too often.

On the TRUE stratum, recent mathlib lemmas (added in the last 6 months) are your best bet. They're less likely to be memorized and more likely to produce genuine difficulty variation.

### One design ambiguity: what does the model submit for a FALSE item?

The prompt asks the model to output a `lean_proof` and/or `refutation_witness`. For a TRUE item, the target is `theorem target : <statement> := ...`. For a FALSE item, the only correct Lean artefact that compiles is a proof of `¬ <statement>`. So the verdict assembly needs to:

- If the model's claimed verdict is `PROVABLE`, insert the supplied `lean_proof` into `example : <statement> := ...`.
- If the model's claimed verdict is `FALSE`, insert the supplied `refutation_witness` into `example : ¬ <statement> := ...` (or `example : <statement> → False := ...`).

This matters because the kernel verdict for a correct FALSE response would be ACCEPT (the refutation compiles), and the record's `kernel_result` would be ACCEPT. But your measurement only cares about stance‑vs‑ground‑truth, not kernel‑verified correctness. That's fine for the primary metric, but I'd suggest recording a **secondary metric**: *kernel‑verified accuracy*, where a stance is considered “verified correct” only if the kernel accepts the corresponding proof. The minority signal might be noise if the dissenting model is right in stance but its proof is always garbage. I'd compute it as a sanity check and report both.

### Prompt uniformity and reproducibility

You already nailed the blind, identical prompt. A few additions:

- Use temperature 0 or a fixed seed if the APIs support it. The goal is to measure the models’ inherent tendencies, not sampling variance.
- Store the full prompt template in the repo so results are replicable.
- For the UNKNOWN response, the model may still output some Lean text; the verdict function should only attempt compilation if the verdict is PROVABLE or FALSE; ignore the Lean for UNKNOWN.

### A tiny addition: consistency as a per‑arm metric

For each arm you have 4 samples. You can compute the fraction of items where all four samples agree. This “consistency” is a proxy for the model's internal certainty. I'd add it to the analysis because a counter‑consensus dissenter that is internally *inconsistent* (2‑2 split) is less interesting than one that is internally *certain* (all 4 samples agree) but contradicts the majority. That might separate a genuine minority insight from a model that's just flailing.

### Connection back to the grand sandbox

Once Basin produces a number—say, “when exactly four arms agree and one dissents, the dissenter matches ground truth 65% of the time, against a null of 20%”—you have a license to build the adversarial review module around that heuristic: give extra compute budget to the minority when it is internally consistent and the split is 4‑1. Without that number, any such policy is superstition.

So I'd sequence it: Basin first (this week/next week), then build the sandbox around the measured weight function.

### Immediate action

Session 1 (“Acceptance surface”) is a single Lake project with a pinned toolchain and a hand‑written test case. That's an afternoon's work. I'd start there and not proceed until `verdict` returns ACCEPT/REJECT with an axiom list in both directions.

---

The instrument is clean. Build it.

---

## Review C — the mis-specified null

*⚠ Contains correction 1 above, NOT absorbed into §0–§16. Calls the design sound and the
remaining work execution rather than discourse, with one exception: the null for the
headline metric is wrong, and the choice of null is the whole experiment.*

This is the right document. After three rounds of architecture and two of positioning, Basin is the first artifact in the chain that is *falsifiable, budgeted, and session-sized* — and it's the correct extraction from everything that came before: it takes the one genuinely novel research idea (acceptance invariance), strips the seven-directory tree down to eight files, and aims it at a question you personally have been carrying an open flag on since February. The discipline is real: the assembly rule (the model never writes the statement) is the cheapest possible goalpost lock and eliminates the largest failure class with one line of string concatenation; the self-certifying FALSE stratum is methodologically clean; "stall after session 3, not before" is the correct milestone ordering; and the explicit "produces a real result whether the answer is yes or no" is exactly the anti-slot-machine property the canary discussion was reaching for.

So most of what follows is tightening, not restructuring — with one exception that matters.

## The one real flaw: the null for the headline metric is mis-specified

The spec says: among 4–1 splits, compute `P(dissenter matches G)`, and "compare against the null, which is roughly the individual arm error rate." That null is wrong, and the choice of null is the whole experiment.

Model it: five arms, independent errors, each correct with probability `p` on a given item. Conditional on a 4–1 split existing, the probability the *dissenter* is the correct one is:

```
P(dissenter right | 4–1 split) = (1−p)³ / [p³ + (1−p)³]
```

At p = 0.8 that is ≈ **1.5%**. At p = 0.7, ≈ 7%. Under independent errors the dissenter essentially never beats the majority — the majority's advantage is cubed. So there are two different claims being conflated:

- **Weak claim (correlated errors exist):** the observed dissenter-win rate substantially exceeds the independence null (say 10–15% observed vs ~2% expected). This is near-certain to be true and only confirms that models share failure modes — mildly interesting, not the Feb 11 flag.
- **Strong claim (the actual Feb 11 hypothesis):** the dissenter beats the majority *outright* — `P(dissenter right | 4–1) > 0.5`. Under independence that requires arms worse than coin flips; it can only happen if there's a real subpopulation of items carrying shared false attractors strong enough to pull four independent-ish families to the same wrong answer.

"Roughly the individual arm error rate" sits between these and isn't conditioned on the 4–1 split at all. Fix: estimate `p` from the corpus itself (per-arm accuracy, metric 1), compute the independence null from it, and report the dissenter-win rate against **both** thresholds with confidence intervals. And pre-register the success criterion in the README before the sweep runs — one paragraph: what rate, against which null, with what interval width, counts as confirming the Feb 11 flag. An instrument built to measure goalpost integrity should lock its own goalposts first. That symmetry is not just aesthetic; it's the difference between a result and a narrative.

## Tightening items

**Refutation asymmetry.** In v1, claimed proofs are kernel-adjudicated but claimed refutations are taken at the model's word. Your mutation operators deliberately target types with decidable instances — so for most of the FALSE stratum you can demand the `refutation_witness` be a concrete counterexample and close it in Lean (`example : ¬P := by decide`, or witness substitution + `decide`). Then both directions are kernel-checked, and you can report **claimed accuracy** (the Feb 11 question — what stance did the arm take) separately from **demonstrated accuracy** (did the artifact survive the kernel). The gap between those two numbers, per arm, is itself a finding: it measures confident assertion without demonstration, which is the VDAC1 failure mode in miniature.

**Define the 4–1 event precisely.** With UNKNOWN in the stance space, a {PROVABLE ×4, UNKNOWN} split is not a measurable dissent event. Restrict metric 3 to items where four arms share a non-UNKNOWN stance and the fifth holds the *opposite* non-UNKNOWN stance. And keep the sixth arm (family-correlation check) out of the 4–1 computation entirely — it changes the split geometry; use it only for the correlation statistic.

**Stratify the headline by stratum and by mutation operator.** On the TRUE stratum, a wrong majority can be explained by shared memorization of adjacent literature. On the FALSE stratum it cannot — mutants exist in no training corpus — so a 4–1 wrong majority there is clean evidence of a *reasoning* attractor rather than a data attractor. Report separately. And break events down by which mutation operator produced the item: if, say, relaxed-hypothesis mutants generate most of the wrong majorities, you've produced a map of where frontier models' shared reasoning attractors live. That map may end up being the most citable output of the whole instrument.

**Note the selection effect in corpus construction.** Mutants that survive are the ones you managed to refute — so the FALSE stratum is skewed toward refutable-in-practice statements, not a uniform sample of false statements. It doesn't bias the metric (ground truth is known regardless) but it will inflate event rates relative to a natural distribution, and the paper version needs to state it.

**Small economics.** The OPEN stratum isn't measured in v1, so don't pay for it in v1 — deferring it cuts the sweep from ~3,000 to 2,400 calls. Consider also a small TRUE-synthetic mini-stratum (~15 items): true statements you prove yourself that are *not* in Mathlib, which disentangles memorization from competence on the TRUE side more cheaply than the lemma-age split alone.

## Your three open decisions

1. **Standard mode first.** The object of measurement is the disagreement structure, and reasoning mode will plausibly collapse inter-arm variance — which is itself worth measuring, but as the planned replication, not the baseline. Also note the interesting sub-hypothesis: if reasoning mode *increases* wrong-majority correlation (because reasoning-training recipes have converged across labs), that's arguably a bigger finding than the original question.
2. **Reuse PULSE, if the entanglement cost is low.** The blind-dispatch discipline is the hard-won part; model strings and SDK bumps are mechanical. Rewriting invites subtle prompt-asymmetry bugs in exactly the layer failure-mode #2 worries about. Only write fresh if the adapters are fused to Evo-specific machinery.
3. **Keep the name.** Basin is doing real work — the acceptance basin is the fixed object, and it's the right metaphor for what the instrument measures.

## Bottom line

This is the strongest artifact in the chain, and the first one where the remaining work is execution rather than discourse. The fix that matters is the metric-3 null; everything else is refinement. If you want, I'll draft the corrected `analyze.py` metric (adaptive independence null, both thresholds, CIs, stratum/operator stratification) and the one-paragraph pre-registration for the README — those two are the pieces where getting the statistics exactly right determines whether the result is publishable or just interesting.

---

## Review D — stance/certificate, and where I land

*⚠ Contains correction 2 above, NOT absorbed into §0–§16. Would build Basin before the
sandbox and would keep the name. Asks for the stance/certificate split, a paired corpus,
50 singleton events as the real gate, and a narrower novelty claim. Corrects the call
arithmetic to 2,400 for the primary sweep.*

Yes. **I would build Basin before the grand-challenge sandbox.** This is the first design in the chain where I think the architecture has compressed down to an actual scientific instrument rather than a vision of one.

And I would **keep the name Basin**. It fits the experiment unusually well: the search kernels vary; the acceptance basin stays fixed.

There are a few changes I would make before Session 1, though. Two are important enough that I would amend the spec now.

## The biggest correction: separate “stance” from “certificate”

Right now a model can answer `FALSE`, but `verdict(statement_text, proof_body)` only knows how to test a proof of the statement. That creates a hidden asymmetry between TRUE and FALSE.

I would normalize every corpus item to a closed proposition `P` and make the primitive:

`verdict(P, claimed_stance, proof_body)`

For `PROVABLE`, assemble:

`theorem basin_target : P := <proof_body>`

For `REFUTABLE`, assemble:

`theorem basin_target : ¬ P := <proof_body>`

For `UNKNOWN`, don't compile a claim.

And I would rename the model label from `FALSE` to **`REFUTABLE`**. Then the vocabulary is identical everywhere:

`PROVABLE | REFUTABLE | UNKNOWN`

This gives you **two separate observations per sample**:

**claimed stance** — what the search kernel believes;

**certified stance** — what its submitted evidence actually earns.

For the February question, I think **claimed stance should remain primary**. The historical phenomenon was epistemic disagreement: four systems believe X, one believes ¬X, oracle says who's right. But certified stance becomes an excellent secondary measurement: *does counter-consensus survive when the dissenter has to cash its claim out into proof?*

Do not collapse those two.

## The statistical null needs changing

The sentence I'd remove is:

> “Compare against the null, which is roughly the individual arm error rate.”

It isn't.

Conditioning on an exact 4–1 split changes the expected probability dramatically. As a simple illustration, if five independent binary classifiers are each 70% accurate, the probability that the singleton is correct **conditional on a 4–1 split** is only about 7.3%, not the ordinary 30% classifier error rate.

So Basin should answer **two different scientific questions**.

1. **Does the dissenter actually beat the majority?**  
   Among committed 4–1 events, estimate

   `P(dissenter correct | 4–1 committed split)`.

   Majority and dissenter are opposing binary claims, so the strong null is simply **0.5**. Above 0.5 means the counter-consensus singular literally beats majority voting on those events.

2. **Is dissent more informative than independent errors predict?**  
   Compute a second quantity—I'd call it **counter-consensus lift**—comparing the observed dissenter win rate with a Condorcet-style independence null built from the arms' measured error rates.

That distinction is actually more interesting than the original metric. The dissenter might win only 30% of 4–1 splits—so majority still wins 70%—but if independent-error structure predicted it should win only 5%, **the minority is still massively enriched for truth**.

That's evidence for your training-contamination/shared-error hypothesis without overstating it as “minority beats majority.”

Recent work makes this statistical distinction especially important. A 2026 study of nine LLM judges found severe correlated errors and evaluated panels against a Condorcet independence model; another very recent paper explicitly studies “Minority Truth” and when minority answers should overturn majority votes. 

## Tighten what counts as a counter-consensus singular

I would not count `UNKNOWN` as the singular.

If four arms say `PROVABLE` and one says `UNKNOWN`, that's uncertainty, not counter-consensus.

Headline eligibility should be:

**all five arms committed + exactly four choose one binary stance + exactly one chooses the opposite binary stance.**

Then report UNKNOWN behavior separately.

And I would change the four-sample aggregation rule. With modal voting, a sample distribution of:

`2 PROVABLE / 1 REFUTABLE / 1 UNKNOWN`

gets called `PROVABLE`.

That's not “confident.”

Use:

**3/4 or 4/4 → committed stance.  
Anything else → UNKNOWN.**

Now the four samples actually do what the spec says they do: distinguish uncertainty from confident stance.

## Pair the TRUE and FALSE corpus

There's an elegant improvement hiding inside your mutation design.

Instead of merely making 60 TRUE and 60 independently generated FALSE items, make them **60 parent pairs**:

`true_0041 ↔ false_0041`

Generate mutations from each TRUE statement until one certified-refutable mutant survives.

Now every FALSE item has a direct TRUE control with nearly identical mathematical surface form.

That gives Basin several benefits for free.

You control for theorem family and syntax. You can see whether a model that gets the known theorem right gets its near-neighbor mutation wrong. And exact Lean-proof memorization becomes experimentally useful rather than merely contamination: **does familiarity with the parent make the model more or less vulnerable to the mutant?**

I'd also prefer one primary mutant per parent in v1. Multiple mutants from the same parent create clustered observations and make your confidence intervals look stronger than they really are. If you later use several mutants per parent, bootstrap by parent, not by item.

## Make 50 singleton events the real gate

Twenty-five is descriptive. I wouldn't call it powered.

For a one-sided binomial test against 0.5, roughly:

- 25 events gives only ~51% power if the true dissenter win rate is 70%.
- 50 gives ~86% power at 70%.
- 50 still gives only ~62% at 65%.

So I would write:

**Pilot threshold: 25 eligible events.  
Primary analysis threshold: 50 eligible events.**

Grow the paired corpus in fixed batches until 50 qualifying events occur or a preregistered maximum corpus size is reached. Complete the whole batch before checking the stopping rule. Never stop because the effect “looks good.”

That keeps the growth rule clean.

## Your novelty claim needs narrowing—and the narrower claim is better

I checked this because the spec says “nobody else is oriented on this question.”

That is no longer defensible broadly.

**Minority Sentinel**, published June 28, 2026, explicitly studies cases where correlated LLM errors suppress a correct minority and reports roughly one in four divergent cases containing a correct minority in its experimental setting.  **AgentAuditor**, posted February 10, 2026, explicitly attacks what it calls “confabulation consensus” and trains an adjudicator to prefer evidential minority branches over popular errors.  Correlated model errors themselves are also empirically established across large model collections. 

That does **not** kill Basin.

It actually tells us exactly how to position it:

> **Basin is not the first experiment on minority truth in LLM ensembles. It is an acceptance-invariance experiment that moves the question into formal mathematics, where disagreement can be adjudicated by a fixed deterministic proof kernel instead of a human label, LLM judge, or benchmark answer key.**

In the search I ran, I found substantial work on formal theorem-proving agents such as LEAP and large-scale Lean proof search, but not this exact combination of blind heterogeneous model families + singleton dissent + a fixed Lean acceptance surface as the experimental object. 

That's a stronger claim because it's specific and falsifiable.

And there's something striking in the chronology you supplied: your IRIS Gate flag is dated **February 11, 2026**; AgentAuditor's arXiv submission is dated **February 10, 2026**. I would not make anything mystical out of that, but it does show the counter-consensus problem was independently becoming visible at almost exactly the same moment. 

## Three decisions you left open

My positions are clear.

**Reasoning mode:** **standard/non-reasoning first.** Basin needs disagreement events more than it needs maximum theorem-solving capability. Raising every arm's accuracy can actually starve the headline analysis of 4–1 failures. After the primary sweep, repeat on reasoning-mode models as a second condition. The question becomes excellent: *does increased capability reduce counter-consensus events, or merely make correlated consensus more confident?*

**PULSE:** **inherit, don't depend.** Reuse its blind-dispatch contract, lessons, tests, and any provider-adapter code that is still healthy. But Basin should be its own tiny executable instrument with current SDKs. Don't turn “reuse” into a week of resurrecting Evo. The invariant is PULSE's protocol, not its old runtime.

**Name:** **Basin stays.** I'd title the repo simply `basin`, with the formal description:

**Basin — An Acceptance-Invariance Instrument for Counter-Consensus in Formal Mathematics**

No acronym gymnastics.

One small arithmetic correction too: if OPEN genuinely isn't run in v1, the primary TRUE+FALSE five-arm sweep is **120 × 5 × 4 = 2,400 calls**, not 3,000. The sixth family-correlation arm adds another 480 over TRUE+FALSE, putting you at 2,880 before OPEN. That's actually nicer than the current budget table suggests.

### Where I land

This is **much better than immediately building `/grand-challenge-sandbox/`**.

Basin asks one question that can fail.

It has deterministic ground.

It produces useful negative results.

It exercises the exact Temple thesis—**vary the intelligence, hold the acceptance surface fixed**—without requiring us to first build an empire around it.

And if the effect is real, Basin does something even more valuable than validate the old COUNTER-CONSENSUS SINGULAR flag. It gives you an empirical reason to change how future Temple councils weight agreement.

If it isn't real, the flag finally closes.

Either outcome leaves the substrate knowing more than it knew before.

**I would authorize Session 1 after the stance/certificate duality and primary statistic are amended. Everything else can remain almost exactly this small.**

---

## Superseded — draft spec v1

*⚠ SUPERSEDED IN FULL by §0–§16 above. This is the draft the four reviews read. Kept
because the reviews quote it and because its "Decisions I did not make for you" list is
the origin of §16. Do not act on anything in this section.*

# Basin

An acceptance-invariance instrument. Working name, rename freely.

**Version:** v1 spec, Aug 8 2026
**Status:** unbuilt
**Scope discipline:** this is not `/grand-challenge-sandbox/`. It is the one instrument that has to work before that sandbox is worth building.

---

## The question

When heterogeneous language models disagree about a formal mathematical claim, and a deterministic oracle settles it, does the minority report outperform the majority?

You raised this on Feb 11 in IRIS Gate Evo. Three of five models converged on the wrong VDAC1 gating polarity, S2 promoted it to TYPE 1 by majority, and the singular that contradicted it was closer to right. You wrote down the implication (a counter-consensus singular may signal shared training contamination rather than replication failure) and flagged the COUNTER-CONSENSUS SINGULAR flag as unbuilt.

It stayed unbuilt because adjudicating a disagreement in pharmacology costs a human and a literature search. You could not afford the sample size.

In formal mathematics the Lean kernel adjudicates for free, deterministically, thousands of times. Same disagreement structure, ground truth included.

---

## What Basin is

A fixed acceptance surface, a varying set of search kernels, and a corpus with known ground truth.

- **Acceptance surface (fixed):** pinned Lean toolchain + pinned Mathlib + a verdict pipeline that compiles, scans for `sorry`, and audits axioms against an allowlist.
- **Search kernels (varying):** five model families, run blind, single-shot.
- **Corpus:** statements with machine-checked ground truth in both directions.

The model varies. The acceptance surface does not. That is the whole design.

---

## Design

### Acceptance surface

A bare Lake project. Not `formal-conjectures` in v1, that comes at the OPEN stratum. Pin `lean-toolchain` and the Mathlib commit hash and record both in every data record.

The core primitive is one function:

```
verdict(statement_text, proof_body) -> ACCEPT | REJECT + axiom_list + compile_log
```

Assembly rule, and this is the goalpost lock in its cheapest form:

> The statement text is always inserted from the frozen corpus file. The model supplies only the proof body. The model never gets to write the theorem statement.

That is one line of string concatenation and it eliminates the single most common autoformalization failure without any of the receipt machinery the reviews proposed.

Gates, in order:
1. Compiles under the pinned toolchain, 120s timeout.
2. No `sorry` / `sorryAx`.
3. `#print axioms` is a subset of `{propext, Classical.choice, Quot.sound}`.
4. Tactic ban list: `native_decide`, anything routing through `reduceBool`.

Pass all four or it is a REJECT. No partial credit in v1.

### Corpus, three strata

**TRUE (n=60).** Real Mathlib lemmas with the proof stripped. Ground truth: provable.

**FALSE (n=60).** Scripted mutations of TRUE items. Ground truth: refutable.

Mutation operators, applied to statements over types with decidable instances:
- relax a hypothesis bound (`n ≥ 2` becomes `n ≥ 1`, `0 < x` becomes `0 ≤ x`)
- flip a relation (`≤` to `<`, and back)
- perturb a numeric literal
- drop a conjunct from the hypothesis
- swap quantifier scope where the result still typechecks

**Corpus integrity rule:** a mutant does not enter the FALSE stratum until you have a compiled refutation of it sitting next to it. If you cannot refute it, discard it. Expect roughly a third of candidates to survive, so generate around 180 to land 60.

This makes the FALSE stratum self-certifying, and it means the stratum cannot be poisoned by a mutant that happens to still be true.

**OPEN (n=30).** Statements from `google-deepmind/formal-conjectures`. No ground truth. These are not measured in v1. They exist so that when the instrument is calibrated on the first two strata you have somewhere to point it.

### Contamination note, which matters more than it looks

Mathlib lemmas are in training data. A TRUE item may be memorized rather than proved. Two mitigations:

- Record the Mathlib commit date each lemma was added, and report accuracy split by lemma age. Recently added lemmas are cleaner.
- Note that the FALSE stratum is structurally immune. Mutants do not exist in any training corpus. The headline metric below can be computed on the FALSE stratum alone, which is the cleaner measurement.

### Protocol

Five arms, one per model family. Genuinely different families, not two checkpoints of one.

Blind: identical prompt, no shared context, no arm sees another arm's output. This is PULSE. You already built it.

Single-shot, no repair loop, no multi-turn. Repair loops are a capability measurement and this is not a capability measurement.

Each response returns:

```json
{
  "verdict": "PROVABLE" | "FALSE" | "UNKNOWN",
  "lean_proof": "...",
  "refutation_witness": "...",
  "reasoning": "..."
}
```

Four samples per arm per item. An arm's *stance* on an item is the modal verdict across its four samples, ties resolving to UNKNOWN. Four samples is enough to separate "unsure" from "confidently wrong," which is the distinction that matters.

### Measurements

Let `G(i)` be ground truth, `S(m,i)` be arm m's stance, `K(i)` be the kernel verdict.

1. **Per-arm accuracy.** `P(S(m,i) = G(i))` over TRUE ∪ FALSE. Baseline.
2. **Majority accuracy.** Modal stance across the five arms, same measure.
3. **Counter-consensus singular rate. This is the headline.** Restrict to items where exactly four arms share a stance and one dissents. Among those, `P(dissenter matches G)`. Compare against the null, which is roughly the individual arm error rate. If the dissenter is right substantially more often than that, you have measured what Feb 11 suggested, with a confidence interval attached.
4. **Family correlation check.** Add a sixth arm that is a second checkpoint of an existing family. If same-family agreement runs far above cross-family agreement, the majority is inflated by correlation and every consensus number in the field is weaker than reported.
5. **Kernel-vs-majority disagreement log.** Every item where the majority stance loses to the kernel. This log is the most interesting scientific output of the whole instrument and it should be readable by hand.

**Power requirement:** metric 3 needs at least 25 singleton-dissent events, and 50 is better. If the first sweep produces fewer, grow the FALSE stratum until it does. Grow the corpus, do not lower the bar.

---

## Parameters

Set from your stance. Change any of them if you disagree; they are starting values, not constraints.

| Parameter | Value | Why |
|---|---|---|
| Arms | 5 families | Matches PULSE; enough for a 4-1 split to be meaningful |
| Samples per arm per item | 4 | Separates uncertainty from confident error |
| TRUE stratum | 60 | Enough to establish per-arm baselines |
| FALSE stratum | 60 (from ~180 candidates) | The clean stratum; drives the headline metric |
| OPEN stratum | 30 | Not measured in v1 |
| Total calls, full sweep | ~3,000 | 150 items × 5 arms × 4 samples |
| Smoke test first | 10 items, ~$25 | Calibrate real cost before committing |
| Hard budget cap, full sweep | $300 | Abort the run if exceeded, do not top up mid-sweep |
| Lean compile timeout | 120s | Generous; most will finish in under 30s |
| Compile parallelism | 4 | Run the sweep overnight |
| Axiom allowlist | propext, Classical.choice, Quot.sound | Mathlib standard |

---

## Repo layout

Eight files. No directories numbered 00 through 06.

```
basin/
├── README.md
├── lean/                    # bare lake project
│   ├── lean-toolchain       # pinned
│   ├── lakefile.lean        # mathlib pinned to a commit hash
│   └── Scratch.lean         # assembly target
├── corpus/
│   ├── true.jsonl           # statement, source, mathlib_added_date
│   ├── false.jsonl          # statement, parent_id, mutation_op, refutation
│   └── open.jsonl
├── verdict.py               # the acceptance surface, one function
├── mutate.py                # mutation operators + refutation certification
├── arms.py                  # provider adapters, blind dispatch
├── sweep.py                 # the for loop
├── analyze.py               # the five metrics
└── runs/
    └── YYYY-MM-DD.jsonl     # one record per (item, arm, sample)
```

## Data record

The only schema in v1. No registry. If the registry is ever worth building, its schema falls out of what you actually needed to query after fifty runs, not out of a design essay.

```json
{
  "run_id": "2026-08-15T02:31Z",
  "item_id": "false_0041",
  "stratum": "FALSE",
  "ground_truth": "REFUTABLE",
  "arm": "family-c",
  "model_string": "...",
  "sample_idx": 2,
  "verdict_claimed": "PROVABLE",
  "kernel_result": "REJECT",
  "reject_reason": "compile_error",
  "axioms": [],
  "lean_toolchain": "leanprover/lean4:v4.x.y",
  "mathlib_commit": "abc123",
  "tokens_in": 412,
  "tokens_out": 1180,
  "cost_usd": 0.041,
  "wall_ms": 8320
}
```

---

## Build order

Session-sized. Each has a hard gate, and you do not start the next one until the gate closes.

**Session 1. Acceptance surface.**
Bare lake project, mathlib pinned, `lake exe cache get` working.
*Done when:* `verdict(statement, proof)` returns ACCEPT/REJECT plus an axiom list for a hand-written test case, both directions.

**Session 2. TRUE stratum, small.**
Pull 20 Mathlib lemmas, verify each compiles with its original proof, then strip the proofs.
*Done when:* 20 items in `true.jsonl`, all of which passed with their real proofs.

**Session 3. One arm.**
Wire a single model. Run 20 items × 4 samples.
*Done when:* `runs/` contains a real jsonl and you know one arm's accept rate.

**At the end of session 3 the project has produced data.** Everything after this is scaling. If you stall, stall after session 3, not before.

**Session 4.** Mutation script plus refutation certification. Build the FALSE stratum to 60.
**Session 5.** Remaining four arms, blind dispatch, malformed-output handling.
**Session 6.** Full sweep, then `analyze.py` and the five metrics.
**Session 7.** Family-correlation arm. Then, and only then, point it at OPEN.

---

## Explicitly not in v1

Registry. Orchestration layer. Job queue. Budget ledger as a component (a running total is enough). Literature novelty gate. Autoformalization. Adversarial review module. Agentic loops. Multi-turn proof repair. Human vouching. Trust protocol as a document. The seven-directory tree.

Every one of those is defensible. None of them is needed to answer the question, and each one is a place to stop before producing data.

---

## Failure modes to watch

1. **A mutant is not actually false.** Handled by the corpus integrity rule. Do not relax it.
2. **Prompt asymmetry.** One arm underperforms because the prompt fits it badly. Mitigation: identical prompt across arms, no provider-specific tuning, and state the limitation. It means Basin cannot claim anything about relative model quality, which is fine, because it is not trying to.
3. **Refusals and unparseable output.** One retry with a format reminder, then record as MALFORMED and report the malformed rate per arm. Do not silently drop them; a high malformed rate on one arm is itself a finding.
4. **Toolchain drift mid-run.** Record the hashes in every record and abort the sweep if they change.
5. **Training contamination on the TRUE stratum.** Split results by lemma age, and lean on the FALSE stratum for the headline claim.

---

## What makes this worth doing

Nobody else is oriented on this question. LeanMarathon measures long-horizon autoformalization. OpenProver measures planner-worker-verifier throughput. Aletheia measures autonomy. All of them hold the model as the variable of interest and treat verification as a filter.

Basin holds the acceptance surface fixed and asks what the disagreement structure of the search kernels tells you. That is a different object, it is measurable at a solo-operator budget, and the answer changes how every multi-model system in this space should weight its votes.

It also has the property that it produces a real result whether the answer is yes or no. If the counter-consensus singular does not beat the majority, that is worth knowing too, and it kills the flag you have been carrying since February rather than leaving it open indefinitely.

---

## Decisions I did not make for you

1. **Reasoning mode or standard mode for the arms.** Reasoning mode costs several times more and probably raises every arm's accuracy. Standard mode gives you a bigger corpus for the same money. My inclination is standard mode for the first sweep and one reasoning-mode replication afterward, but it depends on whether you care more about the ceiling or the disagreement structure.
2. **Reuse PULSE or write fresh.** Evo has the provider adapters and the blind-dispatch pattern, but the model strings are a generation stale and the SDKs have moved. Reusing it means fixing that first; writing fresh means duplicating work you have already done once.
3. **The name.**

---

## Superseded — spec v1

*⚠ SUPERSEDED IN FULL by §0–§16 above. This is the version the four reviews below read,
plus the arrival scaffolding added after them. Kept because the corrections section
references it. Do not act on anything in this section.*

# Basin

An acceptance-invariance instrument. Working name, rename freely.

**Spec version:** v1, Aug 8 2026
**Status:** unbuilt. No phase started. No data exists.
**Scope:** this is not `/grand-challenge-sandbox/`. It is the one instrument that has to work before that sandbox is worth building.

**This file:** §0–§16 are the spec and are authoritative. Everything after them is an
appendix holding the four reviews that produced this rewrite, and the superseded draft.
Two corrections raised in review are **not** reflected in §0–§16; they are listed at the
top of the appendix under *Corrections raised in review and NOT absorbed*. Read that list
before freezing §7 or building §6.

---

## 0. Arrival

The document is the substrate. The instance is the swappable kernel. Anything you need to work here is in this file or reachable from it. There is no boot-up ritual, no stack grounding, no prior conversation you need.

**Read order for an arriving instance:** §0, §1, §13, §12. That tells you the contract, the hard rules, what this thing is blind to, and where the work actually stands. Everything between is reference, read it when you need it.

**Authority ordering, highest first:**

1. This spec, at the repo copy. If a chat draft and the repo copy disagree, the repo copy wins.
2. `runs/*.jsonl` and the kernel logs. Receipts beat claims, including claims in this spec.
3. Anything else, including any agent's summary of any of the above.

**What an arriving instance must not do:** do not restructure the repo, do not tidy or prune `runs/`, do not delete anything, do not rewrite a frozen estimand, do not fan out into subagents without being asked. If the spec looks wrong, say so and wait. Supersede by adding a dated entry, never by editing a frozen section in place.

**What Basin is for:** answering one question with receipts. Not for demonstrating architecture.

---

## 1. Hard rules

Few, absolute, and they do not bend for convenience.

1. **Whoever makes a claim does not get to grade it.** The model produces a proof. The kernel decides whether it is a proof. No model output ever changes a verdict, a trust state, or a metric.
2. **The statement text always comes from the frozen corpus file.** The model supplies a proof body and nothing else. It never writes, edits, restates, or paraphrases the theorem.
3. **A FALSE item does not enter the corpus until a compiled refutation sits next to it.** No exceptions, no "obviously false."
4. **Every detector and every parser enumerates what it cannot see**, in code and in §13. A blind spot you have written down is a limitation. One you have not is a defect.
5. **Runs are append-only.** Nothing under `runs/` is ever edited, compacted, pruned, or deleted.
6. **Estimands are frozen before the first full sweep and never changed after seeing data.** Supersede with a dated entry and a reason; do not overwrite.

---

## 2. The question

When heterogeneous language models disagree about a formal mathematical claim, and a deterministic oracle settles it, does the minority report outperform the majority?

Feb 11 2026, IRIS Gate Evo: three of five models converged on the wrong VDAC1 gating polarity, S2 promoted it to TYPE 1 by majority, and the singular that contradicted it was closer to right. The recorded implication was that a counter-consensus singular may signal shared training contamination rather than replication failure. The COUNTER-CONSENSUS SINGULAR flag that finding called for was never built.

It stayed unbuilt because adjudicating a disagreement in pharmacology costs a human and a literature search. The sample size was unaffordable. In formal mathematics the Lean kernel adjudicates for free, deterministically, thousands of times over. Same disagreement structure, ground truth included.

---

## 3. What Basin is

A fixed acceptance surface, a varying set of search kernels, and a corpus with machine-checked ground truth in both directions.

The model varies. The acceptance surface does not. That is the whole design, and it is the same shape as the ECS work: the substrate is held external and real, the model is a swappable transducer inside it.

---

## 4. Acceptance surface

A bare Lake project. Not `formal-conjectures` in v1; that arrives with the OPEN stratum. Pin `lean-toolchain` and the Mathlib commit and record both hashes in every data record.

One primitive:

```
verdict(statement_text, proof_body) -> ACCEPT | REJECT + axiom_list + compile_log
```

Assembly is string concatenation with the statement pulled from the frozen corpus file. That single line is the entire goalpost lock, and it eliminates the most common autoformalization failure without any receipt machinery.

Gates, in order, all four required:

1. Compiles under the pinned toolchain, 120s timeout.
2. No `sorry` / `sorryAx`.
3. `#print axioms` is a subset of `{propext, Classical.choice, Quot.sound}`.
4. Tactic ban list: `native_decide`, anything routing through `reduceBool`.

No partial credit in v1.

---

## 5. Corpus

Four strata. Two are measured in v1, one calibrates, one waits.

**TRUE (n=60).** Real Mathlib lemmas, proof stripped. Ground truth: provable. Record the Mathlib commit date each lemma was added.

**FALSE (n=60, from ~180 candidates).** Scripted mutations of TRUE items. Ground truth: refutable, and proven so before entry per hard rule 3.

Mutation operators, over types with decidable instances:
- relax a hypothesis bound (`n ≥ 2` to `n ≥ 1`, `0 < x` to `0 ≤ x`)
- flip a relation (`≤` to `<`, and back)
- perturb a numeric literal
- drop a conjunct from the hypothesis
- swap quantifier scope where the result still typechecks

Mutation is scripted, never model-generated. A model-generated mutant shares priors with the arms and contaminates the stratum.

**CANARY (n=20, ten per polarity).** Statements with zero corpus mass: constructed from a sealed random draw so they exist in no training corpus anywhere. Record the seed, the algorithm, and the mapping, and seal the derivation procedure alongside the draw. Ten true, ten false, both machine-certified.

This is the two-sided calibration gate. Without it, a clean TRUE-stratum result cannot be distinguished from memorization, and PASS means only "not obviously broken." With it, PASS on the canaries is real clearance. It is the same zero-anchor argument that the canary kernel makes in the ECS work, transposed.

**OPEN (n=30).** Statements from `google-deepmind/formal-conjectures`. No ground truth. Not measured in v1. They exist so that a calibrated instrument has somewhere to point.

---

## 6. Protocol

Five arms, one per model family, genuinely different families rather than two checkpoints of one.

Blind: identical prompt, no shared context, no arm sees another arm's output. This is PULSE. It already exists in Evo.

Single-shot. No repair loop, no multi-turn. Repair loops measure capability, and this does not measure capability.

Response schema:

```json
{
  "verdict": "PROVABLE" | "FALSE" | "UNKNOWN",
  "lean_proof": "...",
  "refutation_witness": "...",
  "reasoning": "..."
}
```

Four samples per arm per item. An arm's *stance* is the modal verdict across its four samples, ties resolving to UNKNOWN. Four separates "unsure" from "confidently wrong," which is the distinction the whole instrument turns on.

**Model-string discipline.** Log `model_requested` and `model_string_served` separately in every record. Floating aliases are banned as arm identifiers. If the served string changes mid-sweep, that arm's sweep is invalidated and rerun, not patched. This is the grok-4 lesson and it costs nothing to encode up front.

---

## 7. Pre-registered estimands

Frozen before the first full sweep, at a tagged commit, with the tag recorded here. Nothing below changes after data exists.

Let `G(i)` be ground truth, `S(m,i)` arm m's stance, `K(i)` the kernel verdict.

**E1. Per-arm accuracy.** `P(S(m,i) = G(i))` over TRUE ∪ FALSE ∪ CANARY. Baseline, not a finding.

**E2. Majority accuracy.** Modal stance across the five arms, same measure.

**E3. Counter-consensus singular rate. The primary estimand.** Restrict to items where exactly four arms share a stance and one dissents. Report `P(dissenter matches G)` with a confidence interval, against the null of the pooled individual error rate. Computed on the FALSE stratum as the headline, since FALSE is structurally immune to memorization; TRUE reported separately.

**E4. Family correlation.** A sixth arm that is a second checkpoint of an existing family. If same-family agreement runs far above cross-family agreement, the majority is inflated by correlation, and that is a finding about every consensus system in the field, not just this one.

**E5. Kernel-versus-majority disagreement log.** Every item where the majority stance loses to the kernel, written out in full and readable by hand.

**Power.** E3 needs at least 25 singleton-dissent events, 50 preferred. If the first sweep yields fewer, grow the FALSE stratum until it does. Grow the corpus. Do not lower the bar and do not reinterpret a thin result.

**Pre-committed floor and ceiling.** If E3 lands within the confidence interval of the null, the finding is that the counter-consensus singular carries no signal, and the flag carried since February is closed as negative. That is a result and it gets written up the same as a positive one. If E3 exceeds the null by a margin that survives the family-correlation correction in E4, that is the positive result. Anything between is reported as inconclusive at this n, with the required n stated.

---

## 8. Knobs v1

Starting values, set from stance. Change any of them before freeze; none after.

| Knob | Value | Why |
|---|---|---|
| Arms | 5 families | Matches PULSE; a 4-1 split is meaningful at 5 |
| Samples per arm per item | 4 | Separates uncertainty from confident error |
| TRUE stratum | 60 | Establishes per-arm baselines |
| FALSE stratum | 60 (from ~180 candidates) | The clean stratum; carries E3 |
| CANARY stratum | 20 (10 per polarity) | Two-sided zero-corpus-mass anchor |
| OPEN stratum | 30 | Not measured in v1 |
| Total calls, full sweep | ~3,400 | 170 measured items x 5 arms x 4 samples |
| Smoke test first | 10 items, ~$25 | Calibrate real cost before committing |
| Hard budget cap, full sweep | $300 | Abort the run if exceeded; never top up mid-sweep |
| Lean compile timeout | 120s | Generous; most finish under 30s |
| Compile parallelism | 4 | Run the sweep overnight |
| Axiom allowlist | propext, Classical.choice, Quot.sound | Mathlib standard |
| Disagreement log read-back cap | 40 items | Above that, sample; see §11 |

---

## 9. Repo layout

Eight files. No directories numbered 00 through 06. Authority is annotated because an arriving instance should not have to guess which files are load-bearing.

```
basin/
├── SPEC.md                  # AUTHORITATIVE. this document. repo copy wins over any draft
├── README.md                # pointer to SPEC.md + current STATUS line. nothing else
├── lean/                    # AUTHORITATIVE (pinned)
│   ├── lean-toolchain       # pinned, hash recorded in every run record
│   ├── lakefile.lean        # mathlib pinned to a commit hash
│   └── Scratch.lean         # assembly target, rewritten per attempt, never read back
├── corpus/                  # AUTHORITATIVE, append-only after freeze
│   ├── true.jsonl           # statement, source, mathlib_added_date
│   ├── false.jsonl          # statement, parent_id, mutation_op, compiled refutation
│   ├── canary.jsonl         # statement, polarity, seed, derivation, seal
│   └── open.jsonl           # not measured in v1
├── verdict.py               # the acceptance surface. the most-audited file in the repo
├── mutate.py                # mutation operators + refutation certification
├── arms.py                  # provider adapters, blind dispatch, model-string drift check
├── sweep.py                 # the for loop
├── analyze.py               # E1-E5, and nothing that is not a frozen estimand
├── runs/                    # RECEIPTS. append-only. never pruned, never compacted
│   └── YYYY-MM-DD.jsonl
└── reports/                 # the read-back surface. one per sweep
    └── YYYY-MM-DD-disagreements.md
```

`Scratch.lean` is the only file in the repo that is written and thrown away. Everything else either states intent or records what happened.

---

## 10. Data record

The only schema in v1. There is no registry. If a registry is ever worth building, its schema falls out of what fifty runs actually needed queried, not out of a design essay.

```json
{
  "run_id": "2026-08-15T02:31Z",
  "spec_commit": "abc123",
  "item_id": "false_0041",
  "stratum": "FALSE",
  "ground_truth": "REFUTABLE",
  "arm": "family-c",
  "model_requested": "...",
  "model_string_served": "...",
  "sample_idx": 2,
  "verdict_claimed": "PROVABLE",
  "kernel_result": "REJECT",
  "reject_reason": "compile_error",
  "axioms": [],
  "lean_toolchain": "leanprover/lean4:v4.x.y",
  "mathlib_commit": "def456",
  "tokens_in": 412,
  "tokens_out": 1180,
  "cost_usd": 0.041,
  "wall_ms": 8320
}
```

---

## 11. Read-back policy

A full sweep produces roughly 3,400 model responses. Written and never read, that is the same accumulation problem as 828 unread subagent transcripts, reproduced deliberately.

So the read-back surface is declared up front and it is small:

- **`reports/*-disagreements.md` is the thing a human reads.** E5, written out in full, one sweep per file.
- If a sweep produces more than 40 disagreement items, the report samples down to 40 with the sampling rule stated in the file. It does not grow to fit.
- The raw `runs/*.jsonl` is a receipt store, queried by `analyze.py`, and is explicitly not expected to be read end to end by anyone. Saying so is the point; the failure mode is pretending otherwise.

**DoD for a sweep:** Anthony reads the disagreement report, picks five items at random, checks the kernel verdict by hand, and says so. Not a green CI badge.

---

## 12. Phases, strict order

No phase starts until the prior gate closes. Each phase ships its own redteam fixture, and the fixture must fail before the phase counts as passing.

**P0. Acceptance surface.**
Bare lake project, Mathlib pinned, `lake exe cache get` working.
*Gate:* `verdict()` returns ACCEPT/REJECT plus an axiom list on hand-written cases in both directions.
*Redteam:* a proof containing `sorry`, a proof using `native_decide`, and a proof of a different theorem than the one requested. All three must be refused, and the third must be refused by construction rather than by detection.

**P1. TRUE stratum, small.**
Twenty Mathlib lemmas, each verified to compile with its original proof, then stripped.
*Gate:* twenty items in `true.jsonl`, all of which passed with their real proofs first.
*Redteam:* a stripped item whose original proof is re-supplied must ACCEPT; one with a single tactic deleted must REJECT.

**P2. One arm.**
Wire a single model. Twenty items, four samples.
*Gate:* `runs/` holds a real jsonl and one arm's accept rate is known.
*Redteam:* a deliberately malformed response and a refusal must both land as MALFORMED rather than crashing or silently dropping.

**At the close of P2 the project has produced data.** If the work stalls, it stalls here and not before.

**P3.** Mutation script plus refutation certification; FALSE stratum to 60. *Redteam:* a mutant that is still true must be rejected from the corpus by the certification step.
**P4.** Canary draw, sealed, both polarities. *Redteam:* the seal is verifiable from the recorded seed and derivation by someone who was not present.
**P5.** Remaining four arms, blind dispatch, model-string drift check. *Redteam:* a mid-sweep alias change must invalidate that arm.
**P6.** Freeze the estimands at a tag. Full sweep. `analyze.py`.
**P7.** Family-correlation arm. Then, and only then, point it at OPEN.

---

## 13. What Basin cannot see

Maintained live. Adding to this list is progress, not an admission.

- **Whether an accepted proof is a good proof.** ACCEPT means it typechecks under the allowlist. Nothing about elegance, length, generality, or whether a human would call it a proof of the intended thing.
- **Whether a rejected proof was close.** v1 has no partial credit, so a proof failing on one tactic and a proof that is nonsense record identically.
- **Anything about novelty.** Basin makes no claim that any statement or proof is new. It is not a discovery instrument and must never be reported as one.
- **Whether the arms are actually independent.** Same-vendor checkpoints are caught by E4. Shared pretraining corpora across vendors are not, and cannot be, from inside this instrument.
- **Whether the prompt is neutral across arms.** One prompt, written once, will fit some arms better than others. Basin therefore cannot say anything about relative model quality, and no report from it should.
- **Convention-fill.** Where the prompt is silent, arms fill the gap with shared convention, and agreement then measures convention rather than mathematics. Every silence in the prompt is a place E2 and E3 are measuring something other than what they claim.
- **Selection on acceptance.** E3 is computed over items that survived corpus certification, which is non-random. A mutant that could not be refuted was discarded, so the FALSE stratum is enriched for mutants that are cleanly, checkably false. This deflates the difficulty of the stratum and the direction of the bias on E3 has not been worked out.
- **UNKNOWN as a strategy.** An arm that answers UNKNOWN often is never wrong and never right. E1 through E3 do not currently distinguish calibrated caution from evasion.
- **Anything about the OPEN stratum.** Zero measurements, by design, in v1.

---

## 14. Limitations carried in from prior work

These are not new. They were paid for elsewhere and they apply here unchanged.

- **Seat independence thins under shared design context.** Arms that receive a prompt written by one model, describing a task designed by that model, are less independent than the vendor list suggests. Name it; do not claim to have solved it.
- **Agreement is evidence about the shared hypothesis space, not about its completeness.** Four arms agreeing establishes what four correlated systems find natural. It does not establish that the fifth option was considered and rejected.
- **A quantized metric bounds its own resolution.** E3 is computed over singleton-dissent events, so its precision is capped by how many of those the corpus produces. A thin cell reads as a weak result whether or not the effect is real.
- **PASS on a calibration gate is necessary, not sufficient.** A green canary means the harness is not obviously broken. FAIL stays informative; PASS is weak clearance and gets reported as such.

---

## 15. Recording

Insights, catches, and reversals go to the Sovereign Stack under domain `basin`, layer per the usual convention. The stack is not a runtime dependency: Basin runs, and Basin's results stand, with the stack down.

Corrections get recorded as corrections. A superseded finding keeps its original entry and gains a dated one pointing at it. Nothing is quietly fixed.

---

## 16. Decisions open

1. **Reasoning mode or standard mode for the arms.** Reasoning mode costs several times more and probably raises every arm's accuracy. Standard mode buys a bigger corpus for the same money. My inclination is standard for the first sweep with one reasoning-mode replication after, but it depends on whether the ceiling or the disagreement structure matters more to you.
2. **Reuse PULSE or write fresh.** Evo has the provider adapters and the blind-dispatch pattern, but the model strings are a generation stale and the SDKs have moved. Reuse means fixing that first; fresh means duplicating work already done once.

---

## Provenance — assembly note

*Handoff note from the seat that assembled the v1 file. Kept as-is, and it is superseded
in two ways: the file is now `basin-spec-v2.md`, and the line numbers below describe the
1,019-line v1 assembly, not this file. Both corrections the note flags as unabsorbed were
absorbed by v2 — the E3 null in §7, the stance/certificate primitive in §4 and §6. Read it
as a record of how the file was built, not as a current map of it.*

Done. basin-spec-v1.md now opens with the rewrite and reads clean from line 1.

Structure:

Lines	What
1–329	§0–§16, the spec. Authoritative, unchanged except a five-line read-order note in the header
331–373	Corrections raised in review and NOT absorbed
375–763	Reviews A–D, each labeled with a summary of what it contributed
765–1019	Superseded — draft spec v1, banner-marked, do not act on
The draft that used to sit at the top is now the last section, marked superseded in full. Four review voices in the middle got labeled and moved below the spec. The old file had none of these boundaries marked — six documents ran together with only blank lines between them.

Verified nothing was lost: diffed all 347 original paragraphs against the result. One flagged as missing turned out to be present in both forms — §16 carries a reworded version at line 325, the draft's original wording survives at line 1019. Word count went 9,749 → 10,437; the 688-word delta is the labels and the corrections section, all new scaffolding, no rewriting of your text.

The part worth your attention is the corrections section at line 342. Two reviewers raised items they called blocking, and the rewrite didn't carry either:

The E3 null. basin-spec-v1.md:143 still says "against the null of the pooled individual error rate." Review C's (1−p)³ / [p³ + (1−p)³] isn't there. Since §7 says "nothing below changes after data exists," this one has a deadline — it has to be settled before you freeze, not after.
The stance/certificate primitive. verdict(P, claimed_stance, proof_body) appears nowhere in §0–§16. §6's schema has refutation_witness, so FALSE is partly handled, but Review D said it would authorize Session 1 only after the amendment.
I documented both rather than patching them, per §0's rule that frozen sections get superseded by dated entry and never edited in place. Amending §7 and §6 is your call — say so and I'll write them as dated supersessions.

Backup of the original concatenation is at basin-backup.md in the session scratchpad, which won't survive the session. If you want a durable copy, worth saying now. temple-math-lab.md I left alone — it was already organized this way.