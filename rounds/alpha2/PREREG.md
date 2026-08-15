# Alpha 2 — Preregistration

**Registered:** 2026-08-15, before any rung is selected, before any Lean statement below the trunk is frozen, before any attempt.
**Authority:** Anthony Vasquez Sr. Drafted by claude-basin-seat at his instruction ("preregister the current tree"). Binding once tagged `alpha2-prereg-v1`; amendable only by a dated superseding entry, never by edit.
**Precedent:** the ECS preregistration (conditioned-kernel, prereg-v1, DOI 10.5281/zenodo.21797326): frozen means frozen; ordering — seal before any arm — is the point.
**Tree:** commit `9006b7573dd14fe5f7b0e48c576e744cf3078ec4`, tree `fa60cdff1657a4c6bde9b8db5a141232c68e00f4`, `origin/main`.

---

## 1. What is registered

**1.1 The trunk question**, verbatim, held outside the hypothesis space:

> Can 3D vortex stretching dynamically overcome non-local pressure depletion to concentrate scale-invariant critical norms (such as $L^3_x$ or $\dot{H}^{1/2}$) into a finite-time collapsing profile, or does the geometry of incompressibility unconditionally force viscous dissipation to arrest the cascade?

`rounds/alpha2/QUESTION.md`, sha256 `58048c4bd271bc67…`. **No result produced in this round is a result about 1.1.** Any claim that one is, is a preregistration violation.

**1.2 The hypothesis space** is the ladder, `rounds/alpha2/LADDER.md`, sha256 `7f02b73b7846f538…`, rungs 0–4 as written. A rung not on the ladder at registration is a new preregistration, not an amendment.

**1.3 The fence**, `rounds/alpha2/FENCE.md` + `fence_probe.json`: what the harness can and cannot elaborate, measured before selection. Registered so a later "the harness can't see this" is a recorded fact, not a discovered excuse — and so a later "the harness can now see this" is a recorded change, not a silent one.

**1.4 The instrument**: `verdict.py` sha256 `2face698964787a1…` (unchanged since P0, tag `p0-closed`), universe-monomorphic, Mathlib-only, sandboxed; toolchain `leanprover/lean4:v4.32.2`; Mathlib `905b95818eb32af7874a58b427f50c1711a5e96c`; runner `scripts/round.py` sha256 `bb8330443b3dd762…`. **If any of these change during the round, the round is re-registered.**

**1.5 The corpus**: `corpus/pairs.jsonl` sha256 `dc3cde90d33a19ed…`. Not touched by this round. Its untouched state at close is a checkable claim.

## 2. Pre-committed rules — fixed now, before a rung exists

**2.1 Selection.** Anthony selects the first rung. The seat does not. Selection is a dated entry naming the rung; only then does that rung's Lean statement get written, frozen (`round.py freeze`), elaborated (`round.py elaborate`), and dual-signed by mbp-grok before any attempt.

**2.2 Claim typing, every result, same line:** *machine-checked* / *cited, not checked* / *new mathematics claimed* / *not established*. A rung's ACCEPT is typed as that rung. The words "toward the trunk, not the trunk" appear on the line. Maximality, optimality, or resolution language for the trunk is banned in any rung's result.

**2.3 The kernel is the court.** ACCEPT through trusted `verdict.py` with `#print axioms` ⊆ {`propext`, `Classical.choice`, `Quot.sound`}. `sorryAx`, `native_decide`, `ofReduceBool` — automatic fail. `decide` allowed on closed goals, labeled. A `decide`-only certificate is typed "existence / verification, not structural proof."

**2.4 Negatives are proven positively.** No failed attempt is filed as a refutation. A negative control is a kernel-checked `¬P` with the witness named. Failed attempts are `KERNEL_REJECT` / `ELABORATION_ERROR` / `TIMEOUT` / `SANDBOX_OR_TRANSPORT_ERROR`, never "false."

**2.5 The ledger is complete or the round is void.** Every attempt through `round.py attempt` lands in `attempts_ledger.json`, dead-ends included. An attempt run outside the runner is not part of the round.

**2.6 UNKNOWN is a legitimate terminal.** A rung that ends with a full ledger and no ACCEPT is an honest no-result and satisfies the round's process gate. Manufacturing an ACCEPT does not.

**2.7 Definitions are statements.** Any Lean definition written for a rung (Rung 0's especially: divergence-free, vorticity, the NS operator) is subject to the §18 certificate — C1 non-contradiction, C2 kernel witness, C3 mutant family — before any theorem is proven over it. A theorem over an uncertified definition is typed "conditional on the definition."

**2.8 Model calls.** None are prohibited; every one is logged with `model_requested` / `model_string_served` per spec §6, and a generated proof body is typed "generated" in the ledger. Alpha 1 used zero; that is a fact, not a rule.

**2.9 Two seats.** mbp-grok counter-signs the frozen statement before attempt and reviews any ACCEPT with an explicit instruction to attack it. A single-seat ACCEPT is "attested," not "dual-signed."

**2.10 The trunk/instrument tag.** Every chronicle entry in the round is tagged trunk or instrument. Rung 0 is instrument. Rung 1+ are trunk-track. If the round closes with Rung 0 done and no Rung ≥1 attempted, §18.9's sixth kill criterion fires and is recorded as fired.

## 3. Kill criteria — pre-committed

- **Fence:** if the selected rung's statement cannot be elaborated by the registered instrument, the rung is replaced by a dated entry; the instrument is not quietly widened.
- **Library:** if a rung requires more than an agreed budget of new Lean definitions (set at selection, in the selection entry), it is deferred with its re-entry data named — not ground through.
- **Substitution:** per 2.10.
- **Prior art:** if a rung's target is found already formalized in Mathlib or elsewhere, the rung becomes a replication and says so.
- **Void run:** any statistic or claim about a run whose observations did not occur (transport failure, sandbox denial, all-MALFORMED) is void per the liveness guard; the void is recorded.

## 4. What this preregistration does not do

It does not choose a rung. It does not freeze any statement below the trunk. It does not authorize an attempt. It does not touch the corpus. It does not claim the trunk is approachable. It fixes the rules of the encirclement before the encirclement begins, so that whatever the ladder yields — a rung ACCEPTed, a rung UNKNOWN, a rung killed — is read against rules that predate the data.

## 5. Manifest (sha256, first 16; full in `PREREG.manifest`)

| Artifact | sha256 |
|---|---|
| `rounds/alpha2/QUESTION.md` | `58048c4bd271bc67` |
| `rounds/alpha2/FENCE.md` | `104886ba9629ee41` |
| `rounds/alpha2/LADDER.md` | `7f02b73b7846f538` |
| `rounds/alpha2/fence_probe.json` | `aae619ef84ad42fc` |
| `scripts/round.py` | `bb8330443b3dd762` |
| `verdict.py` | `2face698964787a1` |
| `t1/RESULT.md` (Alpha 1, the precedent result) | `12afa6d98588d860` |
| `t1/witness_ledger.json` | `09595cad5f145d7b` |
| `corpus/pairs.jsonl` | `dc3cde90d33a19ed` |
| `lean/lean-toolchain` | `2bdc48adfa58d001` |
| `lean/lake-manifest.json` | `2da0e95c5d117fc5` |
| `basin-spec-v2.md` | `0574d786b869d21a` |
| `basin-spec-s18-handoff-v3.md` | `5371a5cc5034a54e` |

Tag: `alpha2-prereg-v1` on `9006b757…` + this file. Any commit that changes a manifest artifact after the tag re-registers.

---

## Supersession — v2, 2026-08-15

**Trigger:** §1.4 — a registered instrument artifact changed. `scripts/round.py` was amended so that every `attempts_ledger.json` carries the frozen statement, its sha256, the question sha256, and the freeze timestamp, per mbp-grok's #18087: the runner enforced the frozen bytes at attempt time, but the *receipt* did not say what theorem it certified — a stranger reading the ledger alone could not see the subject of the ACCEPT. The receipt now says.

**What changed:** `scripts/round.py` sha256 `bb8330443b3dd762…` → `f2bae93ccd76fa66…`. Ledger schema gains `frozen{statement, statement_sha256, question_sha256, frozen_utc}` at the top level and `statement_sha256` per attempt. Nothing else in the runner changed: freeze semantics, byte-level drift check, allowlist, banned-tactic refusal, and attempt ordering are byte-identical in behaviour (Alpha 1 regression: still ACCEPT).

**What did not change:** every rule in §2, every kill criterion in §3, the trunk question, the ladder, the fence, `verdict.py`, the toolchain, the corpus. v1 stands as the record of the rules; v2 records the instrument amendment against them.

**Existing receipts:** the five `rounds/r0-*/attempts_ledger.json` were restamped with their frozen statement and hashes from their own `FREEZE.json` — no re-attempt; the ACCEPTs stand and now name their subject. Each carries a `restamped_note` saying so.

Tag: `alpha2-prereg-v2`. Manifest: `PREREG.manifest` regenerated; the round.py line updated, all others unchanged.
