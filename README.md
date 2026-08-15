# Basin

See [`basin-spec-v2.md`](basin-spec-v2.md), the authoritative v2 specification.

STATUS: line=statement-validity(§18) trunk=alpha-1 result=9-cap-dual-signed corpus=dc3cde90 spec=v2+§17/§18 updated=2026-08-15

**First result:** [`t1/RESULT.md`](t1/RESULT.md) — a 9-cap in (ℤ/3ℤ)³, kernel-checked through trusted `verdict.py`, dual-signed at scope. Maximality cited, not checked. New mathematics: none. The receipt is the product.

E3 (the dissent estimand, §7) is set down, not killed — see §17 entry of 2026-08-12 and `basin-spec-s18-handoff-v3.md`.

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
