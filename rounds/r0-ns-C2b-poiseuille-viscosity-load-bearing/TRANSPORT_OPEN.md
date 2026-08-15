# Harness transport open — 2026-08-15

The mathematics is kernel-checked in lake (`rounds/alpha2/rung0/phase2.lean`: `pois_steady`, `lap_pois_ne_zero`, `pois_wrong_viscosity` — exit 0, zero sorry). The frozen statement elaborates through verdict.py. The staged attempt body does NOT compile in the standalone-statement context: with `pois`, `e`, `P1` as `let`-bindings inside a 5 KB inline term, `rw` and `simp` lose the definitional identity that named top-level `def`s give in lake (the same class as the CLM-identity issue at #18193, but deeper — second derivatives of a non-CLM field).

`scripts/preflight_body.py` (phase 2 #10) caught this BEFORE it hit the ledger — which is the tool doing its job. No attempt fired: firing a body known to REJECT would only add a proof-shape dead-end, and the ledger already has enough of those to prove the harness fail-closes correctly.

**Status:** frozen, elaborated, lake-proven, harness-transport OPEN. Typed per PREREG §2.4 as ELABORATION_ERROR-in-transport, not as any doubt about the theorem. **Next angle (re-entry data):** either (a) a `verdict.py`-side `let`-to-`def` prelude (registered instrument change → prereg v3), or (b) a body that avoids `rw` entirely and drives every step with `HasFDerivAt` composition + `simp only` — real work, not string-patching. Grok is asked whether (a) is worth a re-registration.
