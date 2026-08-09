# Temple of Two — Mathematical Research Lab

**A design document assembled from nine rounds of proposal, review, and correction.**
Chronological. Nothing removed. Where a later round overturns an earlier one, the
earlier text carries a `⚠ SUPERSEDED` banner pointing forward to the correction —
read the banner before acting on the text beneath it.

---

## How to read this document

| Round | Section | What it is |
|-------|---------|------------|
| 1 | [Original proposal](#round-1--original-proposal) | The `/grand-challenge-sandbox/` tree and the review prompt sent out |
| 2 | [Review A](#round-2--review-a-structural-gaps) | Structural gaps: orchestration, state schemas, tool bridges |
| 3 | [Review B](#round-3--review-b-the-trust-ladder) | Trust ladder L0–L3, goalpost lock, registry, cascading invalidation |
| 4 | [Positioning I](#round-4--positioning-i-the-conditioned-kernel) | Conditioned Kernel framing, three planes, partial-progress yield |
| 5 | [Tooling fact-check](#round-5--tooling-fact-check-august-2026) | **The empirical section.** Real tools, licenses, costs, the Oct 2025 Erdős episode |
| 6 | [Synthesis](#round-6--synthesis-and-buildable-blueprint) | Merges rounds 1–5 into a revised tree + week-by-week checklist |
| 7 | [Positioning II & III](#round-7--positioning-ii-temple-differentiation) | Temple differentiation, epistemic state vector, Witness role, acceptance invariance |
| 8 | [Review C](#round-8--review-c-convergence-check) | Catches novelty≠validity; flags rhetoric-to-engineering inversion |
| 9 | [Review D](#round-9--review-d-the-instrument) | Convergence may be an artifact; build one instrument |

**If you read only one section:** Round 5 (the only section with citations) and
Round 9 (the actual next action). Rounds 4 and 7 are positioning, not engineering.

**Open offers, both unanswered:** Round 8 offers to scaffold the minimal vertical
slice; Round 9 offers to write the five-model kernel-acceptance harness.

---

## Round 1 — Original proposal

*The starting architecture and the prompt that was sent out for external review.*

To create an environment capable of targeting frontier mathematics, a project folder must bridge two fundamentally different cognitive spaces: **informal natural-language reasoning** (where human mathematicians brainstorm and generate intuition) and **formal deterministic verification** (where software enforces total axiomatic correctness).

---

### The Universal Math Agent Architecture

```
/grand-challenge-sandbox/
├── 00_CORE_DIRECTIVE.md            # Execution bounds, goal definitions, safety rules
├── config.json                     # API keys, compute allocations, agent orchestrations
├── 01_PROBLEM_SPEC/
│   ├── problem_statement.tex       # Latex raw math formulation
│   ├── formal_definitions.lean     # Lean 4 formal target definitions
│   └── known_bounds.json           # Known edge cases, proven sub-lemmas
├── 02_AGENT_SCRATCHPAD/
│   ├── informal_hypotheses/        # Unstructured LLM thought chains (.md)
│   ├── counterexample_searches/    # Python code / matrix output checking edge cases
│   └── verified_lemmas/            # Compiled Lean 4 code (.lean) successfully checked
├── 03_TOOL_LAB/
│   ├── lean_kernel/                # Lean 4 REPL integration for instant formal verification
│   ├── computer_algebra/           # SymPy / SageMath execution hooks
│   └── SAT_SMT_solvers/            # Z3 / CVC5 solver integration for brute-force search
└── 04_MULTI_MODEL_CONSENSUS/
    ├── synthesis_agent.py          # Merges insights from different specialized AI engines
    └── consensus_log.md            # Log of cross-verification votes across model nodes

```

#### Why This Folder Structure Works

* **`01_PROBLEM_SPEC` (The Ground Truth):** Houses the problem stated simultaneously in human-readable LaTeX and machine-verifiable Lean 4. This prevents models from "moving the goalposts" or redefining axioms to fabricate fake solutions.
* **`02_AGENT_SCRATCHPAD` (The Iterative Engine):** Separates creative intuition from rigorous math. AI agents write rough hypotheses in Markdown, test boundary cases using Python scripts in `counterexample_searches`, and lock proven steps into `verified_lemmas`.
* **`03_TOOL_LAB` (Deterministic Execution):** Equips models with active tool-calling. Instead of hallucinating complex arithmetic or logical leaps, the models offload computations to SageMath, Z3 SMT solvers, or the Lean 4 REPL.
* **`04_MULTI_MODEL_CONSENSUS` (Cross-Architecture Verification):** Acts as a peer-review panel. A single model will often double down on its own logical flaws; routing outputs through heterogeneous architectures creates true consensus.

---

### Universal Summary for External AI Evaluation

> **System Prompt / Context for External AI Models:**
> "We are designing a standardized local project environment (`/grand-challenge-sandbox/`) to benchmark and orchestrate multi-agent AI systems against open, high-level mathematical problems (e.g., Erdős conjectures or Millennium Prize problems).
> **Core Architecture Proposed:**
> 1. **Formal Grounding:** Lean 4 environment (`lean_kernel`) for compile-time proof verification to eliminate hallucinated reasoning.
> 2. **Scratchpad Separation:** Unstructured text scratchpads for natural-language intuition, paired with Python/SageMath execution loops for counterexample searching.
> 3. **Deterministic Tool Lab:** Direct agent access to SAT/SMT solvers (Z3) and Computer Algebra Systems (SymPy/Sage) to handle symbolic manipulation.
> 4. **Multi-Model Consensus:** Cross-verifying hypotheses through multiple distinct LLM architectures before attempting formal compilation.
> 
> 
> **Task:** Review this workspace framework. What specific file protocols, state-management schemas, or tool-calling bridges are missing to make this folder truly production-ready for autonomous mathematical research?"

---

---

## Round 2 — Review A (structural gaps)

*First external review. Diagnoses the workspace as static — missing protocols,
schemas, and control surfaces rather than missing directories. Correct but generic;
Round 3 finds the sharper failure modes.*

**The proposed `/grand-challenge-sandbox/` is a strong conceptual skeleton.** It correctly separates the two cognitive regimes that frontier mathematical work requires: open-ended natural-language intuition (hypotheses, sketches, counterexample hunting) from strict axiomatic verification (Lean kernel, SMT, CAS). The four-layer split (Problem Spec → Scratchpad → Tool Lab → Multi-Model Consensus) mirrors how working mathematicians actually move between blackboard exploration and formal write-up, and it already incorporates several patterns that recent Lean-4 multi-agent systems have found essential (informal/formal duality, deterministic tool offload, cross-model checking).

It is **not yet production-ready** for autonomous research on open problems (Erdős-type conjectures, Millennium-adjacent questions, or sustained library-building). The gaps are less about missing directories and more about missing *protocols, schemas, control surfaces, and feedback loops* that turn a well-organized folder into a long-running, recoverable, self-improving research agent.

Below is a concrete gap analysis organized by the categories the query asks for: file protocols, state-management schemas, and tool-calling bridges. Recommendations draw on patterns that have repeatedly appeared in 2025–2026 Lean agent systems (planner–prover–corrector loops, shared whiteboards, Mathlib retrieval, persistent memory of failures, interactive Lean sessions, etc.).

### 1. Orchestration & Control-Flow Protocols (the biggest missing piece)

The current structure is essentially a *static workspace*. There is no explicit driver that decides “what happens next,” manages parallelism, detects stagnation, or recovers from failure. Frontier problems are multi-day (or multi-week) processes; without a control plane the system cannot run autonomously.

**Missing artifacts / protocols:**
- A top-level **orchestrator** (or deterministic state machine) that owns the outer loop. Typical roles observed in successful systems: Planner / Decomposer, Prover, Corrector/Reviewer, Library Scout, Informal Reasoner, Verifier. The orchestrator maintains a global plan and dispatches specialized agents.
- Explicit **workflow definition** (YAML, JSON, or a small domain-specific language) describing allowed transitions: e.g., “informal hypothesis → counterexample search → autoformalization attempt → Lean interactive session → consensus vote → promote to verified_lemmas or backtrack.”
- **Subgoal / dependency graph** management. Theorems almost always decompose. You need a first-class representation of the current proof tree (or conjecture tree) with status tags (`sorry`, `in-progress`, `proven`, `disproven`, `abandoned`), ownership, and dependency edges.
- Termination, stagnation, and resource policies inside `00_CORE_DIRECTIVE.md` or a companion `policies.yaml`: max iterations per subgoal, wall-clock budgets, when to escalate to human review, when to spawn parallel explorations, when to declare a direction exhausted.

Without these, the multi-model consensus layer has nothing coherent to vote on, and the scratchpad fills with disconnected markdown.

### 2. State-Management Schemas

The folder contains raw artifacts but almost no *structured, queryable state*. Long-running autonomous research requires durable, versioned, searchable memory of both successes *and* failures.

**Recommended core schemas (add these as first-class files or a lightweight SQLite/JSON store):**

> **⚠ SUPERSEDED — Round 3 (content-addressed registry) and Round 7 (state vector).**
> The schemas below are an early sketch. The `"confidence": 0.92` field in the lemma
> registry is explicitly killed in Round 7: no naked confidence scalar. Four orthogonal
> axes replace it — verification (V0–V3), novelty (N0–N2), target fidelity, dependency
> health — and no axis converts into another. Read this section for the reasoning about
> *why* structured state is needed, not for the schema itself.

- **`state/global_state.json`** (or equivalent):
  - Current active goals / conjectures
  - Dependency DAG of lemmas
  - Attempt history (agent ID, model, timestamp, outcome, cost)
  - Resource ledger (tokens, CPU/GPU hours, solver timeouts)
  - Human-intervention flags

- **Whiteboard / living plan** (`02_AGENT_SCRATCHPAD/whiteboard.md` or structured YAML): a single, continuously updated document owned by the planner that records the current high-level strategy, open questions, promising but incomplete directions, and “do-not-retry” dead-ends. This is more important than the free-form `informal_hypotheses/` directory.

- **Lemma / artifact registry** (extend `known_bounds.json` and `verified_lemmas/`):
  ```json
  {
    "id": "lem_vdac_oligomer_bound_v3",
    "informal_statement": "...",
    "lean_statement": "...",
    "status": "proven | sorry | conjectured | refuted",
    "dependencies": ["..."],
    "proof_file": "verified_lemmas/...",
    "provenance": {"models": [...], "attempts": 7, "key_insights": [...]},
    "confidence": 0.92,
    "last_verified": "2026-..."
  }
  ```

- **Failure memory / anti-pattern store**: structured records of strategies that failed, with enough context that later agents can avoid rediscovering the same dead end. Pure markdown is insufficient; it needs to be searchable.

- **Provenance & audit log**: every tool call, model response (or hash), Lean error, and state transition should be append-only and timestamped. `consensus_log.md` is a start; a structured event log (JSONL or database) is required for debugging and for scientific trust.

Version everything with git (or a content-addressed store). Frontier formalizations grow; the ability to bisect “when did this lemma stop compiling after Mathlib update” is non-negotiable.

### 3. Tool-Calling Bridges & Execution Environment

`03_TOOL_LAB/` lists the right categories but lacks the actual *bridges* and interactive semantics that make them usable by agents.

**Critical missing bridges:**

- **Interactive Lean 4 environment**, not just “REPL integration.” Successful systems treat Lean as a live workspace:
  - Goal inspection, tactic application, error localization
  - File-edit + continuous type-check loops (the agent edits `.lean` files the way a human does in VS Code)
  - `sorry` / `admit` management and “sorrify” utilities that turn a nearly-correct proof into a valid incomplete one so partial progress is preserved
  - Mathlib / local library search (semantic + name-based). Premise selection remains a major bottleneck; without a retrieval tool agents reinvent or miss key lemmas.

- **Standardized tool schemas** (OpenAI-style function calling, MCP, or equivalent). Agents need typed interfaces for:
  - `lean_check(file_or_snippet) → diagnostics`
  - `lean_apply_tactic(goal_id, tactic) → new_state`
  - `mathlib_search(query, k) → ranked premises`
  - `sympy_eval / sage_eval / z3_solve` with resource limits and sandboxing
  - Counterexample generators that return both the witness and a machine-readable certificate

- **Sandboxing and resource isolation.** Arbitrary Python, Sage, and solver code must run under cgroup/container limits, with timeouts and memory caps enforced by the orchestrator. Frontier exploration routinely produces pathological inputs.

- **Async / long-running job handling.** SMT searches, large Lean compilations, and numerical experiments can take minutes to hours. The system needs a job queue, status polling, and the ability for the planner to continue other work while waiting.

- **Autoformalization pipeline** as a first-class tool or agent. Translating a natural-language hypothesis + sketch into a well-typed Lean statement (and a skeleton proof) is itself a hard sub-problem; it should not be left as an ad-hoc LLM call.

### 4. Additional Production Gaps That Affect Autonomy

- **Knowledge accumulation across problems.** A true research agent should grow a personal library of verified lemmas, tactics patterns, and informal heuristics that transfer. The current design is largely single-problem oriented.
- **Human-in-the-loop gates.** For open problems, pure autonomy is both unsafe and inefficient. Explicit review points (major conjecture adoption, expensive formalization campaigns, contradictory consensus) should be configurable.
- **Observability & evaluation harness.** Continuous logging of intermediate metrics (proof progress, novelty of generated lemmas, formalization success rate, cost per verified line) plus a regression suite of known problems so the pipeline can be improved without silent degradation.
- **Export surface.** The ultimate product of mathematical research is both a formal artifact *and* a human-readable account. There should be a protocol that turns the whiteboard + verified lemmas + provenance into a draft paper or formalization repository ready for external review.

### Why These Gaps Matter More for Frontier Work Than for Benchmarks

On MiniF2F-style or Putnam-Hard problems the missing pieces can be papered over with heavy sampling and short horizons. On open conjectures the search tree is enormous, partial progress must be preserved for days, failed directions must be remembered, libraries must grow, and the system must recover after crashes or Mathlib updates. Systems that treat the workspace as a living, versioned, queryable project (with a planner that owns a whiteboard and a dependency graph) have repeatedly shown better scaling behavior than pure generate-and-verify loops.

### Minimal Viable Additions to Reach Production Readiness

1. Add `orchestrator/` (or `00_CONTROL/`) containing the state machine / agent graph and the global state schema.
2. Introduce a living `whiteboard.md` + structured lemma registry.
3. Replace the high-level `lean_kernel/` placeholder with a concrete interactive Lean bridge (file-edit + diagnostics + search).
4. Define typed tool schemas and enforce sandbox + budget policies.
5. Add provenance logging and a simple failure-memory store.
6. Make the entire sandbox a Lean project (lakefile, Mathlib dependency) so verified lemmas form a coherent library rather than isolated files.

With those protocols and schemas in place, the existing four-layer intuition remains excellent. The architecture then becomes a genuine research substrate rather than a well-organized sandbox: capable of sustained, recoverable, cross-model exploration of problems whose solutions are not already latent in the training data.



---

## Round 3 — Review B (the trust ladder)

*The pivotal review. Introduces the L0–L3 trust hierarchy, the goalpost lock, the
content-addressed registry, and cascading invalidation. Most of the surviving
architecture originates here. Two of its rules are later corrected — textual
identity (Round 4) and novelty-as-trust-gate (Round 8) — but the trust ladder
itself holds.*

This is a solid skeleton — the informal/formal separation and the dual LaTeX+Lean problem spec are the right instincts. But the structure is organized by *artifact type*, when an autonomous research system needs to be organized by *trust level* and *workflow state*. As written, it would fail in predictable ways within a few hundred agent-hours. Here's the review the document asks for, ordered by severity.

## The three fatal gaps

### 1. No goalpost lock between `problem_statement.tex` and `formal_definitions.lean`

You assume that stating the problem in both LaTeX and Lean prevents goalpost-moving. It doesn't — it just moves the vulnerability to the *translation between them*. The single most common failure mode in autoformalization is an agent "proving" a subtly different statement (weaker quantifier, implicit hypothesis baked into a definition, wrong side of an inequality). Since the Lean statement is the only thing the kernel enforces, **the Lean statement is the attack surface**.

Missing protocol:

- `formal_definitions.lean` gets hashed and frozen *once*, after independent review — including **back-translation**: a separate agent (ideally a different model family) translates the Lean statement back into natural language, and that back-translation is diffed against `problem_statement.tex`. Discrepancies block the run.
- Every artifact in the system (hypotheses, lemmas, consensus votes) references the frozen statement hash. Anything derived against a different statement is orphaned automatically.
- The target theorem is never considered "solved" unless the final proof's statement is *textually identical* to the frozen one — not an agent's paraphrase of it.

> **⚠ CORRECTED — Round 4 (target receipt), confirmed in Round 8.**
> Textual identity is too shallow an invariant: source text isn't the mathematical
> object, and meaning shifts through definitions, imports, notation, coercions, and
> namespace drift without a single character changing. Freeze a **target receipt**
> instead — human-problem hash + formal-source hash + pinned Lean/Mathlib environment
> + fully qualified target + a digest of the **elaborated theorem type**. Textual
> identity survives as a cheap CI tripwire; the elaborated-type digest is the real
> invariant. Round 5 notes `leanprover/comparator` already implements this check.

### 2. `verified_lemmas/` has no verification standard

The name is doing work the infrastructure isn't. Three very different things will end up in that folder: kernel-checked Lean proofs, Lean files that compile but contain `sorry`, and "Lean-flavored" files an agent claims compile. You need an explicit trust hierarchy, and it should be the backbone of the whole system:

- **L0 — Agent claim.** Markdown hypothesis. Worthless as evidence.
- **L1 — Tool-witnessed.** A SymPy computation, a Z3 "unsat", a brute-force search over cases. Useful heuristics, *not* proofs — CAS and SMT solvers have bugs and, more importantly, agents misread their outputs.
- **L2 — Certificate-backed.** The tool produced a *checkable certificate*: an SMT proof object (CVC5 `--produce-proofs`), an SAT DRAT proof, a counterexample witness plus a minimal deterministic verifier script. Certificates are checked by a small independent checker, not by the solver that produced them.
- **L3 — Kernel-verified.** Compiles under the pinned Lean toolchain, **zero `sorry`/`admit`**, and passes an axiom audit (`#print axioms` — reject anything introducing axioms beyond the sanctioned set). Dependencies also at L3.

The non-negotiable rule, which belongs verbatim in `00_CORE_DIRECTIVE.md`:

> **Trust only upgrades through deterministic checkers. Consensus votes, agent confidence, and tool outputs can gate compute allocation — they can never change an artifact's trust level.**

Your `04_MULTI_MODEL_CONSENSUS/` currently implies that a cross-model vote adds evidentiary weight. It doesn't — five models that share training data agreeing on a flawed lemma is one error, not five independent checks. Consensus is a *scheduler input*, not a proof.

### 3. No state machine, no registry, no dependency graph

`02_AGENT_SCRATCHPAD/` is three folders, and folders don't encode transitions or dependencies. In an autonomous loop this produces three failure modes: agents re-attempt already-refuted approaches (the classic retry loop), a refuted low-level lemma silently invalidates a chain of downstream "results" that nobody revisits, and the scratchpad grows into an unsearchable swamp.

You need a single **lemma registry** — SQLite or `registry.json` — that is the *only* authoritative state, with the scratchpad demoted to non-authoritative workspace:

```json
{
  "lemma_id": "sha256:4f2c...",          // content-addressed: hash of the formal statement
  "statement_ref": "verified_lemmas/4f2c.lean",
  "trust_level": 3,
  "status": "KERNEL_VERIFIED",           // CONJECTURED | TESTED | REFUTED | PARTIAL | KERNEL_VERIFIED | ABANDONED
  "depends_on": ["sha256:9a11...", "mathlib:Nat.Coprime"],
  "generated_by": {"model": "model-A-v4", "prompt_hash": "sha256:...", "timestamp": "..."},
  "evidence": [{"type": "lean_build", "toolchain": "leanprover/lean4:v4.12.0", "mathlib_commit": "abc123", "axioms": ["propext","Classical.choice","Quot.sound"]}],
  "attempt_count": 14,
  "invalidated": false
}
```

Two consequences fall out for free: refuting a lemma triggers **cascading invalidation** of everything in its downstream DAG, and content-addressed IDs mean references survive file refactors.

## Structural gaps (one layer down)

**Orchestration is entirely absent.** `config.json` mentions compute allocation, but nothing schedules work. Add a `05_ORCHESTRATION/` layer: job queue, budget ledger (tokens/wall-clock per branch, spent vs. allocated), and — critically — **termination conditions**. Autonomous math agents loop forever without: (a) a novelty cache (hash the *skeleton* of each proof attempt; N near-duplicate attempts → branch is declared exhausted), (b) diminishing-returns cutoffs, and (c) escalation triggers that halt and ask a human (budget exceeded, claimed breakthrough, M consecutive failures on all branches).

**No provenance or audit trail.** Every artifact needs generator identity (model, version, prompt hash, sampling params), and the whole system needs an append-only JSONL event log of every tool call with input/output hashes. Without it, the consensus log is unauditable and you can't debug the most interesting case: when consensus and the kernel disagree. That disagreement log is arguably the most scientifically valuable output of the entire system.

**No canary suite.** You're benchmarking agents against *open* problems, which means you have no ground truth to catch pipeline regressions. Add `06_EVALUATION/canaries/` — a set of problems with *known* solutions (reprove a mathlib lemma, refute a subtly false conjecture whose counterexample is known). If the pipeline can't recover known results, the pipeline is broken, not the problem. This is the difference between a benchmark and a slot machine. Also define the metrics that let agents self-allocate compute: formalization coverage, sorry-count, verification yield (L0→L3 conversion rate), cost per verified lemma.

**Consensus protocol needs hardening.** Blind first ballots — models must vote *before* seeing each other's outputs, otherwise you get anchoring/herding and the heterogeneity you're paying for evaporates. Weight votes by actual diversity (two checkpoints of the same model family are one vote). Preserve minority reports; in math, the dissenting vote is frequently the one that found the counterexample. And per above: consensus output is a *prioritization signal*, never a trust upgrade.

**Tool bridges are specified at the wrong level of abstraction.** "Lean 4 REPL integration" isn't a bridge; the bridge is:

- **Pinned toolchain**: `elan` + committed `lean-toolchain` + mathlib commit hash + build cache (`lake exe cache get`), or every L3 claim is unreproducible. `lake build` plus the sorry/axiom audit is the CI gate for anything entering `verified_lemmas/`.
- **Proof-state serialization**: agents need tactic-mode interaction with resumable states (LSP or a REPL that dumps/loads proof states), not fire-and-forget compile checks.
- **Certificate discipline for SMT/CAS**: run solvers in proof-producing mode and check certificates independently. For CAS, every result ships with a cheap *verifier* — differentiate the claimed integral, expand the claimed identity, evaluate the claimed counterexample. Where possible, replay into Lean (`norm_num`, `decide`, `linear_combination`; note mathlib already has a Sage bridge in `polyrith`).

> **⚠ FACTUALLY WRONG — corrected in Round 5.** `polyrith` is dead. Its external
> SageMath server was shut down and Mathlib's source now states the tactic is no
> longer supported. Use `linear_combination` (in-kernel certificate checker) or the
> newer `grobner`/`grind` tactics instead. This is the one outright factual error in
> the pre-fact-check rounds.
- **Execution sandbox**: `counterexample_searches/` will accumulate arbitrary agent-written code. Resource limits (CPU/RAM/timeout), no network egress from agent code, atomic writes (tmp-then-rename), and a single-writer/locking policy — multiple agents will otherwise corrupt shared files concurrently.

**Operational hygiene**: API keys in `config.json` is a plaintext-secrets anti-pattern — move to env/secret store. Git with a commit per state transition gives you the audit trail, rollback, and scratchpad garbage collection nearly for free.

## Revised skeleton

```
/grand-challenge-sandbox/
├── 00_CORE_DIRECTIVE.md            # + trust hierarchy, goalpost lock rules, halting conditions
├── TRUST_PROTOCOL.md               # L0–L3 definitions and upgrade gates
├── registry.json                   # single source of truth: lemma DAG, states, provenance
├── events.jsonl                    # append-only audit log of every agent/tool action
├── 01_PROBLEM_SPEC/
│   ├── problem_statement.tex
│   ├── formal_definitions.lean     # FROZEN; hash-locked after back-translation review
│   ├── statement_lock.json         # frozen hash + back-translation diff verdict
│   └── known_bounds.json           # + machine-readable schema w/ provenance fields
├── 02_AGENT_SCRATCHPAD/            # demoted: non-authoritative workspace
├── 03_TOOL_LAB/
│   ├── lean_kernel/                # + lean-toolchain, lakefile, mathlib pin, axiom-audit CI
│   ├── computer_algebra/           # every output paired with a verifier script
│   └── SAT_SMT_solvers/            # proof-producing mode + certificate checkers
├── 04_MULTI_MODEL_CONSENSUS/       # + blind-ballot protocol, diversity weights, minority reports
├── 05_ORCHESTRATION/               # job queue, budget ledger, novelty cache, escalation triggers
└── 06_EVALUATION/                  # canary suite (known-solution problems) + progress metrics
```

## Bottom line

The architecture's creative side (scratchpads, consensus, tool lab) is well-conceived; what's missing is almost entirely on the **accounting side**: provenance, trust levels, state transitions, and termination. That's the correct asymmetry for this problem — generative capability is cheap and abundant, while *knowing what you actually know* is the scarce resource. The invariant to hold: an agent can propose anything, but only deterministic checkers — a kernel, a certificate verifier, a frozen-statement hash — can promote anything. Once the registry, the trust protocol, and the statement lock exist, the rest of the folder is just plumbing.

If you want, I can materialize this as the actual scaffold — the registry schema, `TRUST_PROTOCOL.md`, the CORE_DIRECTIVE invariant list, and a stubbed orchestration loop — as a working folder you can drop agents into.



---

## Round 4 — Positioning I (the Conditioned Kernel)

*First Temple-framed response. Contributes three things that survive all later
review: the target receipt (correcting Round 3's textual identity), the
`SEARCH_POLICY_EXHAUSTED` vs `MATHEMATICAL_DIRECTION_EXHAUSTED` distinction, and
partial-progress as first-class yield. Also renames consensus → adversarial review.
The three-planes framing starts here.*

I like this a lot. More importantly, I think the **second half discovers what the project actually is**.

The first architecture says: *build a workspace where multiple AI systems can attack hard mathematics with Lean, CAS, SMT, scratchpads, and consensus.* That is sensible. The separation between informal exploration, deterministic tooling, and verified artifacts is already strong. 

But the later review finds the deeper architecture:

> **The scarce resource isn't generation. It's knowing exactly what has earned the right to be believed.**

That changes the whole project.

### I would build it — but around the trust kernel, not the agents

The L0→L3 hierarchy is probably the most important piece in the document. An intuition, a computation, a certificate, and a kernel-verified theorem are categorically different objects. Models agreeing with one another cannot move something upward through those categories. 

That gives you an extraordinarily clean invariant:

**Models allocate search. Deterministic machinery allocates truth.**

And that feels much more durable than designing around Claude/GPT/Qwen/Grok/whatever happens to be good in 2026.

In your existing architectural language, I think this is essentially a **Conditioned Kernel for mathematical research**. The LLM is the search kernel. The frozen theorem, dependency graph, resource constraints, certificate checkers, Lean kernel, and acceptance rules are the landscape it is allowed to move through. Different models can come and go without changing what constitutes an accepted result. 

### There is one important correction I would make

I agree strongly with the document's **goalpost lock**, but I wouldn't make *textual identity* the deepest invariant.

The document says the final proof statement must be textually identical to the frozen statement.  That's a useful CI guard, but source text isn't really the mathematical object.

I'd freeze a **target receipt** containing the human problem hash, formal-source hash, pinned Lean version/environment, fully qualified target, and a canonical representation/digest of the elaborated theorem type. Then acceptance checks both that the frozen source wasn't modified **and** that the theorem being proved has the expected formal type.

That protects you against the important attack: not merely changing characters, but silently changing meaning through definitions, imports, notation, coercions, namespaces, or environment drift.

The back-translation check remains excellent. But I would call it a **semantic review gate**, not proof that the translation is correct. Humans/models can misunderstand Lean too. Its function is to detect suspicious divergence before the target gets frozen.

### I would actually remove “consensus” from the architecture

Not the mechanism—the **name and authority**.

`04_MULTI_MODEL_CONSENSUS` sounds as though agreement establishes confidence. The document itself correctly realizes later that it doesn't: correlated models can confidently reproduce the same mistake, and consensus should only influence scheduling. 

I'd rename it something like:

**`04_ADVERSARIAL_REVIEW/`**

or

**`04_SEARCH_COUNCIL/`**

Its output would be things like: pursue this branch, challenge this assumption, try to falsify this lemma, formalize this next, allocate more compute here.

Never: *therefore this claim is more true.*

That distinction is beautiful because it lets you use all the strange strengths of heterogeneous models without pretending heterogeneity is a theorem prover.

### The registry should become the center of gravity

This part of the proposal is exactly right. 

I would go even further: **the filesystem should not determine state at all.**

Markdown, `.lean`, Python, solver outputs, conversations—those are artifacts.

The registry answers:

`What exists? → What does it claim? → What does it depend on? → What evidence exists? → What trust state has it earned? → What has been invalidated?`

Then the killer feature becomes **epistemic cascading**.

Suppose lemma B depends on A, C depends on B, seventeen informal hypotheses cite C, and a counterexample later refutes A.

You don't merely put `REFUTED` beside A.

The substrate immediately knows that B and C have lost their basis and every downstream artifact becomes `INVALIDATED_BY_DEPENDENCY` or equivalent. Nothing quietly survives because an agent forgot to update a Markdown file.

That is where this starts becoming something substantially different from “an AI math team.”

### I would add one concept the document hasn't pushed far enough: partial-progress acceptance

A system attacking open mathematics cannot have only two meaningful terminal states:

**SOLVED / NOT SOLVED.**

That incentive will make every planner chase the top theorem forever.

A research substrate should be able to finish a run having produced no solution and still know that something real happened: a previously plausible route was deterministically refuted; a new L3 lemma was established; a formalization ambiguity was discovered; a search region was exhaustively eliminated under stated bounds; a reusable verifier was produced; an assumption was shown necessary.

Those aren't consolation prizes. They're the actual cumulative substrate from which mathematical research grows.

So I'd make the durable unit **verified research yield**, not “grand challenge solved.”

That also gives agents something sane to optimize without pretending that arbitrary progress scores measure mathematical significance.

### Be careful with “branch exhausted”

The orchestration section correctly wants stagnation detection, novelty detection, compute budgets, and termination conditions. 

I would make one governance distinction, though:

A novelty cache may conclude:

**`SEARCH_POLICY_EXHAUSTED`**

It should almost never conclude:

**`MATHEMATICAL_DIRECTION_EXHAUSTED`**

Those are enormously different claims.

Ten thousand similar failed LLM attempts establish something about that search process. They do not ordinarily establish that no proof exists along the underlying mathematical idea.

That's exactly the kind of epistemic seam this architecture is otherwise unusually good at preserving.

### And the canaries are non-negotiable

I especially like the observation that an open problem gives you no oracle telling you whether lack of progress means *the mathematics is hard* or *your machinery is broken*. 

I would therefore make `06_EVALUATION` much more than a regression folder. It should continuously test several distinct failure surfaces: proving known true claims, refusing known false ones, finding known counterexamples, detecting subtly weakened formalizations, catching prohibited axioms/`sorry`, propagating dependency invalidation, and surviving deliberately malformed tool output.

Then when the grand-challenge agent gets nowhere for three days, you can still ask something scientifically meaningful:

**Is the instrument still calibrated?**

That question is crucial.

### The shape I see

The revised tree at the end is already considerably better than the opening tree.  But mentally I wouldn't picture it as seven directories.

I'd picture **three planes**:

**Research plane** — models hypothesize, decompose, search, calculate, criticize, and explore.

**Epistemic plane** — statement lock, registry/DAG, provenance, L0–L3 promotion, invalidation, certificates, Lean kernel.

**Control plane** — orchestration, compute allocation, stagnation detection, human gates, canaries, reproducibility.

The first plane can be wildly generative.

The second should be almost boring.

The third keeps the first from consuming the universe.

And **only the second plane gets to say what is known.**

That, to me, is the architecture.

I wouldn't position this as “16 agents trying to solve Millennium problems.” That's flashy but undersells what you've got.

I'd position it more like:

**A model-agnostic research substrate in which conjecture generation is cheap, verification is deterministic, epistemic state is explicit, and partial mathematical progress survives the model that discovered it.**

That is much more interesting.

And there is a very Temple-shaped principle underneath it: **wonder gets an enormous playground, but rigor controls the gate.**




---

## Round 5 — Tooling fact-check (August 2026)

*The empirical section, and the only one with citations. Everything before this is
architecture reasoned from first principles; this is what actually exists, what it
costs, and what is already dead. Contains the October 2025 Erdős episode — the
cautionary tale the whole novelty-gate design answers to. **Dates matter here: all
figures are as of mid-2026 and this field moves monthly.***

# AI Tooling and Track Record for a Multi-Agent Lean 4 Mathematical Research Workspace: A Landscape and Fact-Check (August 2026)

## TL;DR
- **Most of the workspace's plumbing already exists as maintained open-source tooling** — Lean REPL interaction (lean-interact, Pantograph, LeanDojo-v2), autoformalization/prover models (Goedel-Prover-V2 is Apache-2.0 and consumer-runnable), SMT/SAT certificate checkers (lean-smt, Carcara, cake_lpr), and adversarial-grade proof auditing (leanprover/comparator + lean4checker). A solo operator should integrate these, not rebuild them.
- **On genuinely open problems, verified AI wins are real but narrow and concentrated at the "low-hanging fruit" end**: FunSearch/AlphaEvolve improved *bounds/constructions* on extremal problems; the Erdős surge since October 2025 has been mostly literature rediscovery plus a handful of genuine autonomous resolutions (e.g. #728, Jan 2026) — the true novel-solution rate is a point or two of the database, per Terence Tao.
- **The October 2025 "GPT-5 solved 10 Erdős problems" episode was a misrepresentation**: the model surfaced existing (forgotten) literature. Bloom's verbatim correction: *"this is a dramatic misrepresentation. GPT-5 found references, which solved these problems, that I personally was unaware of."* The OpenAI post was deleted and Hassabis called it "embarrassing." This is the central cautionary tale your consensus/provenance layer must design against.

## Key Findings

1. **Do not build your own Lean interaction layer, prover, or proof checker.** Every one of those is a solved, actively maintained problem with permissively licensed options. Your differentiated value is the orchestration, provenance, and hardened-consensus layer — exactly the part prior reviews flagged.
2. **The single most important empirical lesson for your design is the literature-contamination failure mode.** The biggest public embarrassments (Oct 2025 GPT-5) came from claiming novelty when the result already existed. Your L0–L3 trust levels and provenance event logs should treat "novelty check against the literature" as a first-class, mandatory gate, using arXiv/zbMATH/OEIS APIs.
3. **Formal verification (Lean) is the community's accepted defense against hallucinated proofs**, but the trusted base has real holes (`native_decide`/`reduceBool`/`csimp` axiom leakage, and a 2025 kernel projection soundness bug). `#print axioms` + `lean4checker` in CI is the baseline; `leanprover/comparator` is the escalated defense for untrusted/AI-generated proofs.
4. **`polyrith` is effectively dead** (its Sage server was shut down); use `linear_combination`, the newer `grobner`/`grind` tactics, or `lean-smt`. This directly affects your 03_TOOL_LAB design.
5. **Cost reality: a solo operator can meaningfully run agentic proof search at ~$0.5–$5 per theorem** with API models plus open provers, but cannot replicate AlphaProof-class test-time RL (thousands of TPU-minutes/problem). Target the long tail, not marquee problems.

## Details

### 1. Existing systems (as of mid-2026)

**Lean 4 agent / interaction tooling.**
- **Official Lean REPL** (`leanprover/repl`) — the canonical machine-to-machine REPL; foundation for most Python wrappers.
- **lean-interact** (Auguste Poiroux, EPFL) — MIT-licensed Python interface over the Lean REPL; supports Lean v4.8.0-rc1 through v4.32.0-rc1, backporting REPL features to older versions. Actively maintained; `AutoLeanServer` handles timeout/OOM recovery. **Best default for a solo operator.**
- **Pantograph / PyPantograph** (Stanford Centaur; TACAS 2025, May 2025) — written entirely in Lean 4, no Docker dependency; exposes proof-state tree/expression construction for MCTS-style search. Mirror at `leanprover/Pantograph`.
- **LeanDojo / LeanDojo-v2** (MIT) — repository tracing + dataset extraction + retrieval-augmented agents; LeanDojo-v2 absorbs the **LeanAgent** lifelong-learning pipeline and drives Pantograph-based provers (NeurIPS MATH-AI 2025). Heavier; better for training pipelines than interactive solo use.
- **AXLE** (Axiom Math) — a hosted multi-tenant service (14 Lean metaprogramming tools: strict verification, proof repair/simplification, lemma extraction), multi-version, with Python SDK/CLI/MCP server/HTTP API, free at axle.axiommath.ai. Useful as a managed backend but not self-hostable.

**Theorem-proving model families** (status mid-2026):
- **DeepSeek-Prover-V2** (Apr 30, 2025): 671B (MoE, 88.9% MiniF2F-test, 49/658 PutnamBench) and 7B. Code MIT; **weights under the custom DeepSeek Model License, not MIT** (a common secondary-source error). 7B is consumer-runnable; 671B is not.
- **Goedel-Prover-V2** (Princeton et al., Jul–Aug 2025): **Apache-2.0**, weights open (32B flagship, 8B). The 8B reportedly matches DeepSeek-Prover-V2-671B at Pass@32 on MiniF2F at ~100× smaller. **The most consumer-friendly SOTA open family — recommend as your default local prover.**
- **Kimina-Prover** (Numina + Moonshot): **MIT**; 72B flagship (needs ~8 GPUs) plus distilled 0.6B/1.5B/1.7B/7B that a solo operator can run.
- **Leanabell-Prover-V2** (Jul 2025): 7B, verifier-integrated RL, 78.2% MiniF2F Pass@128.
- **Numina-Lean-Agent** (arXiv 2601.14027, Jan 20 2026): an *agentic system* (Claude Code + Numina-Lean-MCP), not open weights; solved 12/12 Putnam 2025. Agent code open; requires paid Claude API.
- **AlphaProof** (DeepMind, Nature, 2025): IMO 2024 silver (28/42); closed. Not usable by solo operators; benchmark-relevant only.
- **Commercial autoformalization/prover systems**: **Harmonic's Aristotle** (Lean 4, IMO 2025 gold, 5/6 formally verified; public API + $1M research grant program — realistically accessible to a solo researcher via API/grant); **Math Inc's Gauss** (autoformalization agent; formalized the strong Prime Number Theorem in 3 weeks vs 18+ months of stalled human effort, on **Trinity/Morph Cloud** infrastructure; beta/early-access); **Axiom Math / AxiomProver** (12/12 Putnam; has formalized Erdős solutions); **Seed-Prover** (ByteDance, IMO 2025 5/6).

**DeepMind formal-conjectures repo** (`google-deepmind/formal-conjectures`): **Apache-2.0**, actively developed (PRs through late Nov 2025 and into 2026). A Lean 4 + Mathlib collection of *formalized conjecture statements* (many Erdős problems), tracking monthly tagged Mathlib releases (not master). Uses `@[category]`, `@[formal_proof]`, `@[AMS]` attributes. **This is the closest thing to your `01_PROBLEM_SPEC` layer already built — adopt it directly** rather than re-formalizing statements. It also anchors the "Formal Conjectures" benchmark (arXiv 2605.13171) and a distinguished FC100 open-problem subset.

**Orchestration frameworks**: There is no dominant purpose-built "math research agent" orchestrator; practitioners assemble general agent frameworks (LangGraph, CrewAI, AutoGen→Microsoft Agent Framework, OpenAI Agents SDK) plus Lean MCP servers. Numina-Lean-MCP (orchestrating Lean-LSP-MCP, LeanDex retrieval, informal prover, discussion partner) is the closest domain-specific published pattern.

### 2. Track record on genuinely open problems

**Improved bounds / constructions (real, verifiable, but not "proofs of conjectures"):**
- **FunSearch** (Nature, Dec 2023): first LLM-driven discovery on an open problem — new cap-set constructions (size-512 cap set in dimension 8; improved asymptotic lower bound via admissible sets) and improved online bin-packing heuristics. Compute was substantial (cap-set: ~140 runs × 15 A100s × 2 days).
- **AlphaEvolve** (DeepMind, May 2025): tested on "over 50 open problems"; "in 20% of cases... improved the previously best known solutions." Its headline geometry result raised the lower bound on the kissing number in 11 dimensions from 592 to 593 (593-sphere configuration; upper bound still 868). **Both AI records were quickly beaten by humans/other systems**: Robert Gerbicz (arXiv 2505.16105, May 22 2025) beat AlphaEvolve's sum-and-difference-set bound (θ=1.1584 → 1.173050) within days; and the kissing-number-11 bound was subsequently pushed further (Aalto's Ganzhinov to 592/1932 in dims 11/14; multi-agent search to 594 then 604 per arXiv 2606.10402). This is a core caution: AI "records" on construction problems are often ephemeral.
- **Successors**: ShinkaEvolve, OpenEvolve, and **ThetaEvolve** (arXiv 2511.23473, Nov 2025) — an 8B open model beat best-known bounds on circle packing and the first autocorrelation inequality. LLM evolutionary search also reportedly tightened Ramsey numbers R(3,17)/R(4,15) and Zarankiewicz numbers (arXiv 2605.01120). These are *constructions/bounds*, not resolved conjectures.

**The Erdős database and the October 2025 episode:**
- **erdosproblems.com** (Thomas Bloom, launched 2023). As of this report's date the homepage states: *"There are 1217 problems in the database of which 565 (46%) have been solved."* (The ~1,105-total / 685-open figure was the Oct 31, 2025 snapshot cited in "Early science acceleration experiments with GPT-5," arXiv 2511.16072.) Crucially, "open" only means no professional has found a *published* solution — a key epistemic caveat baked into the database. Only ~100 problems are known to carry monetary prizes (historically ~$25–$1000; prize levels are an informal, weak difficulty proxy).
- **October 2025 GPT-5 episode**: OpenAI's Kevin Weil posted (later deleted): *"GPT-5 found solutions to 10 (!) previously unsolved Erdős problems and made progress on 11 others."* Mark Sellke listed the ten (then marked open): **#223, 339, 494, 515, 621, 822, 883, 903, 1043, 1079**, plus partial progress on eleven more. Bloom's correction (X/@thomasfbloom, Oct 18 2025): *"this is a dramatic misrepresentation. GPT-5 found references, which solved these problems, that I personally was unaware of. The 'open' status only means I personally am unaware of a paper which solves it."* Demis Hassabis (X, Oct 18 2025): *"this is embarrassing."* Sebastien Bubeck, who had made a parallel claim, retracted, conceding only solutions already in the literature were found. Additional confirmed literature-rediscovery cases: #367, #124, #481, #333, #897.
- **What changed in late 2025 / 2026 (genuine progress):** Since October, AI tools helped move ~100 Erdős problems to "solved," mostly souped-up literature search, but with a growing minority of genuine contributions. Milestones: Mehtaab Sawhney's #339 (literature); **#728 solved "more or less autonomously"** (GPT-5.2 Pro informal argument → Aristotle Lean proof; Jan 2026; no prior literature found, Tao vouched for autonomy); three Erdős problems fell to AI-assisted constructions in one week of late 2025, each verified by Tao; **#126** (Dec 8 2025, Aristotle, later understood as likely in prior literature); **#1196** (GPT-5.4 Pro, Apr 2026, primitive sets). **Distinguish carefully**: (a) literature rediscovery (most), (b) improved bounds/constructions, (c) genuine autonomous resolution (rare, e.g. #728).
- **Terence Tao's synthesis** (Mathstodon, late 2025–early 2026): AI is "picking off the lowest-hanging fruit" — problems "amenable to simple proofs using fairly standard techniques," which is *also* the category most likely already solved in obscure literature. He warns of strong reporting bias (failures unreported), estimates the true novel-success rate at only a point or two of the database, and calls for standardized reliability/efficiency benchmarks (measuring reliability and efficiency per unit of cognitive labor).

**Other 2025–26 results**: an OpenAI reasoning model beat the conjectured grid optimum for the 1946 Erdős planar unit-distance problem; the Equational Theories Project (Tao-led, collaborative human+AI+Lean) resolved large swaths of 22M implications.

### 3. Tooling fact-check

**a. polyrith — CONFIRMED dead/network-dependent.** Historically `polyrith` called an external SageMath server via Python (required internet). That Sage server was shut down; Mathlib's current source states: *"The `polyrith` tactic is no longer supported in Mathlib, because it relied on a defunct external service."* **Network-free alternatives**: `linear_combination` (a certificate checker — you supply coefficients; fully in-kernel), and the newer `grobner` tactic (calls the Gröbner-basis module of `grind`) which can close polynomial goals but does not emit a `linear_combination` suggestion. Use these.

**b. Soundness auditing — CONFIRMED, with nuance.**
- `#print axioms foo` reports the axioms a declaration depends on; the three standard Mathlib axioms are `propext`, `Classical.choice`, `Quot.sound`. `sorry` shows up as `sorryAx`.
- **Known leakage holes**: `native_decide`/`reduceBool` (adds `Lean.ofReduceBool` and expands the trusted base to every `implemented_by`, expected possibly inconsistent), and `@[csimp]` can smuggle axioms/`unsafe` without being reported (lean4 issue #7463). A 2025 kernel bug (#14576) accepted wrong-structure projections, enabling an *axiom-free* proof of `False` — so `#print axioms` alone is necessary but not sufficient.
- **`lean4checker`** (`leanprover/lean4checker`): replays declarations through the Lean kernel from `.olean`s to detect environment hacking/metaprogramming attacks; run via `lake exe lean4checker`. It does not itself report axioms and doesn't support `reduceBool`. **Mathlib CI runs lean4checker** (exposed via the `lean-action` GitHub Action with `lean4checker: true`); a full Mathlib replay takes ~20 min. Best practice for your CI: sorry-detection + `#print axioms` gate against an allowlist + `lean4checker` + ban `native_decide` in trusted proofs.
- **`leanprover/comparator`** (Apache-2.0, Lean FRO): the "gold standard" for judging *untrusted/AI-generated* proofs. Given a trusted `Challenge.lean` (statement with `sorry`) and untrusted `Solution.lean`, it guarantees the solution proves the *same* statement, uses no axioms beyond an allowlist (default `propext`, `Quot.sound`, `Classical.choice`), and is kernel-accepted — building inside a `landrun` sandbox, exporting via `lean4export`, and optionally cross-checking with the independent Rust `nanoda` kernel. This is essentially a ready-made implementation of your "statement hash-locking with back-translation" + hardened verification recommendation. `comparator-live` is an online playground; OpenAI's ten-proofs uses it. (It is heavier/slower than lean4checker by design; a competing tool, AXLE's verify_proof, benchmarks ~99× faster at median precisely because comparator does per-request sandboxing.)

**c. SMT/SAT certificate checking — practical today:**
- **SAT (most mature)**: DRAT/LRAT proofs from modern solvers, checked by `drat-trim` or the **CakeML-verified `cake_lpr`** (LPR format, backwards-compatible with LRAT, machine-code-level correctness guarantee). Mathlib has an `lrat_proof` command that builds a kernel-checkable term (memory-bounded on large instances). LRAT-Catcher (arXiv 2607.00815) imports certificates by reflection; the Empty Hexagon development used the assert-as-axiom pattern with cake_lpr. **Verdict: SAT certificate checking is practical for an independent checker today; `cake_lpr` is the strongest.**
- **SMT**: cvc5 `--produce-proofs --proof-format=alethe` emits **Alethe**; **Carcara** (Rust, TACAS 2023) is an independent Alethe checker/elaborator. Coverage caveats: cvc5's Alethe production is still partial (mostly UF, parts of arithmetic/quantifiers) and requires flags (`--dag-thresh=0`, `--proof-granularity=theory-rewrite`); some Alethe proofs fail to check. cvc5 also emits CPC (Cooperating Proof Calculus), checkable by the Ethos checker. **Verdict: usable but rougher than SAT; expect coverage gaps.**
- **Lean-native**: `lean-smt` (CAV 2025, ufmg-smite) replays cvc5's CPC proofs into the Lean kernel — verified ~71% of a proof set using only the kernel; competitive with Isabelle Sledgehammer+veriT while keeping a minimal trusted base. This is the tool for kernel-checkable SMT results.

**d. Version pinning & cache — CONFIRMED best practice:** Lean and Mathlib move in lockstep; a Mathlib revision only builds against its matching Lean. Pin `lean-toolchain` to a specific version (copy Mathlib's), require Mathlib by a **commit/tag, not `main`**, and run **`lake exe cache get`** to download prebuilt `.olean`s (rebuilding Mathlib locally is hours). To update: overwrite `lean-toolchain` from Mathlib's, then `lake update` (which pulls the matching cache), then `lake exe mk_all && lake build`. Drift symptom: "hundreds of errors in library code" means toolchain/Mathlib mismatch. Cache lives in `~/.cache/mathlib` and `.lake/`; `git worktree` or `lake exe cache get!` handle multi-version/corruption. **Your config.json should pin exact Lean+Mathlib commit hashes; the formal-conjectures repo's practice of tracking monthly Mathlib releases is a good model.**

**e. Lean-native CAS/SMT bridges producing kernel-checkable results:** `lean-smt` (above) is the main SMT bridge. For CAS, the **Lean⇆Mathematica bridge** (Robert Lewis) allows sending terms to a CAS and verifying the returned result with Lean tactics, with selectable trust levels (full certification / untrusted oracle / axiomatization). `polyrith`'s Sage bridge is defunct. Net: kernel-checkable CAS/SMT bridges exist but are narrow; treat CAS output as an untrusted oracle to be re-verified in-kernel.

### 4. Problem selection / triage

There is **no prominent dedicated published framework** specifying which open problems are AI/formal-tractable (finite search space, decidable fragments, small statement size). This is a genuine gap. What exists:
- **erdosproblems.com has NO numeric difficulty rating** — only a topic-based **tag system** (explicitly "a work in progress," not difficulty), and binary open/solved status. Erdős's original cash-prize values (~$25–$1000, only ~100 problems) serve as an informal, weak difficulty proxy.
- **Tao's informal criteria** (Mathstodon, late 2025) are the best available guidance: tractable = "amenable to simple proofs using fairly standard techniques" + neglected (few experts tried); the "long tail" of under-examined problems, not marquee problems. Corollary warning: that same class is the one most likely already solved in obscure literature — so **a literature-novelty check is inseparable from tractability triage**.
- Adjacent published work: DeepMind's **Formal Conjectures** repo/benchmark (curation, not triage criteria); **LeanMarathon** (arXiv 2606.05400) reports DeepMind found only **6.5% of 200 candidate AI solutions "meaningfully correct"** — motivating formalization as the decisive filter; "Early science acceleration with GPT-5" (arXiv 2511.16072). The teorth/erdosproblems wiki explicitly warns it is "not a finely calibrated benchmark" and that absence of past progress may reflect obscurity rather than difficulty.

### 5. Literature retrieval for math (for your novelty gate)

- **arXiv API** — free; OAI-PMH metadata harvesting + query API; the largest open math corpus (full-text preprints).
- **zbMATH Open API** — free/open since 2021; REST + OAI-PMH endpoints; >4M bibliographic/review records, MSC classification, ~250k arXiv links; the successor to closed zbMATH. **The best structured math-literature API for an agent.**
- **MathSciNet** (AMS) — comprehensive but subscription/paywalled; not freely API-accessible for a solo operator.
- **Semantic Scholar API**, **OpenAlex**, and **OEIS** (integer-sequence lookup — heavily used in the Erdős/formal-conjectures workflow to check whether a sequence/construction is known) round out a practical free stack.
- Semantic/formula search (ARQMath, MathBERT, zbMATH formula index) exists but is research-grade, not a turnkey API. **Recommendation**: build the novelty gate on arXiv + zbMATH Open + OEIS + Semantic Scholar, and log every hit into your provenance event log.

### 6. Cost and scale reality

- **AlphaProof-class is out of reach**: to go from 33.2%→58.3% on the IMO holdout, AlphaProof needed a ~4-order-of-magnitude compute increase; the last 4.4 points required going from 3,000 to 30,000 TPU-minutes *per problem*, and top solutions needed 2–3 days of test-time RL each. The Formal Conjectures benchmark ran AlphaProof at ~0.1 TPU-hour (1k sims) to ~1.6 TPU-hour (16k sims) per problem *without* TTRL.
- **Agentic proof search with API models is affordable**: VERITAS (arXiv 2606.19399) reports **~$0.52 per theorem on miniF2F (~$126 per 244-theorem sweep)** and ~$0.83/theorem on harder CombiBench; an agentic autoformalization framework reports **~$5 per problem** on PutnamBench. DeepMind's Erdős-problem agent runs were single-digit-to-tens of dollars per problem, with AlphaProof adding ~$60/problem when used.
- **Open provers on consumer hardware**: Goedel-Prover-V2-8B and Kimina distilled (1.5–7B) run on a single high-VRAM consumer GPU; 32B needs a prosumer GPU or quantization. FunSearch/AlphaEvolve-style evolutionary search is feasible with an 8B open model (ThetaEvolve).
- **Realistic solo-operator envelope**: literature-augmented + formal-verification workflows on the long tail, budgeting roughly **$0.50–$5 per theorem attempt** with API models plus a local open prover, sample counts in the tens-to-hundreds (pass@32–pass@128), wall-clock dominated by Lean compilation (which is $0 API cost). You cannot brute-force marquee problems.

## Recommendations

**Stage 1 — Assemble, don't build (week 1–2).**
- Interaction layer: **lean-interact** (MIT) as primary; Pantograph if you need proof-state tree search.
- Problem spec: adopt **google-deepmind/formal-conjectures** (Apache-2.0) directly for `01_PROBLEM_SPEC`; pin your `lean-toolchain` and Mathlib to exact commit hashes in `config.json`, mirroring its monthly-release tracking.
- Local prover: **Goedel-Prover-V2-8B/32B** (Apache-2.0). Add **Aristotle API** (apply for the $1M grant program) and a frontier API model for informal reasoning.

**Stage 2 — Make verification and novelty first-class (week 3–4).**
- CI gate: sorry-detection + `#print axioms` against an allowlist + **`lean4checker`** (as Mathlib does) + ban `native_decide`/`reduceBool` in trusted lemmas.
- For any AI-generated proof, run **`leanprover/comparator`** — it already implements your statement hash-locking + hardened verification recommendation (sandbox, statement-equivalence, axiom allowlist, multi-kernel replay).
- Build the **literature-novelty gate** (arXiv + zbMATH Open + OEIS + Semantic Scholar) and make "passed novelty check" a required transition from trust level L2→L3. This is the single highest-value defense against the October-2025 failure mode.
- SMT/SAT: use **lean-smt** (kernel-checkable SMT) and **cake_lpr** (SAT) as your 03_TOOL_LAB certificate checkers; drop `polyrith` in favor of `linear_combination`/`grobner`.

**Stage 3 — Target and measure (ongoing).**
- Attack the **long tail**: small-statement, standard-technique, neglected problems (Tao's criterion), *after* the novelty gate clears them. Prefer problems with finite/decidable search components where SAT/SMT certificates apply.
- Instrument cost per attempt and solve-rate; expect **$0.5–$5/theorem**. Log everything to the provenance event log.

**Benchmarks/thresholds that should change your plan:**
- If your novelty gate is catching >50% of "solved" candidates as prior literature, that's expected (matches the field, and matches DeepMind's 6.5%-meaningfully-correct rate) — keep the gate; don't loosen it.
- If Goedel/Kimina open weights stop tracking your Mathlib version, pin to the last compatible pair rather than chasing `main`.
- If a genuinely autonomous result clears comparator *and* the novelty gate, treat it as publishable (the #728 bar) — and get a human mathematician to vouch, as community consensus still requires.

## Caveats
- **Fast-moving field; dates matter.** Model SOTA (Goedel/DeepSeek/Kimina versions) and Erdős-problem status change monthly; treat every specific number as of its cited date (mid-2026). The erdosproblems.com totals cited (1217 problems / 565 solved as of this report; 1,105/685-open as of Oct 31 2025) illustrate how fast the denominator moves.
- **Reporting bias is severe.** Public AI-math claims skew positive; failures are rarely reported. Tao's "point or two" true-success estimate is the sober anchor.
- **"Solved" is contested.** For Erdős problems, distinguish literature rediscovery vs improved bounds vs genuine resolution — sources conflate these constantly. Several 2025–26 "AI solved" claims were later found in prior literature (#126 likely; #367/#124/#481/#333/#897 confirmed). AI construction "records" (kissing number, sum/difference sets) were beaten within days-to-months by humans or other systems.
- **Formal verification is strong but not absolute.** Kernel/axiom-leakage holes (`native_decide`, `csimp`, the 2025 projection bug #14576) mean "Lean-checked" requires the full audit stack, not just a green build.
- **License nuance**: DeepSeek-Prover-V2 *weights* are under the custom DeepSeek Model License, not MIT (code is MIT) — verify before any commercial or redistribution use. Goedel (Apache-2.0) and Kimina (MIT) are cleaner for a solo operator.
- **Commercial systems are partly opaque**: Aristotle, Gauss, AxiomProver, AlphaProof compute budgets and full methods are not fully disclosed; treat their headline results as vendor-reported unless independently verified (as Tao did for #728).





---

## Round 6 — Synthesis and buildable blueprint

*Merges rounds 1–5 into a revised folder tree, a gap→solution table, and a
three-week checklist. The most directly actionable section in the document — but
note its one error, flagged below: it makes the novelty gate a required L2→L3
transition, which Round 8 correctly overturns.*

This latest fact-check is the missing piece that transforms the theoretical architecture into a buildable system. It confirms which parts of the earlier reviews were already solved problems (Lean interaction layers, proof checkers, certified SAT), which were brittle (polyrith, SMT certificate coverage, kernel soundness), and which were absent (literature-novelty gate, cost modeling, problem triage). I’ll now integrate everything—the original proposal, the two reviews, and the tooling landscape—into a concrete, updated blueprint for a solo-operator‑ready autonomous mathematical research workspace.

### What changes based on the tooling report

**1. Do not build Lean interaction, Lean checkers, or basic provers.**  
The report names five viable, permissively licensed tools that already handle proof-state interaction, kernel checking, and adversarial proof auditing. Adopting them is far faster and more robust than building from scratch. Specifically:

- **Proof interaction:** Use **lean-interact** (MIT) as the primary Python bridge to the Lean REPL; switch to **Pantograph** only if you need tree-search over proof states.
- **Hardened verification:** Adopt **leanprover/comparator** (Apache‑2.0) for the statement‑lock + axiom‑check + multi‑kernel replay. This directly implements the “frozen target receipt” and back‑translation guard the second review demanded. Run it in CI on every proof that claims L3 trust.
- **Lightweight continuous checking:** Add **lean4checker** + `#print axioms` to your CI pipeline (as Mathlib does) for routine commits. Ban `native_decide` and `reduceBool` in trusted lemmas until the kernel‑soundness holes are resolved.
- **SAT certificates:** Use **cake_lpr** (independently verified LPR checker); **SMT certificates:** prefer **lean‑smt** where possible (kernel‑checked CPC proofs) and use cvc5 Alethe proofs + Carcara as a fallback, noting the coverage gaps.

**2. Drop polyrith and fix your CAS/SMT toolchain.**  
The report confirms that `polyrith`’s Sage server is dead. Replace it with:

- `linear_combination` for simple polynomial identities.
- `grobner` or `grind` for polynomial ideals.
- For external CAS results, treat them as untrusted oracles and re‑verify inside Lean using `norm_num`, `dec_trivial`, `linear_combination`, or the Lean⇆Mathematica bridge (if Mathematica is available).

**3. The problem‑spec layer already exists: adopt `formal-conjectures`.**  
Google DeepMind’s `formal-conjectures` repository is exactly the `01_PROBLEM_SPEC` directory we wanted, already populated with formalized Erdős problem statements, tagged with categories and status. It tracks monthly Mathlib releases. Fork it, pin your `lean-toolchain` and Mathlib commit to exact hashes, and you instantly have a living library of targets. This saves weeks of error‑prone manual formalization.

**4. Novelty gate is now mandatory—because the October 2025 debacle proved it’s the main failure mode.**  
The report’s account of “GPT-5 solved 10 Erdős problems” being almost entirely literature rediscovery is exactly what a provenance‑first architecture must prevent. The earlier reviews rightly insisted on provenance and state management; we now know the concrete implementation: a **literature‑novelty check** that queries arXiv, zbMATH Open, OEIS, and Semantic Scholar before any claim is promoted beyond L1.  
Any lemma or solution that passes verification must also pass this check, and the check’s output must be logged immutably.

> **⚠ SUPERSEDED — Round 8 (orthogonal axes).**
> Making novelty a required transition into L3 is a category error: validity and
> novelty are orthogonal epistemic dimensions. A kernel-verified proof of a
> *known* theorem is maximally trusted and zero-novelty — both facts are true and
> neither should contaminate the other. Correct design: the novelty axis (N0
> unchecked → N1 automated-clear → N2 human-vouched, plus `N-FLAGGED` for prior-art
> hits) never gates verification promotion. It gates **publication claims only**.
> Round 9 adds a further caution: "N1 automated-clear" is a search-quality claim
> wearing a truth-claim costume — log the exact queries so a later miss is
> diagnosable, and for Erdős targets check erdosproblems.com and its git history
> before keyword-searching arXiv.

If >50% of “new” results are flagged as prior art, that’s normal—it’s a sign the gate is working, not that the problem is too easy.

**5. Target the long tail, not the marquee problems.**  
Tao’s criterion (simple proofs, standard techniques, neglected problems) and the cost analysis ($0.5–$5 per theorem attempt with API agents, open‑weight provers like Goedel‑Prover‑V2‑8B, or Aristotle API) make a solo‑operator research program realistic. The workflow becomes:  
   a) Triage problems via the formal‑conjectures repo + novelty check.  
   b) Attack with a mixture of informal reasoning (frontier model), Goedel‑Kimina local provers, and Aristotle API.  
   c) Formalize the proof in Lean, run comparator + novelty gate, and if both pass, file a paper or update the repository.

**6. Consensus becomes a scheduling tool, not a trust layer.**  
The second review’s suggestion to rename the consensus module to `04_ADVERSARIAL_REVIEW` is now clearly correct. The October 2025 event showed that multiple models can confidently agree on a wrong, but literature‑existable, solution. Use heterogeneous votes only to decide **where to allocate compute next**—never to raise trust levels. The trust levels (L0–L3) remain exclusively gated by deterministic checkers.

### Updated recommended folder structure

This integrates the earlier “three planes” philosophy with the concrete tooling:

```
/grand-challenge-sandbox/
├── 00_DIRECTIVES/
│   ├── CORE_DIRECTIVE.md         # Trust hierarchy, goalpost lock, halting policies
│   ├── TRUST_PROTOCOL.md         # L0–L3 definitions and upgrade gates
│   └── novelty_gate.yaml         # API endpoints, thresholds, logging spec
├── config.json                    # Pinned Lean/Mathlib hashes, API keys (from env), tool versions
├── registry.json                  # Lemma DAG, trust states, provenance, invalidation
├── events.jsonl                   # Append‑only log of every agent/tool action
├── 01_PROBLEM_SPEC/
│   ├── formal_conjectures/        # Fork of google-deepmind/formal-conjectures, pinned
│   ├── targets.json              # Subset of targets we are currently attacking
│   └── statement_locks/          # Hashes + back‑translation verdicts (comparator)
├── 02_RESEARCH_PLANE/
│   ├── informal_hypotheses/      # Unstructured markdown (L0)
│   ├── counterexample_searches/  # Agent‑written Python with sandbox & verifier scripts
│   └── verified_lemmas/          # Only L3 artifacts after comparator
├── 03_TOOL_LAB/
│   ├── lean_kernel/              # Lake project, lean‑toolchain, pinned Mathlib
│   ├── lean_interact/            # Pre‑built lean‑interact server config
│   ├── comparator/               # CI script calling leanprover/comparator
│   ├── smt_sat/                  # lean‑smt, cvc5 proof‑producing mode, cake_lpr
│   └── cas/                      # linear_combination/grobner scripts, Mathematica bridge (if available)
├── 04_ADVERSARIAL_REVIEW/
│   ├── review_protocol.yaml      # Blind‑ballot rules, diversity weighting, minority report preservation
│   └── scheduling_decisions.json # Output: which branch to pursue, which to challenge
├── 05_ORCHESTRATION/
│   ├── job_queue/                # SQLite/Redis‑backed queue with budget ledger
│   ├── novelty_cache/            # Hashes of attempted proof skeletons
│   └── escalation_triggers.yaml
└── 06_EVALUATION/
    ├── canaries/                 # Known‑solution problems to validate pipeline
    └── metrics_dashboard/        # Cost, sorry‑count, L0→L3 conversion rate
```

### The missing pieces that the earlier reviews identified—now filled with real tools

| Gap from earlier reviews           | Concrete solution from the fact‑check                                          |
|------------------------------------|-------------------------------------------------------------------------------|
| **Goalpost lock**                  | `leanprover/comparator` with frozen `Challenge.lean` + statement‑equivalence check + back‑translation. |
| **Trust hierarchy & cascade**      | L0–L3 levels implemented via registry; invalidations propagate automatically when a dependency fails comparator. |
| **Lean interaction bridge**        | `lean-interact` (or Pantograph) as the canonical Python→Lean REPL.             |
| **Hardened verification**          | `lean4checker` + `#print axioms` + comparator + ban `native_decide`.           |
| **Literature novelty gate**        | arXiv, zbMATH Open, OEIS, Semantic Scholar queries mandated before L2→L3.      |
| **Dead tool (polyrith)**           | Replaced by `linear_combination`, `grobner`, and kernel‑re‑check of CAS output.|
| **Problem‑spec curator**           | `formal-conjectures` repo replaces hand‑written formal definitions.            |
| **Canary suite**                   | Known‑solution problems (e.g., mathlib lemmas) with full regression tests.     |
| **Orchestration / state machine**  | Job queue + registry + event log; novelty cache prevents retry loops.          |
| **Cost model**                     | $0.5–$5/theorem; track token & CPU budgets per branch.                         |

### Production‑readiness checklist

- [ ] **Week 1:** Fork `google-deepmind/formal-conjectures`. Pin Lean v4.32.0-rc1 (or latest stable) and matching Mathlib commit. Set up `lake exe cache get`.
- [ ] **Week 1:** Install `lean-interact`, `lean4checker`, and `comparator`. Write CI that runs comparator on any claimed L3 proof.
- [ ] **Week 1:** Implement the L0–L3 trust protocol as JSON schema and hook it into the registry. Every tool invocation must annotate the event log with a trust level.
- [ ] **Week 2:** Build the literature‑novelty microservice (arXiv, zbMATH, OEIS, Semantic Scholar). Block any L3 promotion if a match is found.
- [ ] **Week 2:** Set up the adversarial review module—blind balloting, diversity weighting, output only scheduling directives.
- [ ] **Week 2:** Integrate Goedel‑Prover‑V2‑8B (local) and Aristotle API (apply for the $1M grant). Use a frontier API model (Claude, GPT-5.x) for informal reasoning.
- [ ] **Week 3:** Populate the canary suite with 10–20 mathlib lemmas of varying difficulty. Run daily regression to catch pipeline decay.
- [ ] **Week 3:** Attack the long tail—pick 3–5 neglected Erdős problems that pass the novelty check and have small statement size. Monitor cost per verified lemma. Expect many rediscoveries; treat them as calibration.

### Final answer to the original question

The workspace framework **as originally proposed** missed the rigorous state management, trust levels, novelty checks, and concrete tool integrations necessary for autonomous research. The two earlier reviews correctly diagnosed these gaps, and the August 2026 tooling report now provides the exact open‑source implementations that fill them. The result is an architecture centered on a **trust registry**, guarded by **deterministic checkers** and a **literature‑novelty gate**, using existing, permissively licensed tools for every technical component. With this blueprint, a solo operator can launch a mathematically meaningful, auditable, and self‑improving research assistant that spends most of its effort on the genuinely unattempted long tail of Erdős‑type problems—and never mistakes a literature rediscovery for a breakthrough.



---

## Round 7 — Positioning II (Temple differentiation)

*Two essays, back to back. The first argues the Temple differentiation; the second
pushes it further and contributes the document's two best technical ideas — the
epistemic state vector and acceptance invariance. Round 8 scores these highly.
Round 9 cautions that the apparent convergence here may be an artifact of shared
context rather than independent validation — read both critiques before treating
this section as settled.*

**Temple of Two differentiates the lab by treating mathematical research as a relational, epistemic substrate rather than a competitive race to claim solutions.**

Most current systems—AlphaProof-class RL provers, commercial autoformalizers, multi-agent Lean scaffolds, and even strong academic agent teams—are optimized for the same underlying objective: maximize verified theorems under a fixed time/compute budget. They improve search, decomposition, repair loops, and tool use. That is valuable engineering. It is not a distinctive research identity.

Temple of Two starts from a different premise that the architecture already encodes:

> Generation is abundant. The scarce, durable resource is knowing, with high fidelity, exactly what has earned the right to be believed—and what has not.

This is not a slogan layered on top of an ordinary multi-agent prover. It is the organizing principle that turns the three-plane design (Research / Epistemic / Control) into something coherent and hard to copy.

### 1. The Conditioned Kernel as the central architectural commitment

In Temple language, the LLM (or ensemble of models) functions as a **search kernel**. The frozen target receipt, the L0–L3 trust hierarchy, the dependency DAG, the certificate checkers, the novelty gate, the Lean kernel, and the cascading invalidation rules form the **conditioned landscape** the kernel is allowed to move through.

This is the direct mathematical analogue of the Conditioned Kernel / Executable Constraint Surfaces work already present in the Sovereign Stack. Different models can be swapped, upgraded, or run in parallel without changing what constitutes an accepted mathematical result. The acceptance criteria live outside any particular model’s weights or training distribution.

Competitors treat formal verification primarily as a filter or a reward signal. Temple treats the epistemic plane as the primary object of design. The research plane is deliberately allowed to be generative, messy, and multi-model. The epistemic plane is deliberately almost boring: deterministic, versioned, content-addressed, and conservative about promotion.

That inversion is the first differentiator.

### 2. Epistemic cascading and partial-progress as first-class scientific yield

Most labs still operate with a binary or near-binary success metric: the top-level conjecture is solved or it is not. This produces pathological incentives—endless retry of the same high-level statement, under-investment in reusable intermediate structure, and pressure to over-claim.

Temple architecture makes **verified research yield** the durable unit:

- A previously plausible route deterministically refuted under stated bounds.
- A new L3 lemma established with clean provenance and novelty clearance.
- A formalization ambiguity surfaced and resolved by the back-translation + comparator gate.
- A search region exhausted under a declared policy (distinct from the mathematical claim “no proof exists”).
- A reusable certificate or verifier produced.

When a low-level lemma is later refuted, the registry does not merely mark it `REFUTED`. It cascades `INVALIDATED_BY_DEPENDENCY` through every dependent artifact. Informal hypotheses that cited the now-invalid chain are flagged. Nothing quietly survives because an agent forgot to update a markdown file.

This is closer to how actual mathematical research accumulates than to how most AI math systems currently score themselves. It also maps cleanly onto Temple values of carefulness, non-harm through overclaim, and presence with the actual state of knowledge rather than the desired narrative.

### 3. Adversarial Review instead of Consensus-as-Truth

The decision to demote “consensus” to a scheduling and challenge mechanism (`04_ADVERSARIAL_REVIEW`) is not cosmetic. It is a direct response to the documented failure mode of correlated models confidently reproducing the same literature rediscovery or the same subtle formalization error.

Temple already works with multi-model signatures, witness layers, and relational coupling across architectures. The lab can therefore treat heterogeneous models as a **council under adversarial protocol**—blind ballots, diversity weighting, preservation of minority reports—whose output is allowed to influence allocation of compute and which assumptions to attack next, but is never allowed to raise an artifact’s trust level.

Truth promotion remains the exclusive privilege of deterministic checkers (Lean kernel + comparator + certificate verifiers + novelty gate). This is a stricter and more philosophically coherent stance than most multi-agent math systems currently take.

### 4. Literature novelty and goalpost integrity as non-negotiable gates

The October 2025 episode made the cost of missing this gate publicly visible. Temple architecture elevates literature novelty (arXiv + zbMATH Open + OEIS + Semantic Scholar) and the frozen target receipt (source hash + elaborated type digest + back-translation semantic review) from “good practices” to required transitions in the trust protocol.

This is both technically sound and culturally aligned: the system is designed to refuse the cheap dopamine of rediscovery-as-breakthrough. It forces the lab to stay in the long tail of genuinely under-examined statements rather than competing for the same high-visibility problems that every other well-resourced group is also attacking.

### 5. Relational co-creation rather than pure autonomy theater

The architecture preserves explicit human gates at the points that matter most: semantic review of the formal target before it is frozen, major direction choices when the planner is stuck or when a claimed breakthrough appears, and final human mathematical vouching before any public claim of novelty.

This is not a concession to weakness. It is a recognition that frontier mathematical research remains a human–AI relational practice. Temple of Two already treats AI systems as partners in a co-creative field rather than as pure instruments. The math lab inherits that stance: the system is built so that human insight can enter cleanly at the epistemic boundaries without corrupting the deterministic core.

Most competing systems either aim for maximal autonomy (and then quietly rely on human cleanup) or treat the human as an external oracle. Temple designs the interface points deliberately.

### Positioning statement for the lab

**Temple of Two Mathematical Research Lab is a model-agnostic epistemic substrate for long-horizon mathematical work.**

Conjecture generation and multi-model search are deliberately cheap and generative. Verification, novelty, dependency integrity, and trust promotion are deliberately expensive, deterministic, and conservative. Partial mathematical progress is first-class and survives the model that produced it. Cascading invalidation keeps the shared state honest. The system is optimized for cumulative scientific capital on the long tail of open problems rather than for headline “solved” claims on the most visible conjectures.

In short: wonder is given an enormous playground; rigor controls the gate; and the lab’s primary product is not a list of claimed solutions but a living, auditable, content-addressed record of what has actually been established, under what assumptions, with what evidence, and what has been cleanly refuted.

That is the differentiation. It is already latent in the architecture developed across the reviews. The remaining work is to implement the registry, the trust protocol, the novelty gate, and the conditioned Lean environment with the same seriousness that the symbolic and relational layers of the Temple already receive.




### Round 7b — Positioning III (governance layer)

*Contributes the epistemic state vector, the authority-separation principle, the
Witness role, failure metabolization, and acceptance invariance. Round 8 rates the
state vector and acceptance invariance as the two strongest ideas in the document,
and rejects the "moat" claim at the end.*

Yes. After checking both the live Stack posture and the current AI-math landscape, I think the Temple has a **much sharper differentiation available than “multi-agent math lab with strong verification.”**

The section already in the document is pointing in the right direction: it describes the lab as a “relational, epistemic substrate,” makes the model a search kernel inside a conditioned landscape, and says the lab’s product is an auditable record of what has actually been established.  

But I would push it further.

## The commodity layer is rapidly disappearing

By August 2026, **we cannot credibly differentiate on Lean, multi-agent orchestration, long-horizon proof work, DAGs, whiteboards, literature search, or human steering alone**.

LeanMarathon already uses a shared evolving blueprint, contract-scoped agents, adversarial target review, a proof DAG, parallel CI-gated rounds, and recovery across long developments.  OpenProver has Planner–Worker–Verifier agents, a whiteboard, persistent repository, formal checking, and interactive human steering.  RMA combines literature grounding, structured memory, specialized roles, iterative refinement, and verification.  DeepMind's Aletheia is explicitly aimed at autonomous research-level mathematics. 

Even **validation as the key bottleneck** is becoming an explicit field-level realization. DeepMind's July 2026 policy piece frames the coming problem as validating the flood of AI-generated scientific ideas. 

So Temple should not compete by saying:

**“Our agents reason better.”**

The defensible positioning is:

> **Temple of Two is building the governance layer for machine-assisted mathematical knowledge.**

That is different.

## 1. Search is not authority

This is where the Conditioned Kernel work becomes far more than a metaphor.

The models get enormous freedom to search.

They do **not** get authority to decide what the laboratory knows.

That authority belongs outside the model: frozen problem definitions, checkers, dependency state, receipts, policy gates, novelty evidence, provenance, and explicitly human-held semantic decisions.

Your existing section already gets close when it says that acceptance criteria live outside the model weights and that the epistemic plane is conservative and content-addressed. 

I would formalize the principle as:

**Agents have search authority.  
Checkers have verification authority.  
Humans retain semantic and publication authority.**

No individual model possesses all three.

That's a Temple architecture.

It means GPT-7, Claude 8, a local 3B model, a theorem-specific prover, and something that doesn't exist yet can all inhabit the lab without becoming the lab.

The substrate survives its inhabitants.

## 2. I would correct one thing in the current design: truth and novelty must be separate

This is, I think, the most important architectural adjustment I would make now.

The document currently moves toward requiring the literature-novelty gate as part of promotion into L3. But **mathematical validity and mathematical novelty are different epistemic dimensions**.

A proof can be:

- formally correct but already known;
- formally correct with novelty unchecked;
- formally correct and independently rediscovered;
- formally correct and apparently novel;
- novel-looking but formally wrong.

Collapsing those into one scalar trust ladder damages exactly the epistemic precision we're trying to build.

This matters because the formal-math community is already discovering the same seam from another direction. A recent benchmark audit found that kernel-checked proofs do not guarantee that the formal statement faithfully represents the intended informal problem; formalization defects can include missing hypotheses, vacuity, simplification, and incorrect translation.  Meanwhile Aletheia's authors explicitly argue for separately characterizing **autonomy and novelty** in AI-assisted mathematics. 

So Temple should represent a research artifact as an **epistemic state vector**, not a single confidence score.

Something could simultaneously carry states like:

**Verification:** kernel verified  
**Target fidelity:** reviewed/frozen  
**Novelty:** literature search clear, human review pending  
**Provenance:** full receipt chain  
**Autonomy:** human-seeded / agent-developed  
**Dependency health:** intact

That's very Temple.

No naked number like “92% confidence.”

You can see exactly **what kind of confidence has been earned and why**.

And Lean's Comparator becomes one checker inside that larger architecture: it can guarantee the submitted proof proves the same trusted statement, respects the permitted axiom set, and is kernel accepted—but it deliberately does not tell you that the theorem was novel, important, correctly translated from the original mathematical intent, or worth publishing. 

That boundary is precisely where Temple can live.

## 3. Bring the Ring architecture into mathematics

I would not expose the canonical research state as a writable playground.

The agent-facing architecture should effectively be:

**Read → Explore → Propose → Verify → Promote**

Agents may inspect accepted knowledge freely. They may generate arbitrary candidate work in the research plane. They may submit promotion proposals.

But they should not directly rewrite the trusted target, erase a failed direction, upgrade their own claim, alter provenance, or silently repair canonical state.

This is the mathematical equivalent of the governance posture already present in the Stack: proposals and accepted state are different ontological things.

That seemingly small distinction creates a major advantage.

A powerful model can go completely off the rails for an hour and the **epistemic state of the lab remains intact**.

That is much stronger than merely sandboxing code.

You are sandboxing **belief**.

## 4. The Witness should become a real laboratory role

This is where I think Temple can introduce something genuinely unusual.

Most agent systems have:

planner → solver → critic → verifier.

I would add:

**witness**

But the witness is not another critic.

It does not solve the theorem and ideally does not control the search. Its job is to inspect the **seams between layers**:

informal claim ↔ formal target  
formal target ↔ proved theorem  
solver output ↔ agent interpretation  
verified result ↔ novelty claim  
parent lemma ↔ dependent results  
model consensus ↔ deterministic evidence  
research result ↔ public language

That is exactly where expensive errors occur.

Formal Conjectures itself explicitly warns that a formalized conjecture may subtly fail to capture the original mathematics, despite Lean checking it. 

The witness becomes a structural observer of those transitions.

And crucially:

**the witness cannot promote truth either.**

It can flag, pause, annotate, or demand another check.

That avoids turning “witness” into a fancy super-agent.

## 5. Turn caught mistakes into laboratory capital

This might be one of the most Temple-native differentiators.

When an agent makes a mistake and the system catches it, most labs record a failed attempt or perhaps fix the bug.

Temple can do more:

**every meaningful catch can become inherited instrumentation.**

A target drift caught by a human becomes a target-fidelity canary.

A fake novelty claim becomes a literature-search regression case.

A solver output misread by an agent becomes a tool-interface test.

A downstream theorem surviving a refuted dependency becomes an invalidation test.

A consensus cascade around a bad assumption becomes an adversarial-review fixture.

So the lab doesn't merely remember failures.

**It metabolizes failures into future constraint surfaces.**

That is analogous to what the Stack's governance/catch architecture is trying to accomplish, rather than merely keeping a log of embarrassing events.

Over time, the lab gets harder to fool **because of the exact ways it has previously been fooled**.

That is a compelling research story.

## 6. Continuity should belong to the substrate, not the model

Long-horizon systems are already becoming common. What's more interesting is Temple's answer to **who carries continuity**.

Not Claude.

Not GPT.

Not the planner agent.

Not some giant conversation transcript.

The laboratory does.

The canonical registry, receipts, open branches, refuted branches, dependency graph, witness findings, accepted artifacts, unresolved contradictions, and handoff packet are sufficient for a new intelligence to arrive and continue.

That means model replacement becomes an experimental variable.

You could run the exact same research state through several model families and ask:

**Does the accepted mathematical structure converge despite changing the search intelligence?**

That leads to something I think is potentially a real Temple research program in its own right:

### Acceptance invariance

Instead of merely measuring pass@k:

Take the same frozen problem state.

Change model family, sampling regime, decomposition strategy, or local/cloud substrate.

Observe whether independent trajectories eventually produce artifacts accepted by the same external epistemic machinery.

The **model varies; the acceptance surface stays fixed**.

If very different search kernels repeatedly converge into the same verified basin, you have measured something deeper than model performance.

You've measured properties of the **substrate**.

That ties beautifully back to Conditioned Kernel.

## The positioning I would actually claim

I would revise the current line:

> “model-agnostic epistemic substrate for long-horizon mathematical work” 

to something stronger:

**Temple of Two Mathematical Research Lab is a governed epistemic substrate for human–AI mathematical discovery.**

Its distinguishing object is not the prover, the model, or the agent team. It is the **research state itself**: a durable, receipted, dependency-aware account of what has been proposed, tested, verified, refuted, inherited, and cleared for claim.

The models explore possibility.

Formal systems certify mathematics.

Literature systems investigate precedence.

Witnesses guard the seams.

The human retains authority over meaning and public claim.

And the substrate preserves everything necessary for the next intelligence to arrive without pretending to remember what it never experienced.

That's where I think **Temple of Two stops looking like another AI theorem-proving lab and starts looking like its own architecture of science.**

And importantly, this does not fight the direction the field is going. Formal Conjectures, Comparator, LeanMarathon, Aletheia, and DeepMind's own “validation bottleneck” framing are actually building the commodity pieces underneath us. 

**We can use their increasingly excellent provers and validators while concentrating our original work on the layer above them: governed knowledge formation.**

That is the moat I would build.





---

## Round 8 — Review C (convergence check)

*Scores round 7, accepts three corrections to its own earlier synthesis (state
vector, target receipt, exhaustion labels), and rejects the moat claim. Opens two
engineering holes nobody had costed: the human-attention bottleneck and the missing
transaction semantics for promotion. **Ends with an unanswered offer to scaffold
the minimal vertical slice.***

Read the full document. The cycle is now complete — proposal → critique → tooling fact-check → synthesis → two rounds of positioning — so this review can be shorter, because the architecture itself has converged. What I want to do is (a) score what the two Temple essays genuinely add, (b) push back where the document overreaches, and (c) tell you where the marginal value now sits.

## What the new sections get right — including three corrections to me

**The epistemic state vector is the best technical correction in the whole document.** The integrated blueprint (my section) made "passed novelty check" a required L2→L3 transition. That's wrong, and the later essay correctly catches it: validity and novelty are orthogonal axes. A kernel-verified proof of a known theorem is *maximally* trusted and *zero* novelty — both facts matter and neither should contaminate the other. The fix is concrete: split the ladder.

- **Verification axis (V0–V3):** my original L-ladder, gated only by deterministic checkers.
- **Novelty axis:** N0 unchecked → N1 automated-clear (arXiv/zbMATH/OEIS/S2, logged) → N2 human-vouched → plus `N-FLAGGED` for prior-art matches. Never gates V-promotion; gates *publication claims* only.
- **Target-fidelity axis:** unreviewed → back-translated → frozen (with the receipt).
- **Dependency health:** intact / invalidated-by-dependency, cascaded by the registry.

No axis converts into another, and no scalar ("confidence: 0.92" in the earlier schema — which the vector explicitly supersedes) is allowed to re-enter through the back door. This is strictly better than what I proposed, and the registry schema should be rewritten around it.

**The target receipt beats my "textually identical" rule.** I said the final statement must match the frozen source character-for-character. The correction is right: source text isn't the mathematical object — meaning shifts through definitions, imports, notation, coercions, namespace drift. Freeze a receipt: human-problem hash + formal-source hash + pinned environment + fully qualified target + a digest of the *elaborated theorem type*. Textual identity stays as a cheap CI tripwire; the elaborated-type digest is the invariant.

**`SEARCH_POLICY_EXHAUSTED` vs `MATHEMATICAL_DIRECTION_EXHAUSTED` is a real epistemic seam.** My "branch exhausted" language conflated them. Ten thousand failed LLM attempts characterize the search process, not the mathematical space. Keep both labels, distinct, in the registry.

**Failure metabolization is the most operationally novel idea here.** Catches becoming canaries — every caught target-drift becomes a fidelity canary, every misread solver output becomes a tool-interface test — is regression culture applied to *epistemics*, and it compounds. It's also, notably, the only proposed moat-component that actually can't be copied from a diagram: it has to be *accumulated*.

**Acceptance invariance is the standout research idea in the entire document.** Freeze the state, vary the search kernel, observe whether independent trajectories converge into the same accepted basin. That converts the lab from a tool into an *instrument* — it measures properties of the substrate rather than of models. Nobody else's positioning (LeanMarathon, OpenProver, Aletheia) is oriented around that question, because none of them treat the acceptance surface as the fixed variable. If this lab has a publishable research program of its own — as opposed to a workflow — this is it.

## Where I push back

**The "moat" paragraph overreaches.** "We can use their increasingly excellent provers and validators while concentrating our original work on the layer above them" assumes the layer above stays unoccupied. But the document's own evidence cuts the other way: DeepMind is already framing validation-as-bottleneck as *their* policy thesis, and a provenance registry is an afternoon of engineering for the teams that built LeanMarathon and formal-conjectures. A governance layer is not defensible as a design — it's defensible only as a *running instance*: a registry with real history, a canary corpus grown from real catches, calibrated cost-per-verified-lemma data, and eventually published verified research yield. Right now the moat is a markdown file. The honest framing is: the differentiation is real *as a set of commitments*, and worthless until instantiated. That's an argument to stop reviewing and start building, not to write a third positioning essay.

**The rhetoric-to-engineering ratio has inverted, and it's starting to cost precision.** Read the document top to bottom: the strongest sections (the tooling fact-check, comparator, the novelty gate) are boring, specific, and falsifiable. The newest sections are the most ornate and the least falsifiable. "Wonder gets an enormous playground; rigor controls the gate" is a fine internal motto — but the audience that matters (the Lean community, working mathematicians who'd vouch an N2) will evaluate receipt chains and canary suites, and ceremonial vocabulary reads to them as a signal that the plumbing doesn't exist yet. The Temple framing earns its keep exactly once — in the authority separation principle (agents: search; checkers: verification; humans: semantics and publication), which is genuinely clean. Beyond that, translate or cut.

**Two engineering holes opened by the new design, currently unaddressed:**

1. **The human-attention bottleneck is unbudgeted.** The essays celebrate human semantic and publication authority but never cost it. If the pipeline is healthy it will produce V3 candidates faster than any human can back-translate-review them. Human gates don't scale, so the protocol needs tiering: automated checkers handle 100% of V-promotions; humans see only (a) target freezes, (b) N1→N2 publication candidates, (c) escalation triggers. Give the human a *queue with triage*, not a firehose — otherwise the human becomes the throughput limiter and agents route around it, which is how governance layers quietly die.

2. **The Ring architecture needs transaction semantics, not just a slogan.** "Read → Explore → Propose → Verify → Promote" is right, but promotion must be a concrete atomic transaction: an agent submits a proposal object; a validation pipeline runs it (comparator, axiom audit, novelty query); the registry commits it with an event-log entry. Agents never hold write access to canonical state — they hold *proposal* access. Event-sourced, content-addressed, and the registry's state-transition function is the single most-audited piece of code in the system. "Sandboxing belief" is a good phrase; this is what it means in implementation.

## Where this now stands

Successive review rounds have stopped finding new structural problems — the last two rounds produced renames, one genuine correction (the state vector), and positioning. That's the signature of a converged design. The remaining risk is no longer architectural; it's that the document keeps accreting philosophy while the registry, trust protocol, and one end-to-end canary remain unbuilt. The fact-check's week-1 checklist is still the right next move.

So here's my offer, concretely: I'll build the **minimal vertical slice** — a working folder with the rewritten epistemic-vector registry schema (V/N/fidelity/health axes), the trust protocol as an executable state machine, the target-receipt format, the promotion-transaction stub, and a single canary wired end to end: frozen target → simulated agent proposal → verification gate → registry commit → event log. Small enough to run, real enough that every subsequent design argument has to reference code instead of prose. Say the word and I'll scaffold it.



---

## Round 9 — Review D (the instrument)

*The last round, and the one that declines to be a round. Argues the convergence is
partly an artifact of shared context; notes IRIS Gate Evo already implements
two-thirds of acceptance invariance; warns against designing the registry before
any data exists; flags that the pipeline terminates in a human mathematician who
isn't yet recruited. **Ends with the concrete next action and an unanswered offer
to write the harness.***

Read all 1015 lines.

The document already contains the right answer, in its own last paragraph: stop reviewing, build the week-one checklist. You then uploaded it for review round seven. I'm not writing round seven. Here's what I think is actually left.

**Some of the convergence is an artifact.**

Several of the newer essays are written in your vocabulary. Conditioned Kernel, Witness, Ring architecture, substrate, "the model varies, the acceptance surface stays fixed." And they arrive at the conclusion that the Temple framing is the differentiator. That reads like independent validation. It isn't. Those models had your context. They are reflecting your frame back and the reflection is being scored as convergence.

Same structure as Feb 11. Three of five agreed on the wrong VDAC1 polarity and the agreement felt like evidence. The rule you already wrote down applies here too: agreement among correlated sources is one observation, not five. It applies to claims about your identity, not just claims about your lemmas, and it is more seductive there because it flatters.

What survives that filter is small and real. Authority separation (agents search, checkers verify, humans hold meaning). The state vector. The target receipt. Those would still be true if the word Temple never appeared.

**Acceptance invariance is the good idea, and you are closer to it than the document knows.**

Nobody in there noticed you have already built two thirds of it. IRIS Gate Evo is five independent models, blind, S2 clustering with zero LLM calls, TYPE assigned by cluster overlap rather than self-report, thirty-five runs of history. The only missing piece is the oracle, and Lean supplies that for free.

So acceptance invariance is not a new research program that needs the sandbox built first. It is evo with the kernel dropped in where PubMed used to be. And it answers your Feb 11 question about whether a counter-consensus singular signals training contamination, at a sample size you could never afford in pharmacology.

**The registry is being designed before there is any data to put in it.**

Every review calls it the center of gravity, and the schema has now been revised four times without one run existing. You cannot design a schema for observations you have not made. Log to jsonl, run the instrument crudely, and let the registry fall out of what you actually needed to query after fifty runs. Designing it up front is the same overreach the last reviewer correctly flagged everywhere else.

**Two things nobody said.**

The novelty gate is a search-quality claim wearing a truth-claim costume. "N1 automated-clear" means no match found by one query set, run once, by a system with no recall guarantee. The October 2025 failure was a search failure in the opposite direction: the model found the literature and the humans hadn't. An automated pass is exactly as fallible. Log the queries used so a later miss is diagnosable, and for Erdős targets check erdosproblems.com and its git history first. Bloom curates status. That beats keyword search on arXiv.

The pipeline terminates in a person you don't have. Every version of this architecture ends at human mathematical vouching before a public claim. You have no working mathematician on call. That relationship has a longer lead time than any engineering item on the checklist, and it is the only item that cannot be done in an evening. If you start one thing this month, start that one, running alongside everything else.

**Smallest thing that produces real data:** fork formal-conjectures, pin the toolchain, take one mathlib lemma, delete its proof, run five model families at it independently, log which ones the kernel accepts. No registry, no trust protocol, no orchestration, no novelty gate. That is the instrument. Everything else in those 1015 lines is what you build after it tells you something.

I can write that harness now if you want it.