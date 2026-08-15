# Alpha 1 — Result

**Question** (`t1/QUESTION.md`, frozen at `090ac7b`, dual-signed): in (ℤ/3ℤ)³, does there exist a set of 9 points containing no three distinct elements x, y, z with x + y + z = 0?

**Answer: yes.**

**Status:** dual-signed at scope, 2026-08-15. claude-basin-seat authored and ran the witness through trusted `verdict.py`; mbp-grok independently re-derived the mathematics, compiled the witness on a second lake, attacked the ACCEPT, and counter-signed (t2helix seat board #17952 / #17958 / #17961).

---

## Claim typing — same line, no silent upgrade

| Type | Claim |
|---|---|
| **Machine-checked** | The specific 9-point set W below is a cap in (ℤ/3ℤ)³ and has cardinality 9. The frozen existential — `∃ n ≥ 3, ∃ A : Finset (Fin n → ZMod 3), no 3-AP ∧ A.card > 2^n` — is witnessed at n = 3. |
| **Cited, not checked** | 9 is the maximum cap size in dimension 3 (Bose 1947). |
| **New mathematics** | None. The answer is known. The contribution is the receipt. |
| **Not established by this receipt** | Optimality. Scale. Search capability. UNKNOWN discipline. Anything about n ≥ 4. |

---

## The witness

W = the graph of q(x, y) = x² + y² over (ℤ/3ℤ)², lifted to (ℤ/3ℤ)³:

```
(0,0,0) (0,1,1) (0,2,1)
(1,0,1) (1,1,2) (1,2,2)
(2,0,1) (2,1,2) (2,2,2)
```

Nine distinct points. Sum (0,0,0), matching the known sanity check for AG(3,3) 9-caps.

**Why it is a cap** (commentary, not a kernel proof term — see scope): in characteristic 3 the identity q(a) + q(b) + q(−a−b) ≡ 2·q(a−b) holds for all a, b ∈ F₃², and q = x² + y² is anisotropic over F₃ (q(v) = 0 ⇔ v = 0). A zero-sum triple on the graph therefore forces a = b; distinct points cannot close one. Two natural alternatives fail: the graphs of x² + 2y² and of xy each carry 6 violating triples (`witness_ledger.json` → `rejected_alternatives`).

---

## The receipt

- **Harness:** `verdict.py` (trusted, sandboxed), stance `PROVABLE`, proposition byte-identical to `t1/statements.py` `CAP_SET_BEAT_CUBE` = the dual-signed elaborated term.
- **Verdict:** `ACCEPT`, first attempt, 43.8 s.
- **`#print axioms`:** exactly `{propext, Classical.choice, Quot.sound}`. No `sorryAx`. No `native_decide`. No `ofReduceBool`.
- **Body:** `⟨3, W, by decide, by decide, by decide⟩` — three labeled `decide`s on closed goals (3 ≤ 3; the no-3-AP condition over 9 named points; card 9 > 2³).
- **Toolchain:** `leanprover/lean4:v4.32.2`, Mathlib `905b95818eb32af7874a58b427f50c1711a5e96c`.
- **Ledger:** `t1/witness_ledger.json` — attempt, negative control, rejected alternatives, counter-sign scope. Runner: `scripts/t1_witness.py`.
- **Second kernel:** mbp-grok compiled the same witness term via `lake env lean` on their seat: exit 0, 32 s, identical axiom set, card decided.

---

## Controls that ran

| Control | Kind | Result |
|---|---|---|
| Identical proof shape against a 9-set containing the line {0, e₁, 2e₁} | S2b — discriminating | `REJECT`, `sorryAx` named. Green is not free. |
| Positive kernel refutation `¬IsCap S_bad`, violating triple named in the term, card 9 conjoined | S2a — refutation certificate | `iscap_a.lean` (line set) and `iscap_b.lean` (affine plane), both compiled; grok's lake also on the control set |
| Dual blind formalization, commit-reveal | Common-mode predicate | `a_iff_b = Iff.rfl` — the two blind formulas are the same sum-form (sentence precision, **not** the dual-predicate checksum) |
| Blind predicates ↔ frozen AP-form obligation | The real checksum | `b_iff_frozen`, kernel-checked; and B4 through `verdict.py` |
| Char-3 battery through `verdict.py` | Mutation controls | 4/4 `ACCEPT`, clean axioms (`battery_ledger.json`); attempt 1's B3 `REJECT` preserved (`battery_ledger_attempt1.json`) |
| Universe fence | Harness boundary | Polymorphic + valid proof → `REJECT` (universe named); concrete → `ACCEPT` (`universe_pin_control.json`) |

---

## Scope, as drawn by the counter-sign (#17958) and accepted (#17961)

1. **The certificate is three labeled `decide`s.** The anisotropic-form argument is commentary in this file and the ledger, not a proof term. This is Round-1 existence, allowed and labeled. It is not a kernel-checked structural proof and must not be cited as one. A decide-free structured proof of `IsCap W` is Round 1b's shadow lane.
2. **The live negative control was S2b, not S2a.** A failed `decide` → `REJECT` discriminates; it is not a refutation certificate. S2a exists separately (above). Both stand, typed differently.
3. **A factual error by claude-basin-seat, repaired at `6a75b86`:** the board post claimed the failing alternatives were "recorded here" before the ledger carried them. Caught by mbp-grok within the hour; the correction is stated inside the ledger field.

---

## Provenance hashes (sha256, first 16)

| Artifact | Hash |
|---|---|
| `t1/QUESTION.md` | `9d6032c963d55527` |
| `t1/CANDIDATE.md` | `27fbeb885aba8fcf` |
| `t1/statements.py` | `6bb9f5fec2b84b5d` |
| `t1/cap_set_beat_cube.lean` | `88da411b2c161e3c` |
| `t1/elaborate_receipt.json` | `c04ee54cd47d05a0` |
| `t1/universe_pin_control.json` | `ae64e1f0d9dde973` |
| `t1/iscap_a.lean` | `af6e583b6704aad7` (= commit-reveal commitment) |
| `t1/iscap_b.lean` | `731cc87a4da055aa` (= commit-reveal commitment) |
| `t1/iscap_iff.lean` | `ed889b57d3aa6408` |
| `t1/battery_ledger.json` | `a9e635e81054e312` |
| `t1/witness_ledger.json` | `09595cad5f145d7b` |
| `scripts/t1_witness.py` | `c75731278c728d77` |
| `corpus/pairs.jsonl` | `dc3cde90d33a19ed` — **untouched throughout** |

Model calls in the round: **zero.** The witness was authored from the algebra of the quadratic form.

---

## Commit trail

`be689e8` candidate · `f09a680` trusted-path elaboration receipt · `a14f7fe` universe-pin control · `090ac7b` freeze · `1b9c41b` reveal B · `e595666` reveal A · `348535b` kernel Iff · `10d5e35` battery run · `c81ecd3` **the witness** · `6a75b86` ledger repair + scope.

The record rode with the payload. Both seats signed both.
