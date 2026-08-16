# agent6_4 — Rung 4, pass 6: 2D vorticity transport of the convective term

This statement is the pointwise 2D vorticity-transport identity for the convective term of a C² two-dimensional field (vertical component of curl((u·∇)u) = (u·∇)ω₂ + (div u)ω₂); it is not the 2D vorticity equation and not Ladyzhenskaya's theorem — no time, no viscosity, no maximum principle, no solutions; those stay cited.

## (a) What the theorem says (typed honestly)

For every `u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)` with `ISTWOD u` (u₂ ≡ 0 and ∂₂u ≡ 0, the frozen 2D predicate) and `ContDiff ℝ 2 u`, and every point `x`:

    (CURL (CONVECT u) x) 2 = (∑ i : Fin 3, u x i * PD_SCALAR (fun y => CURL u y 2) i x) + (DIV u x) * (CURL u x 2)

i.e. with ω₂ := ∂₀u₁ − ∂₁u₀ the scalar (vertical) vorticity,

    ∂₀((u·∇)u)₁ − ∂₁((u·∇)u)₀ = u₀ ∂₀ω₂ + u₁ ∂₁ω₂ + u₂ ∂₂ω₂ + (∂₀u₀ + ∂₁u₁ + ∂₂u₂) ω₂ ,

where the u₂ ∂₂ω₂ summand and the ∂₂u₂ summand are present in the statement (the sums run over Fin 3 verbatim) and are zero under ISTWOD. All partials are Mathlib's total `fderiv` in the basis directions `EuclideanSpace.single i 1`; the vorticity partial `PD_SCALAR (fun y => CURL u y 2) i x` is `fderiv ℝ (fun y => (CURL u y) 2) x (e i)`, the derivative of the scalar function y ↦ ω₂(y).

Machine-checked: exactly this pointwise identity, for all C² 2D fields, at every point, in the kernel. It is the 2D specialisation of curl((u·∇)u) = (u·∇)ω − (ω·∇)u + (div u)ω in which the stretching term (ω·∇)u vanishes identically (that vanishing is r4-twoD-zero-stretching, NOT restaged here — the identity is proved directly for the vertical component from the product rule, Clairaut, and ISTWOD). It is the full identity as targeted; the div-free specialisation (pure transport (curl(convect u))₂ = (u·∇)ω₂) is an immediate corollary and was not needed as a fallback.

What a reader might over-read: there is no time variable, no ∂ₜ, no viscosity, no pressure, no solution of any equation, no maximum principle, no a-priori bound. It says only that for a C² 2D field the vertical curl of the convective term is the convective derivative of the vertical vorticity plus (div u)·ω₂ — the algebraic reason 2D vorticity is transported (Ladyzhenskaya's mechanism), not the theorem that uses it. Also: it does not say the horizontal components of curl(convect u) vanish (they do under ISTWOD, but that is not in this statement).

## (b) Load-bearing hypotheses

- `ContDiff ℝ 2 u` — load-bearing three times: (i) `Differentiable ℝ u` (so `fderiv ℝ u` is the real derivative, and the coordinate functions `fun y => u y i` are differentiable — `hui`, via `differentiable_piLp`), (ii) `Differentiable ℝ (fderiv ℝ u)` via `ContDiff.fderiv_right (m := 1)` so the partials `fun y => fderiv ℝ u y (e k)` and their scalar components are differentiable — this is what makes the product rule (`HasFDerivAt.smul`), `fderiv_fun_sub`, `fderiv_clm_apply` and the projection compositions honest instead of totalized-fderiv junk; (iii) Clairaut `ContDiffAt.isSymmSndFDerivAt` (`minSmoothness ℝ 2 ≤ 2` by `simp [minSmoothness_of_isRCLikeNormedField]`), which cancels the ∑ᵢ uᵢ(∂ᵢ∂ⱼ − ∂ⱼ∂ᵢ)u terms.
- `ISTWOD u`, both conjuncts: `u x 2 = 0` kills the i = 2 summands (u₂ ∂₂ω₂ on the right, u₂ ∂ⱼ∂₂u on the left) and, via the derivative of the zero function `fun y => u y 2` (transported to `(fderiv ℝ u x (e i)) 2 = 0` through the coordinate-projection lemma `hproj`), kills the ∂ᵢu₂ terms; `fderiv ℝ u y (e 2) = 0` kills ∂₂u₀, ∂₂u₁, ∂₂u₂ (the ∂₂u₂ summand of DIV, and the ∂₂uₖ factors in the i = 2 product-rule terms). Without ISTWOD the mixed terms ∂₀u₂ ∂₂u₁ − ∂₁u₂ ∂₂u₀ survive — that is exactly the −(ω·∇)u₂ stretching term of the 3D identity, so the statement is FALSE for general 3D fields; ISTWOD is what makes it transport-only.
- `x` arbitrary; nothing else.

## (c) Mathlib names hunted for on this pin (Lean 4.32.2)

- `HasFDerivAt.smul` (Analysis/Calculus/FDeriv/Mul.lean) gives the derivative of `c • f` (Pi-smul); the goal has `fun y => c y • f y`, so the `have hF : HasFDerivAt (fun y => …) _ x := …` type ascription (defeq) is needed before `.fderiv` — there is no `HasFDerivAt.fun_smul` / `fun_add` on this pin.
- Deprecated on this pin: `ContinuousLinearMap.add_apply`, `.smul_apply`, `.sub_apply` → use the root `add_apply`, `smul_apply`, `sub_apply` (linter warns otherwise). `ContinuousLinearMap.smulRight_apply` and `ContinuousLinearMap.flip_apply` are still current.
- `PiLp.hasFDerivAt_apply (𝕜 := ℝ) 2 (f : PiLp 2 _) i` — the point must be given explicitly (precedent lesson); its `.comp` with `(hd0 x).hasFDerivAt` yields the derivative of `(fun f => f.ofLp i) ∘ u`, which `rw` will not match against `fun y => (u y).ofLp i` — again fixed by a `have h3 : HasFDerivAt (fun y => u y i) (…) x := hg.comp x …` ascription.
- `fderiv_fun_sub` (not `fderiv_sub`) for the lambda difference; `differentiable_piLp 2` (explicit `p`) for coordinate-wise differentiability; `fderiv_clm_apply` → `.flip` for the vector second derivative; `Matrix.cons_val` dsimproc reduces `![a,b,c] 2` under the binder in `PD_SCALAR (fun y => CURL u y 2)`.
- `(WithLp.toLp 2 v) k` reduces to `v k` by projection reduction inside `simp only` with no lemma needed.

## Proof shape (for the next transporter)

1. Differentiability: `hd0`, `h1`, `hfk`, `hpdd`, `hui` (as in r0-div-of-curl-zero plus the coordinate functions of u).
2. `hproj i j : fderiv ℝ (fun y => u y i) x (e j) = fderiv ℝ u x (e j) i` (coordinate projection).
3. `hclm`, `hcomp`, `hsc k m j : fderiv ℝ (fun y => fderiv ℝ u y (e k) m) x (e j) = fderiv ℝ (fderiv ℝ u) x (e j) (e k) m` — canonical second-derivative form; `hsymm i j` Clairaut on that form.
4. `hC j k`: k-th component of ∂ⱼ of the (Fin.sum_univ_three-expanded) convective term = ∑ᵢ (uᵢ · ∂ⱼ∂ᵢuₖ + ∂ⱼuᵢ · ∂ᵢuₖ), by `HasFDerivAt.smul`/`.add`, `.fderiv`, then `simp only [add_apply, smul_apply, smulRight_apply, PiLp.add_apply, PiLp.smul_apply, smul_eq_mul, hclm, hproj, flip_apply]`.
5. `simp only [Fin.sum_univ_three, Matrix.cons_val]; rw [hC 0 1, hC 1 0]`; `hsub i` splits `fderiv` of ω₂ into second derivatives (`fderiv_fun_sub`, `hsc`); `hpdi2 i : ∂ᵢu₂ = 0` (derivative of the zero coordinate function through `hproj`); `hz2 k : (∂₂u)ₖ = 0`.
6. `rw [hsub 0, hsub 1, hsub 2, hsymm 1 0]; simp only [h2 x, hpdi2, hz2]; ring`.

## (d) Not proved / UNKNOWN

Nothing left open — the full targeted identity (with the (div u)ω₂ term, no div-free hypothesis) closed. `lake env lean tmp/agent6_4/work.lean` → exit 0, zero errors, zero warnings. No `sorry`, `native_decide`, `decide`, `axiom`, `set_option`, no `open`, only `import Mathlib`. Not claimed: horizontal components of curl(convect u), anything about div-free fields specifically, anything with time.
