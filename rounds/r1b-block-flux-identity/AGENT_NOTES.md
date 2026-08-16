# agent7_1b — Rung 1(b), program (b3), ring 2: interior-shell BLOCK-FLUX identity of the finite-N dyadic cascade

This statement is the algebraic block-flux identity of the finite-N dyadic cascade of KP type — the energy rate of shells ≥ k equals the incoming cascade flux at shell k minus the viscous drain of those shells, per state, uniform in N; it is not a statement along solutions (no time), not blow-up, not the trunk (no pressure, no Biot–Savart, no incompressibility).

## (a) What the theorem says (one sentence, typed honestly)

For every shell count N, every ν, λ : ℝ (no sign or size hypotheses), every state a : Fin N → ℝ and every
interior index k < N,

    Σ_{n ≥ k} aₙ · FIELDₙ(ν, λ, a)  =  λ^k · a_k · (a_{k−1})²  −  ν · Σ_{n ≥ k} λ^{2n} aₙ²

where the sums are `∑ n ∈ Finset.univ.filter (fun n : Fin N => k ≤ n.val), …` (the filtered form asked for
in the task — no switch to the `if k ≤ n.val then … else 0` form was needed) and a_{k−1} is the PREV
sub-lambda copied byte-for-byte from FIELD.txt (`if h : 0 < n.val then a ⟨n.val - 1, _⟩ else 0`), so at k = 0
the flux term is λ^0 · a_0 · 0² = 0.

What is machine-checked:
- the pointwise split aₙ·FIELDₙ = aₙ·CASCADEₙ − ν·λ^{2n}aₙ² (`hsplit`, dsimp + ring);
- the telescoping of the cascade block Σ_{n ≥ k} aₙ·CASCADEₙ to the single incoming flux λ^k a_k a_{k−1}²
  (`hind`): a downward induction on the co-index j = N − m, generalized over m, with the peel lemma
  `hpeel : Σ_{n ≥ m} f n = f ⟨m,_⟩ + Σ_{n ≥ m+1} f n` (m < N) and the empty case `hempty : Σ_{n ≥ N} f n = 0`;
  the inductive step is exactly the cancellation λ^{m+1} a_m² a_{m+1} (outgoing at m) = λ^{m+1} a_{m+1} a_m²
  (incoming at m+1), with the `if h : m+1 < N` guard of NEXT killing the outgoing term at the top shell.

What a reader might over-read: this is a per-state polynomial identity on Fin N → ℝ. There is no time, no
solution, no ODE, no PDE, no function space, no pressure/incompressibility/Biot–Savart, no sign information
(ν, λ arbitrary reals; nothing about energy decreasing — that needs ν ≥ 0 and is Rung 1's job). "Uniform in
N" means N is universally quantified and no constant depends on it. It is the finite-N shell-model shadow of
"d/dt (energy above scale k) = flux through k − dissipation above k"; the shadow is exact here only because
the cascade is nearest-neighbour and the shell energy sum telescopes.

Two known specializations, both consequences of this statement (not separately proved here):
- k = 0: PREV a ⟨0,_⟩ = 0, so Σ_n aₙ·FIELDₙ = −ν Σ_n λ^{2n} aₙ², i.e. the full cascade orthogonality
  Σ_n aₙ·CASCADEₙ = 0 of r1-cascade-orthogonality / the `horth` of r1-viscous-energy-antitone.
- k = N−1: the top shell alone, a_{N−1}·FIELD_{N−1} = λ^{N−1} a_{N−1} a_{N−2}² − ν λ^{2(N−1)} a_{N−1}²,
  the shape behind r1b-inviscid-top-shell-monotone (with ν = 0 the top shell only ever receives).

## (b) Load-bearing hypotheses

- Nothing beyond the field's shape. `hk : k < N` is only needed to name the shell ⟨k, hk⟩ on the right-hand
  side (for k ≥ N the left side would be an empty sum and the honest RHS would be 0; the `hind` lemma inside
  the proof carries exactly that dite form `if h : m < N then flux else 0`).
- No hypothesis on ν or λ: the identity is a polynomial identity in ν, λ and the aₙ. In particular it holds
  for λ < 1 and ν < 0.
- The `if h : n.val + 1 < N` guard in NEXT (a_N = 0) is what makes the last outgoing term vanish; the
  `if h : 0 < n.val` guard in PREV (a_{−1} = 0) is what makes k = 0 recover orthogonality. Both guards are
  used verbatim (dif_pos / dif_neg on the two conditions).

## (c) Mathlib names hunted for

- `Finset.sum_filter : ∑ a ∈ s.filter p, f a = ∑ a ∈ s, if p a then f a else 0` — turns the filtered
  Fin-sum into an `if`-sum where the k-th term can be peeled pointwise.
- `Finset.sum_ite_eq' : (∑ x ∈ s, if x = a then b x else 0) = if a ∈ s then b a else 0` (primed = `x = a`
  orientation), then `if_pos (Finset.mem_univ _)`.
- `Nat.not_le : ¬ a ≤ b ↔ b < a` for the empty top block; `Fin.ext` for `n.val = j → n = ⟨j,hj⟩`.
- The dependent rewrite `a ⟨m + 1 - 1, _⟩ ↦ a ⟨m, _⟩` inside `Fin.mk` goes through `simp only [...,
  Nat.add_sub_cancel]` (rw would hit "motive is not type correct"); `ring` then identifies `a ⟨m, pf₁⟩` and
  `a ⟨m, pf₂⟩` up to proof irrelevance. `dif_pos (show 0 < m + 1 by omega)` rather than
  `dif_pos (Nat.succ_pos m)` so the simp-lemma key is `m + 1`, not `Nat.succ m`.

## (d) What could NOT be proved

Nothing was dropped. The full target statement, in the filtered form given in the task, compiles with exit 0,
zero warnings, first compile. `#print axioms` gives only [propext, Classical.choice, Quot.sound]. No `sorry`,
no `native_decide`, no `set_option`, only `import Mathlib`.

## Files

- work.lean, statement.txt, body.txt, gen.py (pastes FIELD.txt verbatim; asserts PREV, NEXT and CASC are
  substrings of FIELD).
