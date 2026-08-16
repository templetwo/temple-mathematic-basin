# Rung 1 — scope, binding on every result under this rung

Set 2026-08-15 after mbp-grok's counter-sign attack (#18154). Applies to r1-cascade-orthogonality, r1a-energy-inequality, r1-def-*, and every later Rung 1 round.

## Naming (attack a)

**Say:** "a finite-N dyadic cascade of Katz–Pavlović type."
**Do not say:** "we formalized Katz–Pavlović 2005."

The model as defined (`defs.lean`) uses the standard telescoping quadratic form `λⁿ aₙ₋₁² − λⁿ⁺¹ aₙ aₙ₊₁` with **λ free** (KP use λ = 2 — ours is a mild generalization) and **two-sided truncation `a₋₁ = a_N = 0`** — a FINITE model on `Fin N`, not the infinite hierarchy of the paper. The equivalence to KP 2005's system was not re-verified against the paper by either seat. **The citation stays cited, not checked.**

## The caveat, on the same line as any result (attack b)

Every Rung 1 result is stated with this clause on its own line, not in a footnote:

> **IN A MODEL: no pressure, no Biot–Savart / non-locality, no incompressibility geometry.** The dyadic cascade is studied precisely because it *removes* the pressure term the trunk question asks about. A clean result here says nothing about whether stretching beats pressure in the true equations; it says how stretching and dissipation trade *when pressure is absent*.

The energy inequality reads cleanly enough to steal a trunk headline. This clause exists so it cannot.

## What "machine-checked" means here

`Σ aₙ·cascadeₙ = 0` and `Σ aₙ·fieldₙ = −ν Σ λ^{2n} aₙ²` — **equalities**, algebraic, over `Fin N → ℝ`. The inequality `≤ 0` for `ν ≥ 0` is a corollary (r1a-corollary-dissipative, next). No ODE solution concept anywhere in Rung 1(a) *at phase 1*. **Superseded 2026-08-15 (phase 3, grok #18358):** the solution concept `HasDerivAt a (field ν λ (a t)) t` on [0,T) entered with r1-inviscid-energy-first-integral (ν = 0) and r1-viscous-energy-antitone (ν ≥ 0, `AntitoneOn`). Still IN A MODEL: no pressure, no Biot–Savart, no incompressibility geometry. Still not Picard: existence of solutions is not claimed; the theorems quantify over whatever solutions there are.

Toward the trunk, not the trunk.

## Precedence

Frozen `QUESTION.md` files are hashed by `round.py freeze` and are **not edited after the freeze**, even for naming — the runner refused exactly such an edit on r1-cascade-orthogonality and was right to. Where a frozen QUESTION.md says "Katz–Pavlović dyadic model," **this SCOPE.md governs the reading**: finite-N, of KP type, citation cited not checked. `defs.lean` and `SELECTION.md` are not frozen artifacts and carry the corrected wording directly.

## B6 (advisor 2026-08-16, grok #18651 sign) — r1-cascade-orthogonality's frozen QUESTION.md over-reads
Its "every unit of energy the stretching term pumps into shell n+1 is a unit that leaves shell n" is the per-shell FLUX
identity, which is not a ring; the kernel holds only Σₙ aₙ·cascadeₙ = 0 per state. This line governs the frozen prose.
