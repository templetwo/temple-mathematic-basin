# The first question

**Status:** written 2026-08-13. Not a run. Not a certificate. Not maximality.

## The question

In \((\mathbb{Z}/3\mathbb{Z})^3\), does there exist a set of **9** points containing no three distinct elements \(x,y,z\) with

\[
x + y + z = 0?
\]

A set with that property is a **cap**.

That is the first question. A yes is a named 9-point set plus a kernel-checked proof that it is a cap and has cardinality 9. A no would require a kernel-checked proof that no such set exists. UNKNOWN is allowed if the lab cannot produce either.

## Same question in the harness (already elaborated)

A 9-cap in dimension 3 answers this stronger, already-formalized term (`t1/statements.py`, `t1/cap_set_beat_cube.lean`):

```lean
∃ (n : ℕ) (A : Finset (Fin n → ZMod 3)),
  3 ≤ n ∧
  (∀ a ∈ A, ∀ b ∈ A, ∀ c ∈ A,
    a ≠ b → b ≠ c → a ≠ c → a + c ≠ (2 : ℕ) • b) ∧
  A.card > 2 ^ n
```

Dimension 3 and size 9 beat \(2^3 = 8\). The human question is the dim-3 existence. The Lean obligation is the witness that answers it.

## What this question is not

- Not “is 9 the maximum?” That is a different question. The literature says yes (Bose 1947). This round **cites** that and does not prove it.
- Not “is this pre-chosen 9-tuple a cap?” Coordinates are the **answer**, not the question.
- Not “what is the cap-set constant for large \(n\)?”
- Not new mathematics. The answer is known. The lab’s job is a kernel-checked yes and an honest record.

## One-line record if a yes lands

Machine-checked: a specific 9-point set in \((\mathbb{Z}/3\mathbb{Z})^3\) is a cap.  
Cited, not checked: 9 is the maximum in dimension 3.  
No new mathematics claimed.
