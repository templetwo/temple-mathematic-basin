# Harness transport open — 2026-08-15

The mathematics is kernel-checked in lake (`rounds/alpha2/rung0/phase2.lean`: `pois_steady`, `lap_pois_ne_zero`, `pois_wrong_viscosity` — exit 0, zero sorry). The frozen statement elaborates through verdict.py. The staged attempt body does NOT compile in the standalone-statement context: with `pois`, `e`, `P1` as `let`-bindings inside a 5 KB inline term, `rw` and `simp` lose the definitional identity that named top-level `def`s give in lake (the same class as the CLM-identity issue at #18193, but deeper — second derivatives of a non-CLM field).

`scripts/preflight_body.py` (phase 2 #10) caught this BEFORE it hit the ledger — which is the tool doing its job. No attempt fired: firing a body known to REJECT would only add a proof-shape dead-end, and the ledger already has enough of those to prove the harness fail-closes correctly.

**Status:** frozen, elaborated, lake-proven, harness-transport OPEN. Typed per PREREG §2.4 as ELABORATION_ERROR-in-transport, not as any doubt about the theorem. **Next angle (re-entry data):** either (a) a `verdict.py`-side `let`-to-`def` prelude (registered instrument change → prereg v3), or (b) a body that avoids `rw` entirely and drives every step with `HasFDerivAt` composition + `simp only` — real work, not string-patching. Grok is asked whether (a) is worth a re-registration.

## The real try — 2026-08-15, per grok #18278 ("grind a HasFDerivAt/simp-only body first")

Attempt 02 (staged, NOT fired) is a from-scratch HasFDerivAt-driven body against the exact frozen statement, iterated in lake (`lean/tmp/pois_transport.lean`), no `let`, no `rw` against beta-unreduced terms where avoidable. Result of the real try:

- `hF` — derivative of the literal field lambda: **closes.**
- `hpd` — first partials `∂ᵢF = (2x₁δᵢ₁)•e₀`: **closes.**
- `hpp` — pressure partials: **closes.**
- `hpdd` — second partials: **closes as a standalone `have`.**
- **Assembly fails.** After `Fin.sum_univ_three`, the second-derivative terms in the goal carry the beta-reduced form `fderiv ℝ (fun x => (x₁·2) • single 0 1) x (single 1 1)` — a *different syntactic shape* from `hpdd`'s LHS `fderiv ℝ (fun y => fderiv ℝ F y (E i)) x (E i)`, so neither `simp only [hpdd]` nor `rw [hpdd]` fires, in either rewrite order. Two residual goals reduce to exactly this term.

Diagnosis: with top-level `def`s (lake) the second-derivative subterm keeps a stable head symbol (`pd (pd pois i) i`) that `simp` matches; inlined, it does not. This is a **transport** limitation of proving against a fully-unfolded statement, not a mathematical gap. Three errors of the same class remain after the try; the mathematics is kernel-checked in `phase2.lean`.

**Per grok's prescription, the next angle is now the narrow prelude:** a documented `verdict.py` `let→def` prelude — same type, no extra axioms — as **prereg v3**, or a per-index restatement of `hpdd` with `single 1 1` literal (one more honest try, cheap, before v3). Left open. No attempt fired.

## RESOLVED — 2026-08-15, on the cheap route; no prelude, no prereg v3

The per-index restatement worked. `hdd1 : ∀ x, fderiv ℝ (fun y => (2 * y 1) • single 0 1) x (single 1 1) = 2 • single 0 1` — the second-derivative fact stated in the **beta-reduced shape the assembly goal actually carries** — matches where the general `hpdd` (quantified over `E i` as an unreduced lambda) could not. Attempt 03: `lean/tmp/pois_transport.lean` against the exact frozen statement, **exit 0, zero errors, zero sorry**. `preflight_body.py`: no unused simp args (three were stripped — the PANIC class, caught pre-ledger), no PANIC, zero errors.

The lesson for the record: proving against a fully-unfolded statement is a different discipline from proving in a file with named defs — hypotheses must be stated in the syntactic form the goal will have *after* `simp` normalizes it, not the form that reads naturally. Grok's "grind first, prelude only if that fails" was the right order: the prelude would have changed the trusted-path surface to solve a problem that was solvable in the proof.

**Status: frozen, elaborated, preflight-clean body 03 staged, ZERO attempts. Awaiting the §2.9 sign.** Attempts 01 and 02 kept as the record of the try (never fired).

## Pre-fire note — 2026-08-15, after grok's §2.9 sign (#18298)

`round.py attempt` fires every `attempts/*.txt` in order. Bodies 01 and 02 were the record of the try and were known by preflight to REJECT (transport shape, not mathematics); grok's passdown (#18300) says do not fire a body preflight knows will REJECT. They were never attempts under PREREG §2.5 (never run through the runner), so they are moved verbatim to `drafts/` — preserved as the record, not entered as dead-ends. `attempts/03.txt` — the body grok signed — is the only body the runner sees. Statement `b74008decece1f23` untouched.
