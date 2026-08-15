import Mathlib

/-!
# Alpha 2 · Rung 1 — the dyadic cascade model (Katz–Pavlović)

State `a : Fin N → ℝ`. Wavenumber `λ > 1` (Katz–Pavlović use 2). Viscosity `ν ≥ 0`.
Truncation `a₋₁ := 0`, `a_N := 0` (finite model).

  aₙ' = −ν λ^{2n} aₙ  +  λⁿ aₙ₋₁²  −  λⁿ⁺¹ aₙ aₙ₊₁

The middle term is "stretching": energy pumped UP from shell n−1. The last
term is the same energy leaving shell n for n+1. They telescope in the energy
sum, so the cascade CONSERVES energy and only viscosity dissipates it. That
telescoping is Rung 1(a).

Toward the trunk, not the trunk: no pressure, no non-locality, no
incompressibility geometry. In a model.
-/

noncomputable section

variable {N : ℕ}

/-- previous shell, `0` below the bottom -/
def prev (a : Fin N → ℝ) (n : Fin N) : ℝ :=
  if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else 0

/-- next shell, `0` above the top -/
def next (a : Fin N → ℝ) (n : Fin N) : ℝ :=
  if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else 0

/-- the cascade nonlinearity at shell `n` -/
def cascade (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) : ℝ :=
  lam ^ n.val * (prev a n) ^ 2 - lam ^ (n.val + 1) * a n * next a n

/-- the viscous term at shell `n` -/
def damping (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) : ℝ :=
  - nu * lam ^ (2 * n.val) * a n

/-- the full vector field of the model -/
def field (nu lam : ℝ) (a : Fin N → ℝ) : Fin N → ℝ :=
  fun n => damping nu lam a n + cascade lam a n

/-- energy `½ Σ aₙ²` -/
def energy (a : Fin N → ℝ) : ℝ := (1/2) * ∑ n, (a n) ^ 2

/-- rate of energy along the field: `Σ aₙ · fieldₙ` (the chain rule, as algebra) -/
def energyRate (nu lam : ℝ) (a : Fin N → ℝ) : ℝ := ∑ n, a n * field nu lam a n

/-- the dissipation `ν Σ λ^{2n} aₙ²` -/
def dissipation (nu lam : ℝ) (a : Fin N → ℝ) : ℝ := nu * ∑ n, lam ^ (2 * n.val) * (a n) ^ 2

end
