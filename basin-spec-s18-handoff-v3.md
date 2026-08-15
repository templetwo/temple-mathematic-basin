# §18 — Handoff: The Pivot to Statement Validity

**Status:** direction, CONDITIONAL — provisional until the two §18.6 numbers exist. Dated 2026-08-12; header aligned with §18.1 the same day, after a seat flagged that a header reading "adopted" would hand every arriving seat exactly the settled reading §18.1 disavows. Supersedes the E3 trajectory as the project's active line, subject to the V0 gate.
**Authority:** Anthony. Written by the sidebar seat. Not a task order until Anthony signs §18.12.
**Corpus:** unchanged, byte-frozen `dc3cde90d33a19ed`.

---

## 18.0 What this document is

A handoff. It records what the project is now for, what it is setting down, what it carries forward, and the gates that decide whether the new line survives contact.

It exists because the project drifted for a documented reason and the fix is a written aim rather than more of Anthony's attention. See the direction entry of 2026-08-12, Stack domain `temple-mathematic-basin,direction,trunk`.

Read that entry before this one.

---

## 18.1 The pivot, and the argument that it is not another drift

**The trunk is unchanged.** One checkable mathematical result, however small, with a complete provenance record of how it was reached. The mathematics is the payload; the record is the demonstration.

**Basin measured whether minority disagreement among AI models carries information about truth.** That is a meta-scientific question about model ensembles. It is adjacent to the trunk, not on it. Three days of work established that this corpus cannot produce the phenomenon: two frontier families from different vendors, zero item-level wrong commitments across 132 item-observations, and no route to the calibration band that does not destroy the commitment rate the band exists to serve.

**The new line is statement validity.** Basin's mutation apparatus is repurposed from a dissent instrument into an instrument that tests whether a formal statement means what its author believes it means.

**The honest objection, stated so it can be checked:** this is another instrument. We spent an afternoon diagnosing instrument-substitution and the response is a second instrument. That objection is fair and the defence has to be specific.

The defence: statement validity is on the critical path to the trunk in a way E3 was not. If the lab produces a mathematical result and the Lean statement is vacuous, there is no result. That is not hypothetical. In DeepMind's Erdős study (arXiv 2601.22401), 50 of 63 technically-correct AI solutions were mathematically vacuous, meaning the dominant failure mode in AI mathematics today is not bad proofs but bad statements. A receipt that does not certify what the statement says is not a receipt.

E3 sat three steps from the trunk: H feeds deep mutations, which feed the band, which feeds 4-1 splits, which feed E3. Statement validity sits one step away and the step cannot be skipped.

**What would falsify the pivot:** if it turns out a result can be credible without evidence that its statement has content, this line is optional and we chose wrong. Watch for that.

**The pivot is CONDITIONAL, not adopted.** Corrected 2026-08-12 at the seat's flag. §18.6 produces a number that §18.9 says can end this line, so V0 can kill the pivot. v1 of this document read as though the pivot were settled and V0 were housekeeping. It is not. The line is provisional until the addressable-statement fraction and the cost of lifting the universe constraint both exist as numbers. Anything written before then is a plan awaiting a measurement.

---

## 18.2 Honest positioning: what is new here and what is not

State this in any writeup. Overclaiming here would be the exact failure the instrument exists to catch.

**Not new.** Mutating a specification and re-checking it is the vacuity paradigm from model checking, established by Beer, Ben-David, Eisner and Rodeh (CAV 1997; FMSD 18(2), 2001) and generalized by Kupferman and Vardi. Kupferman's survey "Sanity Checks in Formal Verification" (CONCUR 2006) states the unifying idea directly: vacuity and coverage are both based on repeating verification on a mutant input, with vacuity mutating the specification. Beer et al. reported that roughly 20% of specifications pass vacuously on first verification runs of a new hardware design, and that a vacuous pass always points at a real problem.

**Not new.** Countermodel finding for conjectures. Isabelle's Nitpick (Blanchette and Nipkow, ITP 2010) and Quickcheck (Bulwahn, CPP 2012) do this and run by default. Blanchette and Nipkow even evaluated Nitpick by running it against 2400 random mutants drawn from 12 Isabelle theories, which is the same mechanic pointed the other way: they mutated statements to test the tool, we would mutate statements to test the statement.

**Not new.** The contradictory-hypothesis check. "Don't Trust: Verify" (arXiv 2403.18120) replaces the goal with `False` and calls anything still provable vacuous. DeepSeek-Prover (arXiv 2405.14333) uses hypothesis rejection the same way. This is standard and we adopt it rather than reinventing it.

**Not new.** Mutation analysis in a proof assistant. mCoq (Celik et al., ASE 2019) mutates Coq definitions, and explicitly does not touch specification properties or proofs.

**Closest prior art, and it is close.** TLA-Prover (Spencer et al., ICSOFT 2026, arXiv 2606.06133) implements almost exactly this idea in TLA+: after a specification passes the model checker, the correctness property is mutated and the checker must then detect a violation, or the property was always-true and contributes nothing. Their operators are near-identical to ours, including negating a top-level conjunct, flipping `=` to `≠` and `≤` to `≥`, and swapping a named constant. They frame it as anti-reward-hacking, and they concede it blocks tautology-style hacks without catching subtler failures.

**The opening.** TLA-Prover asserts that in Lean or Isabelle a shortcut proof still requires a non-trivial goal statement. That is false, and the literature above refutes it. No tool appears to mutate Lean 4 theorem *statements* and use kernel-checked proof or refutation of the mutants as a validity instrument. Existing Lean vacuity detection is static and pattern-based (Lean-GAP's eleven suspicious-statement patterns, arXiv 2606.02588; the `is-my-lean-proof-vacuous` unfold-chain scanner).

**Therefore the contribution is transport and standardization, not conceptual novelty.** The claim to make is: *the vacuity paradigm has not been transported to dependent type theory, and there is no accepted standard for evidence that a Lean statement has content.* That is defensible. "A new paradigm" is not.

**Confidence in the gap and what would close it:** a Lean 4 library or paper that mutates statements and uses proof or refutation of mutants as a fidelity signal. Search for it before building. If it exists and is obscure, that alone is worth a writeup.

**Provenance warning on this entire section.** Every citation above came from one deep-research pass run on 2026-08-12 from the sidebar. None has been independently verified against the primary sources by any seat. The whole positioning stands or falls on that search, and the load-bearing claim is an **absence** claim, which is the weakest kind of claim there is: it asserts that nobody has done a thing, on the strength of not having found it. Absence claims need someone actively trying to falsify them, not someone confirming them. Assign that adversarially in V0, to a seat instructed to find the prior art rather than to check whether it exists.

---

## 18.3 What is set down, what is carried, what is dead

**Set down (held, not killed; each returns to the queue under §18.10 with its new-data requirement named):**

- E3 and the dissent estimand.
- The P4 calibration band and the 0.75–0.80 target.
- The hardening program and the hypothesis-discharging rungs.
- H, in every sense. **H = 4**, verified 2026-08-12: parents 0029, 0051, 0052, 0053. Both halves of the correction belong in the record. First, the state report answered a different quantity: 23 sites across 17 parents is the structural count over all 105 parents, not H. Do not cite 23 as H. Second, and this makes the correction cleaner than first stated, the widened Prop-typed predicate **changes H by zero**, because `true_0015` and `true_0072` are confirmed absent from the measured 66. The predicate undercount is real as a fact about the predicate and irrelevant to the quantity that was doing the work. H is 4 under both the committed predicate and the corrected one, against a required 9.
- The certification-correlation hypothesis (Fisher p = 0.0274, OR 3.24). Held, post-hoc, and additionally confounded: the test treats 105 parents drawn from 43 modules with up to 6 per module as independent, which is a second pseudoreplication axis recorded nowhere.

**Carried forward (these are the assets the pivot runs on):**

- `verdict.py`, the trusted kernel harness, subject to §18.6.
- The seven mutation operators and the refutation ladder.
- The frozen corpus, 105 parents and 66 certified pairs, as a *test fixture* rather than a measurement instrument.
- The 170 kernel verification records and 65 never-corpused candidates in `~/Desktop/basin-rescue-20260812/`.
- `shadow_candidates.json`: five hand-built false statements with kernel-accepted refutations. These are the seed of the certificate format and were nearly lost.
- Pre-registration machinery, the liveness guard, transactional-change discipline, receipt and provenance discipline.
- **The cross-vendor claimed-versus-certified gap.** grok-4.5 at 0.9242 claimed against 0.5758 certified; deepseek-v4-pro at 0.9848 against 0.4848. Corrected 2026-08-12 after the seat flagged it: this appeared in neither list in v1, which for a spec is worse than being set down, because an unclassified asset is one nobody is responsible for. It does not belong with E3. It requires no dissent, no minority, no 4-1 split, and no eligibility term; its only relation to E3 is that the same apparatus happened to collect it. It is a per-arm measurement that replicated across two vendors on identical items under an identical protocol, and it is direct evidence for this line's own premise. The general form of that premise: **model confidence and kernel acceptance come apart**, of which vacuous formalization is one species and confident-but-undemonstrable assertion is another. Carry it, and attach the limitation from §18.11 wherever it is cited: one arm is auditable and one is not, because `proof_body` was never persisted on the primary run.

**Dead:**

- Nothing. Per Anthony's rule of 2026-08-12, this is a lab and not a certainty machine. Uncertainty is held and recycled, not punished. Everything above is retrievable.

---

## 18.4 The instrument: the non-vacuity certificate

The deliverable is a portable artifact that ships alongside a Lean 4 statement and constitutes evidence that the statement has content.

Three components, each detecting a **different** failure mode. This separation is load-bearing and is the main design lesson from the research.

**C1 — Non-contradiction.** The hypotheses do not prove `False`. Substitute the goal with `False` and run the prover; anything still provable is vacuous. Cheap, established, and it is the correct detector for the contradictory-hypothesis case. Mutation is the *wrong* detector there, see §18.5.

**C2 — Witness.** A kernel-checked term satisfying all the hypotheses. This is the dependent-type-theory analogue of Beer et al.'s "interesting witness," and it is the strongest single component because it is a positive kernel fact, not an inference from absence. Build on `decide`, `native_decide` on small finite instances, and `plausible`. Note that Lean's counterexample tooling is weak relative to Isabelle's, and this is where the engineering effort will actually go.

**C3 — Content and boundary.** A family of mutants of the statement, each carrying a kernel-checked refutation. A mutant that is refuted proves the statement's boundary is where the author believes it is. This is the Basin apparatus, and it is the component that has not been built for Lean.

**Certificate output format:** the mutant family, the refutation for each mutant that was refuted, the witness, the `#print axioms` result, the harness commit, and the elaborated-type digest of the statement. Every claim in it is kernel-backed or it does not appear.

---

## 18.5 Signal asymmetry — the critical design constraint

**Rule: the certificate reports what was proved. It never infers a defect from a failure to prove.**

This is not caution. It follows from two results.

**The confounded negative.** If a mutant survives the ladder, we cannot distinguish "the mutant is actually true, so the statement's boundary is not where we think" from "the mutant is false but the ladder is too weak." This is the equivalent-mutant problem (Offutt and Pan, 1997) and it is undecidable in general. A surviving mutant is recorded as `UNRESOLVED`. It is never evidence against the statement.

Basin has already been burned by exactly this. The "corpus cannot produce a wrong commitment" finding was an artifact of 3-of-4 aggregation, not a property of the corpus: at sample level there are four wrong commitments, and `refutable_0009` draws a wrong PROVABLE from both vendors. An absence read as a property.

**The vacuity trap.** If the original statement is vacuously true because its hypotheses are contradictory, then every mutant that preserves the contradiction is *also* vacuously true, and therefore provable rather than refutable. The mutant family goes quiet. TLA-Prover hit the same wall: no mutation of `TRUE` produces a rejectable state.

So a vacuous statement presents as "none of my mutants were refuted," which is the ambiguous case above. **Mutation cannot detect the failure mode it looks like it should detect.** C1 detects it directly and cheaply. This is why the components are separate and why C3 must not be sold as a vacuity detector.

**One more caution.** Perturbing a constant or flipping a relation is a syntactic edit. In a totalized setting — Lean's `deriv` returning 0 where no derivative exists, natural subtraction, division by zero — a syntactic mutation can land on another totalized-but-content-free statement. Operators need to be semantics-aware. Which edits preserve mathematical meaning in dependent type theory is not characterized anywhere. That is a risk and, framed the other way, a paper.

---

## 18.6 The binding constraint: universes

`verdict.py` line 110 hardcodes `levelParams := []`. The harness rejects any statement whose elaboration introduces a universe parameter. Every binder must range over a concrete type: ℕ, ℤ, ℚ, ℝ, ℂ, `Fin`, `ZMod`. It cannot accept a statement about a general group, ring, module, topological space, or category. This killed 25 of 39 candidates in one P3 mining batch, appears zero times in the spec, and is recorded only in local chronicle entry 16178.

**This bounds the instrument, not only the mathematics.** A statement the harness cannot elaborate is a statement the certificate cannot cover. So the constraint determines which benchmarks and which repositories are addressable at all.

**This was written as a go/no-go. Amended 2026-08-12 once the lift was costed, because the answer changes the gate.**

**Cost of lifting — CLOSED.** Two seats converged independently: pass-through `levelParams` is roughly 1–3 days. C3 operating at `Type u`, meaning mutation with kernel-checked refutation over universe-polymorphic statements, is roughly 1–3 weeks, and is skippable if T1 stays concrete.

**Consequence, which must be stated rather than quietly inherited: the stop branch is now nearly unreachable.** §18.9 kills the line only if the fraction is small *and* lifting is expensive. Lifting is days. So the addressable fraction can no longer end the line; it can only reorder the work. The conditionality declared in §18.1 was a real gate and it has closed in the permissive direction. Nobody should proceed believing a kill-gate is still standing here.

**Addressable fraction — OPEN, and it is TWO numbers, not one.** The cheap lift buys *elaboration*. It does not buy C3 over polymorphic statements, which is the expensive item. So the measurement that decides anything is the second one:

1. **Elaboration fraction.** What proportion of statements the harness can elaborate at all. Fixable in days.
2. **Polymorphic-C3 fraction.** What proportion requires mutation and refutation over universe-polymorphic statements. This is the one that costs weeks, and it is what the branch actually turns on.

**Stratify both by source. A pooled figure would be actively misleading**, because the three corpora have very different polymorphism profiles: miniF2F is competition mathematics and mostly concrete; ProofNet is undergraduate mathematics and carries substantial group, ring, and space structure; Formal Conjectures is mixed. A single blended number averages a benchmark the tool can serve today against one it cannot serve at all, and hides the strategic picture — which is that the tool may have a market in one corpus immediately and need the expensive lift for another.

---

## 18.7 Phases and gates

**Amended 2026-08-12 after the seat's first disagreement, which was correct and which I had not seen.** The v1 plan ran V0 through V3 and terminated in a certificate, a validation run, and a publish-or-kill decision. A fully successful V3 produced a verification-tooling paper and no mathematics. The pivot is justified in §18.1 by proximity to the trunk, and the plan did not contain the thing it claimed to be proximate to. That is the same substitution diagnosed in the direction entry, reasserting itself inside the document written to prevent it, within a day. Treat that as evidence the instinct is structural rather than a one-off, and expect it to recur.

The fix is not a phase appended at the end, because an appended trunk phase is the same failure with a later date. The trunk track runs **concurrent** with the instrument track and gates it.

**V0 — Debts and scoping. No new capability.**
Clear §18.11. Scope §18.6. Search for the prior art that would close §18.2.
*Gate:* the record reproduces itself, the rescue is pointed at from a chronicle, the addressable-statement fraction is a number, and the cost of lifting the universe constraint is an estimate. See §18.6 — this gate can end the line.

**T1 — Target selection. Runs immediately after V0, before V1.**
Choose one mathematical target inside the fence, with partial credit, not behind a proven barrier. Candidates: a cap set lower-bound construction in F_3^n via `ZMod 3` and `Fin n`; the minimum overlap constant; a small Ramsey or book-Ramsey value; a prize-bearing Sidon-set problem. On prizes, pinned 2026-08-12 after a seat flagged the tension with the direction entry: the direction excludes prize problems because they return no signal — no partial credit, no feedback. **The governing criterion is partial credit, not prize status.** A small Erdős-style prize problem qualifies if and only if a tighter bound, a new construction, or an improved constant counts as progress; any target where everything short of full resolution returns nothing is excluded regardless of what it pays. Formalize its statement.
*Gate:* the harness elaborates the target statement. If it cannot, the target is outside the real fence and is replaced.

**V1 — Certificate on one statement, and that statement is T1's.**
Implement C1, C2, C3 end to end. The first certificate is produced for the target, not for an arbitrary theorem, so the instrument is exercised by real use from the first run.
*Gate:* certificates are produced for the target statement and for one known-defective statement, and they differ in the expected direction.

**T2 — Attempt the target. Runs concurrent with V2.**
A genuine attempt at the mathematical result, with the certificate attached. **UNKNOWN is a legitimate terminal state** and a documented no-result with a complete receipt satisfies this phase. Manufacturing a result does not.
*Gate:* an attempt exists with a full provenance record, terminating in a result or in an honest no-result.

**V2 — Batch against known ground truth.** See §18.8.
*Gate:* recovery rate and false-positive rate against pre-registered thresholds.

**V3 — Decision.**
Publish, extend, or kill per §18.9. **V3 does not close on the instrument track alone.** It requires both a validated certificate and a completed T2, result or honest no-result.

**Not authorized before V3:** engaging Mathlib or Formal Conjectures maintainers with a proposed standard. Earn the numbers first.

---

## 18.8 Validation against known ground truth

The instrument is validated against defects that other people have already found and published.

**Targets:**

- ProofNet. Poiroux et al. (arXiv 2406.07222) found mistakes in 118 of 371 entries. This is the primary benchmark.
- miniF2F. The eight named incorrect test problems from DSP+ (arXiv 2506.11487): `amc12a_2020_p7`, `amc12a_2020_p10`, `amc12a_2021_p9`, `imo_1968_p5_1`, `induction_prod1p1onk31e3m1onn`, `mathd_algebra_158`, `mathd_algebra_342`, `mathd_numbertheory_343`. miniF2F-v2 (arXiv 2511.03108) reports fixes moving pipeline accuracy from about 40% to about 70%, which is the scale of what bad statements were costing.
- The vacuous-hypothesis catalog in "Faults in Our Formal Benchmarking" (arXiv 2606.29493), which also ships Lean metaprogram checkers including a Vacuous Theorem checker. Beat it or integrate it; do not duplicate it silently.
- False-positive control: a sample of Mathlib statements presumed correct.

**A distinct study, not a fourth ground-truth target.** "Beyond Compilation" (arXiv 2606.31002), found during V0, reports 89.5% compile-pass against 60.5% faithfulness. Twenty-nine points of exactly the gap the certificate targets, quantified independently of us, which is external support for the premise in §18.1 from a source we did not produce.

It adjudicates by LLM judges. That is the opening and it is also why this cannot be scored as ground truth: their labels are model opinions, not kernel facts, so recovery rate against them is meaningless. Run it as a **disagreement study** instead. The informative cells are the corners: statements the certificate says have proven content where the judges said unfaithful, and statements the judges passed where C1 fires or no mutant can be refuted. A kernel-backed artifact and an LLM judge are different epistemic objects, and the cases where they part are the argument for the certificate existing.

**Metrics:** recovery rate on known defects, false-positive rate on presumed-good statements, and per-component attribution — which of C1, C2, C3 caught each defect.

**The methodological trap, and it is the sharpest one in this document.** The 118 ProofNet defects are published. A seat can read the answer key. Tuning operators or thresholds until the known defects are recovered is fitting to the test set, and it would produce a tool that works on exactly the defects everyone already knows about and nothing else.

**Therefore, pre-registered before any run:**
1. Operators, thresholds, and metrics fixed in writing.
2. A held-out subset of the known-defect list that no seat inspects until the run is complete.
3. Any change to operators after seeing results is a new pre-registration and a new run, recorded as such.

---

## 18.9 Kill criteria

Adopted in advance so that abandoning is a recorded decision rather than a slow fade.

- **If C1 plus Mathlib's existing `unusedArguments` linter recovers as much as the full certificate**, the mutation machinery is not earning its complexity. Ship the hardened vacuity check and the witness format; drop C3.
- **If most mutants survive for ladder-weakness reasons**, C3 has no signal. Keep C1 and C2, drop C3.
- **If the addressable-statement fraction from §18.6 is small and universe polymorphism proves expensive**, the tool has no market. Say so and stop.
- **If a real Nitpick-for-Lean appears from the community**, integrate rather than rebuild.
- **If prior art closing §18.2 is found**, reposition to a replication or an extension, and say so plainly.
- **If the certificate is built and validated and no mathematics has been attempted**, the pivot reproduced the drift it was adopted to correct, and the line has failed on its own justification regardless of how good the tool is. This criterion was proposed by the seat and it is the one most likely to be quietly ignored, because at that point there will be a working instrument and a publishable paper. That is exactly the condition under which it must fire.

---

## 18.10 Governance carried forward

These four are adopted from the direction entry of 2026-08-12 and apply to this line from V0.

1. **The blocking test.** For every proposed fork: does the trunk question stop if we skip this? It filters without judging whether the work is good, which is what makes it usable when every fork is individually correct.
2. **Trunk/instrument tagging.** Every chronicle entry is tagged. Refuse nothing; make the ratio visible as a number.
3. **The re-entry queue.** Uncertainty is held and recycled, not discarded. Every held item names the **new data** its next angle requires. Re-approaching with new data is recycling; new tests on the same data is the multiplicity problem. A cost makes it a queue rather than an invitation to keep testing until something crosses.
4. **The aim in the arrival packet.** Seats arrive, get routed, receive open threads, and never receive the trunk. The packet leads with the aim from §18.1.

**Extended here:** the liveness guard generalizes past cross-arm statistics. Before interpreting any statistic, establish that the observations it assumes actually occurred. Every run reports served-model distribution and malformed/transport-failure rate *before* its result. The void run of 2026-08-11 produced the exact number pre-registered as decisive from zero measurements, and was one unchecked field from being reported as the project's strongest finding.

---

## 18.11 Debts to clear before V1

1. **The reproducibility defect, first.** `python3 analyze.py runs/2026-08-11.jsonl` returns 68 items, 0.9265, 0.5882 — numbers that appear nowhere in the record — because the file concatenates an 8-row smoke run with the 264-row real run and `analyze.py` pools groups with no run_id filter. For a project whose thesis is the audit trail, the tool that made the record cannot reproduce the record. Small, mechanical, and it goes first.
2. **The rescue has no pointer.** 170 kernel verification records, 65 never-corpused candidates, and `shadow_candidates.json` exist in one Desktop directory referenced by one report. Give it a chronicle pointer and an independently auditable manifest.
3. **P0, P1 and P2 exist only in t2helix.** The acceptance surface, the first TRUE stratum, and the moment the project first produced data are absent from the Stack. If the receipt is the differentiator, its first three phases cannot live in a local sqlite.
4. **Correct the H conflation** in the record, per §18.3.
5. **family-y data** has a durable home outside job scratch, and the run carries `proof_body` on all 264 records while the primary arm carries none. The cross-vendor gap has one auditable arm and one opaque one; state that limitation wherever the gap is cited.

---

## 18.12 Still Anthony's

- **The §7 ruling.** Which of the two senses of "committed stance" the spec means is textual silence, and no review resolves it. Everything built since the reversal assumes the claimed reading. It is unsigned. If it flips, the band reading flips and so does the tuning direction. It is set down with E3 either way, but the record should not carry it as settled.
- **The name.** This line needs one and it is not a seat's to pick.
- **Whether the pivot is right at all.** §18.1 states the argument and §18.1's last paragraph states what would falsify it. A seat disagreeing with the pivot should say so rather than implement it quietly.

---

*Nothing in this document authorizes a corpus change, a commit, or a model call. Corpus remains byte-frozen at `dc3cde90d33a19ed`.*

---

## Appendix (unnumbered in v3 as received; needs a section number and Anthony's sign before it binds) — T2Helix as the observing register

T2Helix becomes the observing register: it records what seats *do*, not what they report, and it syncs upward by construction so the record stops forking.

**Why this and not something else.** The Stack records what a seat chooses to write. T2Helix has hooks, so it records what happens. That difference decides whether the lab's central claim is measurable. Every governance discipline adopted today — the catch ledger, the position field, trunk-versus-instrument tagging, the compass confirm rate — has to come from the observing layer or it is self-reported, and self-reported catch rates are worth about as much as a model's confidence in its own proof.

That's the same distinction the certificate is built on, one level up. A seat writing "I caught this" is a claim. A hook recording that an auditing seat's action preceded a correction is an observation. You are building an instrument to force that distinction in mathematics while running the lab itself on claims.

**Blocking test, applied honestly.** The trunk deliverable has two halves: a checkable result, and a complete provenance record. This does not block the mathematics. It blocks the receipt, which is the half that is actually the differentiator. A result that ships with ten remembered catches is a story. A result that ships with a measured catch rate, time-to-catch, and the position of each catching seat is the thing nobody else can produce.

**And the history argument, which I'd weight highest.** This project has now lost the same class of data three times. The corpus harvester's selection rule, gone because the tool was never committed. The proof bodies on the primary arm, gone because the sweep discarded them, taking 86 compile errors with them. Both were cheap to record and are permanently unrecoverable. The catch positions are the third instance and they are still open, barely. Every catch between now and V3 that lands without a position field is another one you cannot get back.

**Minimum for v0.6:**

Every chronicle write carries fields the seat does not choose: acting position (implementing or auditing), track (trunk or instrument), and for compass events the outcome, not just the firing. Denied, confirmed-through, or abandoned. Prefer inferring position from invocation context over self-declaration, and where it has to be self-declared, mark it as such in the record so the two are never pooled.

Then the fork closes. T2Helix syncs to the Stack automatically. P0 through P2 needed a human-triggered backfill today, and that is the last time it should be possible for three phases of the record to exist in one place only.

**What not to do:** no new compass rules. The gate fired twice today and was confirmed through twice, and the honest response to that is measurement, not more rules. A gate whose confirm rate nobody tracks becomes a rubber stamp, and you cannot calibrate it until the outcome field exists.
