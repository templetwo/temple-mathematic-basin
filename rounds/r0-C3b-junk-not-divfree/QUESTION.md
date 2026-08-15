# r0-C3b-junk-not-divfree

Rung 0 · C3b for DivFree — grok's vacuity mutant (e₀ off the origin, 0 at it) is NOT divergence-free under the corrected definition: it fails the Differentiable conjunct at 0. Under the OLD definition it was provably DivFree (kernel-verified, certs.lean junk_old_divFree). Toward the trunk, not the trunk.

Parent: rounds/alpha2 (alpha2-prereg-v1). Definition under certificate: `DivFree u := Differentiable ℝ u ∧ ∀ x, div u x = 0` (corrected per board #18056).
