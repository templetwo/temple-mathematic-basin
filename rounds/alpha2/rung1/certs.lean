import Mathlib

/-!
# Rung 1 — definition certificates + the two identities, worked in lake

Definitions byte-copied from defs.lean. Then:
  C2 for the model: a nonzero state with nonzero cascade (the model is not trivial)
  C3 for the model: the zero state has zero field (boundary: no energy, no dynamics)
  C3b: a single-shell state a = e₀ has ZERO cascade (nothing to stretch from below,
       nothing above to receive) but nonzero damping — separates the two terms
  cascade_orthogonality: Σ aₙ · cascadeₙ = 0            (r1-cascade-orthogonality)
  energy_inequality:     Σ aₙ · fieldₙ = −dissipation   (r1a-energy-inequality)
-/

noncomputable section
variable {N : ℕ}

def prev (a : Fin N → ℝ) (n : Fin N) : ℝ :=
  if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else 0
def next (a : Fin N → ℝ) (n : Fin N) : ℝ :=
  if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else 0
def cascade (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) : ℝ :=
  lam ^ n.val * (prev a n) ^ 2 - lam ^ (n.val + 1) * a n * next a n
def damping (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) : ℝ :=
  - nu * lam ^ (2 * n.val) * a n
def field (nu lam : ℝ) (a : Fin N → ℝ) : Fin N → ℝ :=
  fun n => damping nu lam a n + cascade lam a n
def dissipation (nu lam : ℝ) (a : Fin N → ℝ) : ℝ := nu * ∑ n, lam ^ (2 * n.val) * (a n) ^ 2

/-! ## The telescoping core -/

/-- `Σ aₙ · λⁿ · prevₙ²` reindexed: it equals `Σ_{m+1<N} λ^{m+1} a_{m+1} a_m²`,
which is `Σₘ λ^{m+1} · aₘ² · nextₘ`. Proven via `Fin.sum_univ_succ`-style
induction on N with the two truncations handled at the ends. -/
theorem cascade_orthogonality (lam : ℝ) (a : Fin N → ℝ) :
    ∑ n, a n * cascade lam a n = 0 := by
  induction N with
  | zero => simp
  | succ M ih =>
    -- Write both sums over Fin (M+1) via castSucc/last split.
    -- Key: term n of the "prev" sum equals term (n-1) of the "next" sum, for n ≥ 1;
    -- the n=0 "prev" term is 0 (prev at bottom), the n=M "next" term is 0 (next at top).
    simp only [cascade, mul_sub, Finset.sum_sub_distrib]
    -- Reindex the prev-sum with Fin.sum_univ_succ, the next-sum with Fin.sum_univ_castSucc.
    rw [Fin.sum_univ_succ, Fin.sum_univ_castSucc]
    -- bottom prev term = 0, top next term = 0
    have hbot : prev a (0 : Fin (M+1)) = 0 := by simp [prev]
    have htop : next a (Fin.last M) = 0 := by simp [next]
    have hp : ∀ i : Fin M, prev a i.succ = a i.castSucc := by
      intro i; simp only [prev, Fin.val_succ, Nat.add_sub_cancel]
      rw [dif_pos (Nat.succ_pos _)]; rfl
    have hn : ∀ i : Fin M, next a i.castSucc = a i.succ := by
      intro i; simp only [next, Fin.coe_castSucc]
      rw [dif_pos (by omega)]; rfl
    simp only [hbot, htop, hp, hn, mul_zero, zero_pow (two_ne_zero), zero_add, add_zero]
    rw [sub_eq_zero]
    apply Finset.sum_congr rfl
    intro i _
    simp only [Fin.val_succ, Fin.coe_castSucc]
    ring

/-- The energy inequality of the model, as algebra: the energy's rate along
the field is exactly minus the dissipation. With ν ≥ 0 this is ≤ 0. -/
theorem energy_inequality (nu lam : ℝ) (a : Fin N → ℝ) :
    ∑ n, a n * field nu lam a n = - dissipation nu lam a := by
  simp only [field, mul_add, Finset.sum_add_distrib, cascade_orthogonality, add_zero,
             damping, dissipation, Finset.mul_sum, ← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro n _
  ring

/-! ## Definition certificates -/

/-- C2: the model is not trivial — a nonzero state with nonzero cascade at some shell.
State a = e₀ + e₁ (needs N ≥ 2): cascade at shell 1 = λ¹ a₀² − λ² a₁ a₂ = λ ≠ 0 for λ ≠ 0. -/
theorem cascade_nontrivial (lam : ℝ) (hl : lam ≠ 0) :
    ∃ (a : Fin 2 → ℝ) (n : Fin 2), cascade lam a n ≠ 0 := by
  refine ⟨![1, 1], 1, ?_⟩
  -- cascade at shell 1 of (1,1): λ¹·1² − λ²·1·next = λ − 0 = λ  (next at top = 0)
  have hn : next (![1, 1] : Fin 2 → ℝ) 1 = 0 := by simp [next]
  have hp : prev (![1, 1] : Fin 2 → ℝ) 1 = 1 := by simp [prev]
  have h : cascade lam (![1, 1] : Fin 2 → ℝ) 1 = lam := by
    simp only [cascade, hn, hp]
    simp
  rw [h]; exact hl

/-- C3: the zero state has zero field — no energy, no dynamics. -/
theorem field_zero (nu lam : ℝ) : field nu lam (0 : Fin N → ℝ) = 0 := by
  ext n; simp [field, damping, cascade, prev, next]

/-- C3b — CORRECTED. The first draft claimed the single-shell state e₀ has ZERO
cascade everywhere. The kernel refused: at shell 1, cascade = λ¹·a₀² − 0 = λ ≠ 0.
That is the model DOING ITS JOB — energy in shell 0 stretches UP into the empty
shell 1. The true boundary fact is narrower: e₀ has zero cascade AT SHELL 0
(nothing below to feed it, and shell 1 is empty so nothing leaves), while shell 1
receives λ. Recorded as a caught-wrong-certificate, not silently rewritten. -/
theorem cascade_single_shell_at_bottom (lam : ℝ) :
    cascade lam (![1, 0] : Fin 2 → ℝ) 0 = 0 := by
  simp [cascade, prev, next]

theorem cascade_single_shell_feeds_up (lam : ℝ) :
    cascade lam (![1, 0] : Fin 2 → ℝ) 1 = lam := by
  have hn : next (![1, 0] : Fin 2 → ℝ) 1 = 0 := by simp [next]
  have hp : prev (![1, 0] : Fin 2 → ℝ) 1 = 1 := by simp [prev]
  simp only [cascade, hn, hp]
  simp


/-! ## The corollary — the inequality proper (grok #18154 attack c) -/

theorem dissipation_nonneg (nu lam : ℝ) (hnu : 0 ≤ nu) (a : Fin N → ℝ) :
    0 ≤ dissipation nu lam a := by
  unfold dissipation
  apply mul_nonneg hnu
  apply Finset.sum_nonneg
  intro n _
  apply mul_nonneg
  · rw [pow_mul]; exact pow_nonneg (sq_nonneg lam) _
  · exact sq_nonneg _

/-- Rung 1(a) corollary — the energy INEQUALITY: with ν ≥ 0, the energy's rate
along the field is ≤ 0. In a finite-N dyadic cascade of KP type; no pressure. -/
theorem energy_rate_nonpos (nu lam : ℝ) (hnu : 0 ≤ nu) (a : Fin N → ℝ) :
    ∑ n, a n * field nu lam a n ≤ 0 := by
  rw [energy_inequality]
  linarith [dissipation_nonneg nu lam hnu a]

end
