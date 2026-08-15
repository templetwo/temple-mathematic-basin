import Mathlib

theorem b2i : ∀ (N : ℕ) (hN : 0 < N) (lam : ℝ) (a : ℝ → (Fin N → ℝ)) (T : ℝ), 0 ≤ lam → (fun (nu lam : ℝ) (a : ℝ → (Fin N → ℝ)) (T : ℝ) => ∀ t ∈ Set.Ico (0:ℝ) T, HasDerivAt a ((fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => - nu * lam ^ (2 * n.val) * a n) nu lam a n + (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n) nu lam (a t)) t) 0 lam a T → MonotoneOn (fun s => a s (⟨N - 1, by omega⟩ : Fin N)) (Set.Ico (0:ℝ) T) := by
  intro N hN lam a T hlam hsol
  have htop : ∀ t ∈ Set.Ico (0:ℝ) T, HasDerivAt (fun s => a s (⟨N - 1, by omega⟩ : Fin N)) ((fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => - nu * lam ^ (2 * n.val) * a n) nu lam a n + (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n) 0 lam (a t) (⟨N - 1, by omega⟩ : Fin N)) t :=
    fun t ht => (hasDerivAt_pi.mp (hsol t ht)) (⟨N - 1, by omega⟩ : Fin N)
  have hnonneg : ∀ t ∈ Set.Ico (0:ℝ) T, 0 ≤ (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => - nu * lam ^ (2 * n.val) * a n) nu lam a n + (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n) 0 lam (a t) (⟨N - 1, by omega⟩ : Fin N) := by
    intro t ht
    have hN1 : ¬ ((N - 1) + 1 < N) := by omega
    simp only [hN1, dite_false, neg_zero, zero_mul, zero_add, mul_zero, sub_zero]
    exact mul_nonneg (pow_nonneg hlam _) (sq_nonneg _)
  apply monotoneOn_of_deriv_nonneg (convex_Ico (0:ℝ) T)
  · intro t ht; exact (htop t ht).continuousAt.continuousWithinAt
  · intro t ht; rw [interior_Ico] at ht
    exact (htop t (Set.Ioo_subset_Ico_self ht)).differentiableAt.differentiableWithinAt
  · intro t ht; rw [interior_Ico] at ht
    have ht' := Set.Ioo_subset_Ico_self ht
    rw [(htop t ht').deriv]
    exact hnonneg t ht'
