# agent_0 — Rung 0 vocabulary ring: div (curl u) = 0

## (a) What the theorem says (typed honestly)

For every vector field `u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)` that is
`ContDiff ℝ 2` (C²), and every point `x`, `DIV (CURL u) x = 0`, where `DIV` and `CURL` are the
frozen lambdas from `tmp/LAMBDAS/DIV.txt` and `tmp/LAMBDAS/CURL.txt` (pasted verbatim), i.e.

    ∑ i : Fin 3, fderiv ℝ (fun x => toLp 2 ![∂₁u₂−∂₂u₁, ∂₂u₀−∂₀u₂, ∂₀u₁−∂₁u₀]) x (e i) i = 0

with `∂ᵢ f x := fderiv ℝ f x (EuclideanSpace.single i 1)`.

Machine-checked: exactly the sentence above, with Mathlib's TOTAL `fderiv`. What a reader might
over-read: this is the classical identity "vorticity is solenoidal" for C² fields; it says nothing
about fields that are merely C¹ (there `fderiv` of the curl field is the junk value 0 off the
differentiable locus and the sum is trivially 0 for the wrong reason — that is exactly why the C²
hypothesis sits IN the statement). It is a pointwise identity, no integration, no boundary,
no Navier–Stokes content. Vocabulary certification only: toward the trunk, not the trunk.

## (b) Load-bearing hypotheses

- `ContDiff ℝ 2 u` — load-bearing twice: (i) `fderiv ℝ u` is differentiable (`ContDiff.fderiv_right (m:=1)`),
  which is what makes each curl component `fun y => fderiv ℝ u y (e k) m` differentiable, so
  `fderiv_fun_sub`, `differentiableAt_piLp` and the projection-composition rewrites are honest and
  not the totalized-`fderiv` junk; (ii) Clairaut symmetry `ContDiffAt.isSymmSndFDerivAt` needs
  `minSmoothness ℝ 2 ≤ 2`, discharged by `simp [minSmoothness_of_isRCLikeNormedField]`.
- Nothing else. `x` is arbitrary.

## (c) Mathlib names hunted for on this pin (Lean 4.32.2)

- `fderiv_sub` on this pin is stated for the Pi-subtraction `f - g`; the lambda form
  `fun y => f y - g y` is `fderiv_fun_sub`. (The `rw` with `fderiv_sub` failed for exactly this reason.)
- `differentiable_piLp` / `differentiableAt_piLp` (Mathlib.Analysis.Calculus.FDeriv.WithLp) — `p` is an
  EXPLICIT arg: `(differentiable_piLp 2).mp`. Gives coordinate-wise differentiability of a PiLp-valued map,
  which is how the component `fun y => fderiv ℝ u y (e k) m` is shown differentiable without `EuclideanSpace.proj`.
- `PiLp.hasFDerivAt_apply (𝕜 := ℝ) 2 (f : PiLp 2 _) i : HasFDerivAt (fun f => f i) (PiLp.proj 2 _ i) f`
  — the point `f` MUST be given explicitly; with `_` the elaborator leaves `?g` unresolved in `HasFDerivAt.comp`
  and reports a type mismatch (`?g ∘ F` vs a lambda is not a Miller pattern). Same for `(f := F)` on `.comp`
  in the vector-valued case.
- `PiLp.proj_apply` (simps-generated), `ContinuousLinearMap.flip_apply`, `ContinuousLinearMap.comp_apply`.
- `Matrix.cons_val` is a dsimproc: `simp only [Matrix.cons_val]` reduces `![a,b,c] 0/1/2` under binders.
- Coordinate application of a `EuclideanSpace` value elaborates as `WithLp.ofLp v m` (displayed `v.ofLp m`);
  hypotheses written as `fderiv ℝ u y (EuclideanSpace.single k (1:ℝ)) m` match the post-`simp only` goal.

## Proof shape (for the next transporter)

1. `simp only [Fin.sum_univ_three]` — beta-reduces the DIV/CURL/PD/E redexes and expands the sum.
2. `h1 : Differentiable ℝ (fderiv ℝ u)`; `hfk`: each `fun y => fderiv ℝ u y (e k)` differentiable;
   `hpdd`: each scalar component differentiable via `differentiable_piLp`.
3. `hsymm i j m`: `∂ⱼ(∂ᵢu m) = ∂ᵢ(∂ⱼu m)`, via `fderiv_clm_apply` (→ `.flip`), `PiLp.hasFDerivAt_apply.comp`
   (→ `PiLp.proj ∘L`), then `isSymmSndFDerivAt`.
4. `hsub`: `fderiv` of a difference of components splits (`fderiv_fun_sub` + `rfl`).
5. `hF`: the curl field is `DifferentiableAt` (`differentiableAt_piLp` + `fin_cases`).
6. `hc j i`: `(fderiv CURL x (e j)) i = fderiv (fun y => ![c0 y,c1 y,c2 y] i) x (e j)` via
   `PiLp.hasFDerivAt_apply.comp` and `congrArg`.
7. `rw [hc 0 0, hc 1 1, hc 2 2]; simp only [Matrix.cons_val]; rw [hsub, hsub, hsub]; linarith [hsymm 1 0 2, hsymm 2 0 1, hsymm 2 1 0]`.

## (d) Not proved / UNKNOWN

Nothing left open. `lake env lean tmp/agent_0/work.lean` → exit 0, zero errors, zero warnings.
No `sorry`, `native_decide`, `decide`, `axiom`, `set_option`, no `open`, only `import Mathlib`.
