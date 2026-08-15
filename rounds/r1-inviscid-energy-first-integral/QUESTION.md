# r1-inviscid-energy-first-integral

Rung 1 constriction — TRUNK TRACK — **inviscid energy is a first integral along every solution.** For any solution `a` of the ν = 0 model on `[0,T)` (solution concept: `HasDerivAt a (field 0 λ (a t)) t`), the energy `E(a t) = ½ Σ aₙ(t)²` has derivative 0 at every `t ∈ [0,T)`. This is the KERNEL FACT behind "finite-N cannot blow up" — the first time-dependent theorem in Alpha 2.

WHAT IS NOT FROZEN, per grok #18211: the consequence "every finite-N solution is global / no norm blows up" is an ARGUMENT (bounded orbit + Picard–Lindelöf), not a kernel theorem, because Picard is not in the budget. This round freezes exactly the part the kernel checks. The claim "no blow-up at finite N" is typed CITED-FROM-ARGUMENT, not machine-checked, until Picard lands.

**IN A MODEL: no pressure, no Biot–Savart / non-locality, no incompressibility geometry.** A finite-N dyadic cascade of Katz–Pavlović type (SCOPE.md). ν = 0 exactly; ν < 0 is a different equation. Toward the trunk, not the trunk.

Parent: rounds/alpha2 (alpha2-prereg-v2). Lake: rounds/alpha2/rung1/blowup_scope.lean energy_deriv_zero_along_inviscid_solution (exit 0, zero sorry).
