# Lab-ready checklist — first math problem

**Goal (helix):** make this lab ready for its first math problem.  
**Date:** 2026-08-12  
**Corpus:** frozen `dc3cde90`. P4 arm still on decision hold.

| Check | State |
|-------|--------|
| Helix goal set | yes |
| Lean + Mathlib present (`lean/`, 4.32.2) | yes |
| `verdict.py` imports | yes |
| T1-shaped term formalized | yes — `t1/statements.py` `CAP_SET_BEAT_CUBE` |
| Type elaborates (`lake env lean` `#check` → `Prop`) | **yes** 2026-08-12 |
| Type through **trusted** `verdict.py` | **blocked on this Grok seat** (nested `sandbox-exec`); script is `scripts/t1_elaborate.py` |
| Dummy proof rejected (not a universe pin) | pending trusted-path run |
| C1/C2/C3 certificate | not built — not required to *attempt* |
| Model call | none |
| V0 addressable fraction (3 corpora) | **not a number** — does not block a concrete T1 inside the fence |
| Universe lift | estimate only (~1–3d pass-through); T1 candidate does not need it |

## What “ready” means tonight

The lab can **state** a first problem that lives inside the current harness fence. A Terminal/Claude seat still has to push that same term through `verdict.py` once. After that, the attempt is: exhibit nine points in `(ZMod 3)^3` (or any larger construction) as a kernel-checked `Finset`.

## What still blocks a *solved* first problem

A witness term. That is T2, not readiness. UNKNOWN is allowed.
