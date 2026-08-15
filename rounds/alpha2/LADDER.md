# Alpha 2 — the ladder

**Status:** DRAFT for Anthony's selection, 2026-08-15. Nothing here is frozen. The first rung is his to pick; the seat proposes and scopes, it does not choose.

Every rung is claim-typed on its own line: **what it is** / **what it is toward** / **what it is not**. A green board on a rung is that rung, never the trunk. Rungs ascend in how much of the trunk question's *structure* they carry, and descend in what the current fence can see (per `FENCE.md`).

The trunk, for reference: does 3D vortex stretching beat non-local pressure depletion to concentrate critical norms into a finite-time collapse, or does incompressibility force viscous arrest?

---

## Rung 0 — the fence itself, as a certificate problem

**What:** State, in Lean over `EuclideanSpace ℝ (Fin 3)`, the definitions the trunk needs and Mathlib lacks — divergence-free vector field, vorticity as curl, the Navier–Stokes operator — and produce a **non-vacuity certificate** for each (C1: hypotheses do not prove `False`; C2: a kernel-checked witness inhabits each definition; C3: a mutant family refuted). Nothing is proven about the equations; what is proven is that the *statements* have content.
**Toward:** every higher rung and the trunk itself depend on these definitions meaning what they say. This is §18's line applied to Alpha 2's own foundations.
**Not:** mathematics about Navier–Stokes. It is mathematics about the *statement* of Navier–Stokes.
**Fence:** entirely inside — concrete carriers, existing calculus. **Partial credit:** each certified definition is a durable artifact.
**Cost:** days. **Signal:** the first place a vacuous formalization of a PDE would be caught in-kernel by this lab.

## Rung 1 — a discrete cascade model with a provable arrest/blow-up dichotomy

**What:** A finite-dimensional dyadic (shell) model of the energy cascade — Katz–Pavlović / Friedlander–Pavlović style — where "vortex stretching" is a quadratic nonlinearity pushing energy to higher shells and "viscosity" is linear damping growing with shell index. Formalize on `Fin N → ℝ` (or `ℕ → ℝ` with finite support). Prove: (a) an energy inequality; (b) for the *inviscid* model, finite-time blow-up of a critical-type norm from smooth data — a **known theorem** (Katz–Pavlović 2005 for the dyadic model); or (c) for viscous damping strong enough, global bounds.
**Toward:** this is the trunk's *dichotomy* — stretching-driven concentration vs. dissipative arrest — in the one setting where it is fully resolved. The critical-norm concentration mechanism is the same shape.
**Not:** the true equations. No pressure, no non-locality, no incompressibility geometry. The model is famous precisely because it *removes* the pressure term the trunk asks about.
**Fence:** inside — reals, finite sequences, ODE-level calculus; needs care with `ℝ`-valued ODE existence in Mathlib. **Partial credit:** (a) alone is a result; (b) is the first kernel-checked blow-up construction of any kind in this lab.
**Cost:** (a) days; (b) weeks — real analysis in Lean is slow. **Signal:** high. A kernel-checked "yes, stretching wins" *in a model* is a real step, and it must be labeled "in a model" on every line.

## Rung 2 — Beale–Kato–Majda in a finite-dimensional or 2D setting

**What:** The BKM criterion says: if a smooth 3D Euler/NS solution loses regularity at $T^*$, then $\int_0^{T^*}\|\omega\|_{L^\infty}\,dt = \infty$. Formalize and prove a *finite-dimensional Grönwall analogue* (an ODE-system BKM), or the 2D statement where global regularity is known (vorticity is transported, no stretching).
**Toward:** BKM is the theorem that makes vortex stretching *the* question — it says blow-up requires vorticity to blow up. Proving even the 2D or ODE shadow puts the trunk's central mechanism in the kernel.
**Not:** the 3D estimate (needs Calderón–Zygmund / log-Sobolev machinery Mathlib lacks).
**Fence:** the ODE/Grönwall version is inside; 2D needs a working `curl` and Biot–Savart, which is Rung 0 work first. **Partial credit:** Grönwall-BKM is a clean lemma; 2D is a real result.
**Cost:** Grönwall version days; 2D weeks-to-months.

## Rung 3 — the critical scaling itself, as algebra

**What:** Prove in Lean that the Navier–Stokes scaling $u_\lambda(x,t) = \lambda u(\lambda x, \lambda^2 t)$ leaves $\|u\|_{L^3}$ and $\|u\|_{\dot H^{1/2}}$ invariant and *not* $\|u\|_{L^2}$ — i.e. that these norms are exactly critical. Requires defining the homogeneous norms; the proof is a change of variables.
**Toward:** the trunk's entire framing ("scale-invariant critical norms") rests on this fact. It is the reason $L^3$ is the endpoint at all.
**Not:** anything dynamical. Pure scaling algebra.
**Fence:** needs $L^p$ (exists) and a definition of $\dot H^{1/2}$ (does not — Rung 0 work). **Partial credit:** the $L^3$ half alone is inside the fence today. **Cost:** $L^3$ half: days.

## Rung 4 — Ladyzhenskaya–Prodi–Serrin at an easy endpoint (2D, or with a strong a priori bound)

**What:** The 2D global regularity theorem for Navier–Stokes (Ladyzhenskaya 1959) — the case where the trunk's answer is known and is "dissipation wins," because 2D vorticity is transported without stretching.
**Toward:** the trunk's *other* horn, proven where it is true. The contrast between 2D (no stretching → arrest) and 3D (stretching → open) *is* the trunk question.
**Not:** 3D. **Fence:** far outside today — needs Sobolev embeddings, Ladyzhenskaya's inequality, weak-solution theory. Months of Rung-0-style library building first. **Listed so the ladder shows where the fence ends**, not as a candidate first rung.

## Rung ∞ — the trunk

Held verbatim in `QUESTION.md`. Not on the ladder. The ladder is *toward* it.

---

## The seat's recommendation, offered not decided

**Rung 0 first, then Rung 1(a) → 1(b).** Rung 0 because it is inside the fence today, because it is *literally* the §18 line's first real customer (certifying that a PDE statement means what it says), and because every higher rung is built on it. Rung 1 because it is the trunk's dichotomy in the setting where it is *decided*, so a kernel-checked blow-up in the dyadic model is a genuine step with a name — and because it forces this lab to do real analysis in Lean, which Alpha 1 did not.

Against: Rung 0 is instrument-flavored and §18.9's sixth kill criterion watches for exactly that. The defense is that Rung 1 is committed alongside it, and Rung 0's certificates are *for* Rung 1's definitions. If Rung 0 lands and no Rung 1 attempt follows within the round, the criterion fires.

**Anthony picks.** The seat freezes whichever rung he names, elaborates it, and asks grok for the counter-sign — same sequence as Alpha 1, through `scripts/round.py`.
