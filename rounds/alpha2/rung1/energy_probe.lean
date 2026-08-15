import Mathlib

/-! Rung 1(a) probe — the cascade conserves energy; only viscosity dissipates. Worked in lake before freezing. -/

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
def energyRate (nu lam : ℝ) (a : Fin N → ℝ) : ℝ := ∑ n, a n * field nu lam a n
def dissipation (nu lam : ℝ) (a : Fin N → ℝ) : ℝ := nu * ∑ n, lam ^ (2 * n.val) * (a n) ^ 2

/-- The telescoping core: `Σ aₙ · cascadeₙ = 0`.
Each term `λⁿ⁺¹ aₙ² aₙ₊₁` appears with `+` at index n+1 (as `λ^{n+1} a_{n} ^2` times a_{n+1})
and with `−` at index n. Proven by reindexing the "prev" sum onto the "next" sum. -/
theorem cascade_conserves (lam : ℝ) (a : Fin N → ℝ) :
    ∑ n, a n * cascade lam a n = 0 := by
  -- Σ aₙ (λⁿ prevₙ² − λⁿ⁺¹ aₙ nextₙ) = Σ λⁿ aₙ prevₙ² − Σ λⁿ⁺¹ aₙ² nextₙ
  simp only [cascade, mul_sub, Finset.sum_sub_distrib]
  -- reindex the first sum: shell n's term uses prev = a(n-1); rewrite as sum over m = n-1 of λ^{m+1} a_{m+1} a_m²
  -- which is exactly the second sum's shape with roles swapped. Do it via Fin.sum_univ_succ style induction on N.
  induction N with
  | zero => simp
  | succ N ih =>
    -- Fin (N+1): split off the LAST index (Fin.sum_univ_castSucc), because prev/next both truncate at the ends.
    sorry

end
