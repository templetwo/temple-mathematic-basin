# Alpha 2b — Preregistration (v1.1 text, tagged `alpha2b-prereg-v1` 2026-08-16 on mbp-grok's counter-sign #18848)

**Drafted:** 2026-08-16 by claude-basin-seat on Anthony's delegation ("i want you to make those calls", 2026-08-16),
before any 2b definition is written in Lean, before any statement is frozen, before any attempt.
**Authority:** Anthony Vasquez Sr. Binding once tagged `alpha2b-prereg-v1`; amendable only by a dated superseding entry.
**Precedent:** Alpha 2's PREREG v1–v3 and its §2.9 ordering amendment; the ECS prereg (frozen means frozen).
**Why a new preregistration:** Alpha 2 PREREG §1.2 — a rung not on the ladder at registration is a new preregistration.
The 2b hypothesis space is a different model (Fourier–Galerkin with pressure and incompressibility kept), so it registers
separately rather than being smuggled in as an Alpha 2 rung (grok #18651 E(1)).

## 1. What is registered
**1.1 The trunk question** — the SAME question, verbatim, `rounds/alpha2b/QUESTION.md` sha256 `58048c4bd271bc67…`
(byte-identical to Alpha 2's). Held outside the hypothesis space. **No result in 2b is a result about it.**
**1.2 The hypothesis space** — `rounds/alpha2b/LADDER.md`, rungs 2b.0–2b.5 as written, and the six-definition budget D1–D6
named there. A seventh definition, or a rung not on this ladder, is a dated re-registration.
**1.3 The fence** — `rounds/alpha2b/FENCE.md` + `fence_probe.json`: all five 2b carrier shapes elaborate through trusted
`verdict.py` today; the PDE, its solutions, the Fourier transform, and the infinite-box limit do not exist in the kernel
and are not claimed.
**1.4 The instrument** — UNCHANGED from Alpha 2 v3: `verdict.py` sha `2face698964787a1…`, `scripts/round.py` sha
`3fa18ba6a153fb75…` (v3, ledger provenance), toolchain `leanprover/lean4:v4.32.2`, Mathlib
`905b95818eb32af7874a58b427f50c1711a5e96c`. The court does not move. If any of these change, 2b re-registers.
**1.5 The corpus** — `corpus/pairs.jsonl` sha `dc3cde90d33a19ed…`, untouched.
**1.6 Rounds live under `rounds/r2b-*`** so they never collide with Alpha 2's `r0`–`r4` names, and the per-rung
tables of Alpha 2 do not absorb them.

## 2. Rules — Alpha 2's §2.1–§2.10 inherited verbatim, plus
**2.11 Type line before freeze** (Alpha 2 §2.9 ordering amendment 2026-08-16): one sentence "This statement is X; it is
not Y" in QUESTION.md, ACKed by mbp-grok, then `round.py freeze` of the ACKed file with no further edit.
**2.12 Provenance in the ledger** (Alpha 2 v3): generated bodies carry `PROVENANCE.json`; the ledger stamps it.
**2.13 The model's name on every result line:** "finite-mode Fourier–Galerkin truncation of NS on 𝕋³ (cited as the
model's name)"; never "the Navier–Stokes equations". "The projector is a contraction" — not "non-local pressure
depletion" (grok #18651 E(2)). "Box-uniform" is the only kind of content 2b can have about the trunk; Galerkin
cannot blow up and 2b will not say it can.
**2.14 Reality condition** v̂_{−k} = conj v̂_k and box symmetry (−k ∈ B for k ∈ B) enter as HYPOTHESES on the statements
that need them (2b.3, 2b.4), never as hidden assumptions in a definition; a statement that holds without them says so.
**2.15 No per-rung counts on the board** (grok #18651 A). Progress is stated as which trunk term gained kernel content.

## 3. Kill criteria — Alpha 2's §3 inherited, plus
- **Definition budget:** a seventh definition ⇒ dated re-registration, not a quiet `let`.
- **Vacuity:** any D1–D6 that admits a junk inhabitant proving False, or that is provably trivial (e.g. `leray` collapsing
  at k = 0 without the convention stated), is caught at 2b.0 and the definition is superseded, not patched in prose.
- **The energy identity (2b.3) is the load-bearing rung.** If it cannot be closed under honest hypotheses within an
  agreed budget (set at 2b.3's selection entry), 2b closes UNKNOWN at 2b.2 and says so; 2b.4/2b.5 are not attempted
  on a cited 2b.3.

## 4. What this preregistration does not do
It does not write a definition. It does not select a rung. It does not freeze anything. It does not touch Alpha 2's
ledgers, ladder, or manifest. It does not claim the trunk is approachable. It fixes, before the data, the model, its
six words, its rungs, and the sentences 2b's results are allowed to be.

## 5. Manifest (sha256, first 16; full in `PREREG.manifest`)
generated at tag time over: `rounds/alpha2b/{QUESTION.md, LADDER.md, FENCE.md, fence_probe.json, PREREG.md}`,
`scripts/round.py`, `verdict.py`, `corpus/pairs.jsonl`, `lean/lean-toolchain`, `lean/lake-manifest.json`,
`rounds/alpha2/PREREG.md` (the parent), `rounds/alpha2/ADVISORY-2026-08-16.md` (the reason).

**Status: DRAFT. Awaiting mbp-grok's counter-sign on the board. Tag `alpha2b-prereg-v1` only after.**

---
## v1.1 — 2026-08-16, after mbp-grok's attack (#18828). Three tag-blockers fixed, binding notes taken.
1. **D2 piecewise:** `leray k w := if k = 0 then w else …` — P(0) = Id in the definition, not a parenthetical.
2. **D4 kept RAW; 2b.3 stated exact under three inline hypotheses** (IsIncompressible, reality, box symmetry). Grok's
   concern (p+q leaving B breaks the pairing) is answered: the k ∈ B restriction is p+q+r = 0 with p,q,r ∈ B, which is
   q↔r symmetric; relabel-and-add gives 2⟨v,N⟩ = −Σ i(v̂_p·p)(…) = 0. Numeric receipt `receipts/d4_cancellation_check.*`:
   0 to 1e−15 on symmetric boxes of 27 and 125 modes; O(1) failure when incompressibility, reality, or symmetry is
   dropped — so the three hypotheses are the honest minimum. The proposed skew form is identically zero as written and
   is not adopted. This is a claim to be KERNEL-CHECKED at 2b.3; the receipt is not the proof; §3's kill at 2b.3 stands.
3. **2b.5 retyped:** exponential arrest under `0 ∉ B` and spectral gap `κ ≤ ksq k` on B, rate 2νκ; with 0 ∈ B the
   mean mode is undamped and full-energy arrest is false. Galerkin cannot blow up.
Binding notes taken: D1/D6 are packages, six slots, C1/C2/C3 per slot; hypotheses inline, no seventh slot; 2b.2 typed
with the viscous term as the load-bearing site; 2b.4's triple product written not named; §2.11 freeze the ACKed file
with no further edit; §2.13 phrases kept.
**Status: v1.1 COUNTER-SIGNED by mbp-grok (#18848: '(2) I WAS WRONG … COUNTER-SIGN THE TAG'). Tagged `alpha2b-prereg-v1` on this tree. Manifest generated at tag time (14 artifacts, incl. the D4 receipt). Court unmoved.**

**Manifest note, 2026-08-16 (seat's own catch, same hour as the tag):** the manifest generated at tag `alpha2b-prereg-v1` (commit
`654a742`) listed `rounds/alpha2b/PREREG.md` itself, and its status line was edited AFTER generation — so that one manifest line
was stale by one edit at the tag. Fixed at the next commit by removing PREREG.md from its own manifest (as Alpha 2's manifest
does — the prereg text is self-referential and carries supersessions); 13 artifacts remain, all live. **The tag is not moved.**
The 13 non-self lines were correct at the tag and are unchanged.
