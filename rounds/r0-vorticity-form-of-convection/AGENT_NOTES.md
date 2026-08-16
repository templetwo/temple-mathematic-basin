# agent6_0 — Rung 0, pass 6: vortex stretching EMERGES from the convective term

This statement is the pointwise vorticity-form identity for the convective term of a C² field on ℝ³; it is not the vorticity equation (no time, no pressure, no viscosity, no solution).

## (a) What the theorem says (typed honestly)

For every vector field `u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)` with `ContDiff ℝ 2 u`, and every point `x`, with `ω := CURL u`,

    CURL (CONVECT u) x = (∑ i, u x i • PD_VEC (CURL u) i x) − STRETCH u x + (DIV u x) • CURL u x

i.e. the classical `∇×((u·∇)u) = (u·∇)ω − (ω·∇)u + (∇·u) ω`, where CURL / CONVECT / PD_VEC / STRETCH / DIV are the frozen lambdas from `tmp/LAMBDAS/*.txt` pasted verbatim (`∂ᵢ f x := fderiv ℝ f x (EuclideanSpace.single i 1)`, Mathlib's TOTAL `fderiv`). The "(u·∇)ω" term is written inline as `∑ i, (u x i) • PD_VEC (CURL u) i x` (the convective derivative applied to the field CURL u), exactly as the target asked.

Machine-checked: exactly the sentence above — the full identity, all three components, no extra hypothesis (no DivFree, no single-component restriction). Nothing dropped.

What a reader might over-read, and must not:
- This is a pointwise algebraic/differential identity about ONE C² field at ONE point. There is no time variable, no pressure, no viscosity, no Navier–Stokes or Euler solution, no integration, no boundary. It certifies that the vortex-stretching term `(ω·∇)u` (the frozen STRETCH lambda) is what the curl of the convective term produces — i.e. stretching EMERGES from `∇×((u·∇)u)` rather than being merely defined — but it does not say anything happens dynamically.
- The `(∇·u) ω` term is present because divergence-freeness is NOT assumed; under `DivFree u` it vanishes and the identity reduces to `∇×((u·∇)u) = (u·∇)ω − (ω·∇)u`. That reduction is one line downstream, not part of this ring.
- Without `ContDiff ℝ 2 u` the sentence is not even meaningful as stated: for a merely C¹ field the outer `fderiv`s (of the convective field and of the curl field) are Mathlib's junk value 0 wherever those fields are not differentiable, while the first-order product terms `∑ᵢ ∂ⱼuᵢ·∂ᵢu_k` on the STRETCH/DIV side are not zero, so the identity would generally FAIL. The C² hypothesis is what makes every `fderiv` in the statement honest, and it sits IN the statement for that reason.

## (b) Load-bearing hypotheses

- `ContDiff ℝ 2 u` — load-bearing three times:
  1. `Differentiable ℝ u` (for the product rule on `u y i • ∂ᵢu y`, `HasFDerivAt.smul`) and `Differentiable ℝ (fderiv ℝ u)` via `ContDiff.fderiv_right (m := 1)`, which makes each `fun y => ∂ᵢu y` and each scalar `fun y => ∂ᵢu y m` differentiable (`differentiable_piLp 2`), so the fderivs of the convective field and of the curl field are the real derivatives, not the totalized junk;
  2. Clairaut symmetry `∂ⱼ∂ᵢuₘ = ∂ᵢ∂ⱼuₘ` (`ContDiffAt.isSymmSndFDerivAt`, `minSmoothness ℝ 2 ≤ 2` discharged by `simp [minSmoothness_of_isRCLikeNormedField]`), which is exactly what converts the second-order part `∑ᵢ uᵢ ∂ₐ∂ᵢu_b` of `∇×((u·∇)u)` into `∑ᵢ uᵢ ∂ᵢ(∂ₐu_b)`, i.e. into `(u·∇)ω`;
  3. the differentiability of the curl field as a `PiLp`-valued map (`differentiableAt_piLp 2`), needed to extract coordinates of `fderiv (CURL u) x (e j)`.
- Nothing else. `x` is arbitrary. No divergence-free hypothesis (the `(DIV u x) • CURL u x` term carries it).

## (c) Mathlib names hunted for on this pin (Lean 4.32.2)

- `HasFDerivAt.smul` gives the derivative of the Pi-smul `c • f`, i.e. `HasFDerivAt (c • f) (c x • f' + c'.smulRight (f x)) x`; a `have` with the lambda-shaped type `HasFDerivAt (fun y => u y i • fderiv ℝ u y (e i)) … x` is accepted by defeq, and `.add` chains then produce the exact expanded-sum lambda the goal carries after `simp only [Fin.sum_univ_three]`, so `rw [hF.fderiv]` matches syntactically.
- `fderiv_fun_smul` / `fderiv_fun_add` / `fderiv_fun_sum` are the lambda-shaped versions (the un-`fun_` names are Pi-shaped) — same lesson as `fderiv_fun_sub` in agent_0.
- `ContinuousLinearMap.add_apply` is DEPRECATED on this pin (warning) — use root `add_apply` (same for `smul_apply`, per the brief).
- `fin_cases k` on the main goal leaves the index as `(fun i => i) ⟨0, ⋯⟩`; `simp only [Fin.reduceFinMk, …]` normalizes it to the numeral `0/1/2` so that `Matrix.cons_val` and the ∀-shaped rewriting lemmas (`hconv`, `hcurlpd`) fire. `Fin.isValue` was not needed. `PiLp.toLp_apply` was NOT needed (unused-simp-arg lint) — `Matrix.cons_val` already sees through `(toLp 2 ![…]).ofLp k`.
- Coordinate extraction of a vector-valued fderiv: `PiLp.hasFDerivAt_apply (𝕜 := ℝ) 2 (F x) m` composed with `HasFDerivAt` of `F`, then `.fderiv` and `congrArg (fun L => L (e j))`; `exact` closes up to defeq of `(fun f => f m) ∘ F` with `fun y => F y m` and of `(PiLp.proj m ∘L L) v` with `(L v) m` (both directions used: `hcoord1` for `u`, `hc` for the curl field, `hcomp`/`hcoord2` for `∂ᵢu`).
- The final per-component closure is `linear_combination ∑ᵢ (u x i) * hsymm i a b − (u x i) * hsymm i b a` with `(a,b) = (1,2),(2,0),(0,1)` for components 0,1,2 — the first-order products cancel by `ring` inside `linear_combination`; only the second-order terms need Clairaut.

## Proof shape (for the next transporter)

1. `simp only [Fin.sum_univ_three]` — beta-reduces every lambda, expands all four sums (inside the fderiv of the convective field too).
2. Differentiability facts `h1, hu1, hfk, hpdd, hum` (all from `ContDiff ℝ 2 u`).
3. `hclm`, `hcomp`, `hsymm` — agent_0's Clairaut block, unchanged.
4. `hcoord1 : ∂ⱼ(uₘ) = (∂ⱼu)ₘ`, `hcoord2 : (∂ⱼ(∂ᵢu))ₘ = ∂ⱼ(∂ᵢuₘ)`.
5. `hconv j k : (fderiv CONVF x (e j)) k = ∑ᵢ (uᵢ · ∂ⱼ∂ᵢu_k + ∂ⱼuᵢ · ∂ᵢu_k)` — product rule via `HasFDerivAt.smul`/`.add`, then `simp only [add_apply, smul_apply, ContinuousLinearMap.smulRight_apply, PiLp.add_apply, PiLp.smul_apply, smul_eq_mul, hcoord1, hcoord2]` closes it exactly (RHS written in the order simp produces: `u * D2 + D1 * D1`).
6. `hsub`, `hF`, `hc` — agent_0's curl-field block; `hcurlpd j k : (fderiv CURLF x (e j)) k = ![∂ⱼ(∂₁u₂)−∂ⱼ(∂₂u₁), …] k` by `fin_cases k` + `exact hsub …`.
7. `ext k; fin_cases k`, per component `simp only [Fin.reduceFinMk, PiLp.add_apply, PiLp.sub_apply, PiLp.smul_apply, Matrix.cons_val, smul_eq_mul, hconv, hcurlpd]` then the `linear_combination` above.

## (d) Not proved / UNKNOWN

Nothing left open. The full identity closed; no conjunct dropped, no DivFree fallback needed, no single-component fallback needed.
`lake env lean tmp/agent6_0/work.lean` → exit 0, zero errors, zero warnings (~40 s).
No `sorry`, `native_decide`, `decide`, `axiom`, `set_option`, no `open`, only `import Mathlib`. Statement text assembled by `gen.py` from `tmp/LAMBDAS/{CURL,CONVECT,PD_VEC,STRETCH,DIV}.txt` verbatim (`.strip()` of trailing newline only).
