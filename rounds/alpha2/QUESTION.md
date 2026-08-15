# Alpha 2 — the question, verbatim

**Status:** frozen 2026-08-15 as posed by Anthony. This is the TRUNK TARGET of the round. It is not the round's Lean obligation; see `LADDER.md`.

> Can 3D vortex stretching dynamically overcome non-local pressure depletion to concentrate scale-invariant critical norms (such as $L^3_x$ or $\dot{H}^{1/2}$) into a finite-time collapsing profile, or does the geometry of incompressibility unconditionally force viscous dissipation to arrest the cascade?

## What this question is

The 3D incompressible Navier–Stokes global regularity problem, posed through the critical-norm lens: the Escauriaza–Seregin–Šverák $L^3$ endpoint, the scale-invariant $\dot H^{1/2}$ threshold, vortex stretching against pressure non-locality, and viscous arrest of the energy cascade. A Millennium Prize problem, open since Leray (1934). A "yes" (blow-up) or "no" (global regularity) is a complete resolution of the problem.

## What this question is not — claim-typed now, before anyone is tempted

- **Not** answerable by this lab as posed. Nobody has partial credit on the dichotomy itself.
- **Not** elaboratable by the current harness. See `FENCE.md`: the pinned Mathlib has no Navier–Stokes, no vorticity, no divergence-free vector fields, no Leray–Hopf solutions, and its Sobolev material is a distribution-theoretic sketch (3 files) plus one Sobolev inequality. The universe-monomorphic fence is the lesser obstacle here.
- **Not** the first target the 08-12 direction prescribed ("not a prize problem — no partial credit, no feedback"). It is the horizon that direction said a first result should point at.

## What the round therefore is

Two frozen objects, claim-typed on the same line:

1. **This question**, held verbatim as the trunk target. Never softened, never re-posed.
2. **A ladder of fence-legal sub-questions** (`LADDER.md`), each honest partial credit *toward* (1), each labeled "a step toward the trunk, not the trunk." Anthony picks the first rung. That rung's Lean statement gets frozen, elaborated through trusted `verdict.py`, dual-signed, and attempted on his word.

A green board on any rung is a step. It is not (1). The record must never let the two be confused, which is why they live in separate files with separate hashes.
