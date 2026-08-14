# T1 candidate — cap-set lower bound

**Status:** readiness probe 2026-08-12. First *question* written 2026-08-13 in `t1/QUESTION.md`. Still not a run and not a certificate. Anthony still says the word before a witness attempt.  
**Fence:** universe-monomorphic. Carriers are `ℕ`, `Fin n`, `ZMod 3`, `Finset`.  
**Partial credit:** any explicit `A` for any `n ≥ 3` with `|A| > 2^n`.  
**Not a prize wall:** beating the boolean cube is a construction, not an all-or-nothing resolution.

## Statement (the term `verdict.py` must elaborate)

There exist `n ≥ 3` and a finite `A ⊆ (ℤ/3ℤ)^n` with no 3-term arithmetic progression and `|A| > 2^n`.

Lean term (also `t1/statements.py`):

```lean
∃ (n : ℕ) (A : Finset (Fin n → ZMod 3)),
  3 ≤ n ∧
  (∀ a ∈ A, ∀ b ∈ A, ∀ c ∈ A,
    a ≠ b → b ≠ c → a ≠ c → a + c ≠ (2 : ℕ) • b) ∧
  A.card > 2 ^ n
```

`#check` under `lean/` (Mathlib `905b958…`, toolchain 4.32.2) on 2026-08-12:

```
∃ n A, 3 ≤ n ∧ (∀ a ∈ A, ∀ b ∈ A, ∀ c ∈ A, a ≠ b → b ≠ c → a ≠ c → a + c ≠ 2 • b) ∧ A.card > 2 ^ n : Prop
```

Control `Type*` commutes (same seat, same lake):

```
∀ {α : Type u_1} [inst : AddCommMonoid α] (a b : α), a + b = b + a : Prop
```

So the elaborator accepts both. The fence is `verdict.py`'s `levelParams := []`, not `#check`. This Grok seat cannot nest `sandbox-exec` (`sandbox_apply: Operation not permitted`). Trusted-path smoke is `python3 scripts/t1_elaborate.py` from Terminal or mbp-claude.

## Why this is a first problem and not homework

The coordinate cube `{0,1}^n ⊂ (ℤ/3ℤ)^n` is itself a cap set of size `2^n`. So `> 2^n` is the first non-trivial threshold, not a restatement of the cube.

Existence is combinatorially known: in `n = 3` the maximum cap set has size 9. The lab's job is a **kernel-checked witness** (nine functions `Fin 3 → ZMod 3`, the three AP side-conditions, the card inequality). UNKNOWN remains a legitimate terminal if we fail to exhibit one. Manufacturing a size by `sorry` is banned.

## What this is not

- Not a corpus row. `pairs.jsonl` stays `dc3cde90`.
- Not C1/C2/C3. No certificate yet.
- Not a model call.
- Not a P4 arm.

## How to run the trusted path

```bash
cd ~/Desktop/temple-mathematic-basin
python3 scripts/t1_elaborate.py
```

Expect: type elaborates; `True.intro` / `by trivial` as a body must **REJECT** (wrong proof). `reject_reason` should be `compile_error` (type mismatch), not `undefined universe`. A universe failure means this candidate is outside the real fence and must be replaced.
