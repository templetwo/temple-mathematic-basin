import Mathlib

theorem agent7_1b : ∀ (N : ℕ) (nu lam : ℝ) (a : Fin N → ℝ) (k : ℕ) (hk : k < N), (∑ n ∈ Finset.univ.filter (fun n : Fin N => k ≤ n.val), a n * (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => - nu * lam ^ (2 * n.val) * a n) nu lam a n + (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n) nu lam a n) = lam ^ k * a ⟨k, hk⟩ * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a ⟨k, hk⟩) ^ 2 - nu * ∑ n ∈ Finset.univ.filter (fun n : Fin N => k ≤ n.val), lam ^ (2 * n.val) * (a n) ^ 2 := by
  intro N nu lam a k hk
  have hsplit : ∀ n : Fin N, a n * (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => - nu * lam ^ (2 * n.val) * a n) nu lam a n + (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n) nu lam a n = a n * (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n - nu * (lam ^ (2 * n.val) * (a n) ^ 2) := by
    intro n
    dsimp only
    ring
  have hpeel : ∀ (j : ℕ) (hj : j < N), ∑ n ∈ Finset.univ.filter (fun n : Fin N => j ≤ n.val), a n * (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n = a ⟨j, hj⟩ * (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a ⟨j, hj⟩ + ∑ n ∈ Finset.univ.filter (fun n : Fin N => j + 1 ≤ n.val), a n * (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n := by
    intro j hj
    rw [Finset.sum_filter, Finset.sum_filter]
    have h1 : ∀ n : Fin N, (if j ≤ n.val then a n * (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n else 0) = (if n = ⟨j, hj⟩ then a n * (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n else 0) + (if j + 1 ≤ n.val then a n * (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n else 0) := by
      intro n
      by_cases hn : n.val = j
      · have hn' : n = ⟨j, hj⟩ := Fin.ext hn
        rw [if_pos (by omega), if_pos hn', if_neg (by omega)]
        ring
      · have hn' : n ≠ ⟨j, hj⟩ := fun h => hn (by rw [h])
        rw [if_neg hn']
        by_cases hjn : j ≤ n.val
        · rw [if_pos hjn, if_pos (by omega)]
          ring
        · rw [if_neg hjn, if_neg (by omega)]
          ring
    rw [Finset.sum_congr rfl (fun n _ => h1 n), Finset.sum_add_distrib, Finset.sum_ite_eq', if_pos (Finset.mem_univ _)]
  have hempty : ∑ n ∈ Finset.univ.filter (fun n : Fin N => N ≤ n.val), a n * (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n = 0 := by
    apply Finset.sum_eq_zero
    intro n hn
    exact absurd (Finset.mem_filter.mp hn).2 (Nat.not_le.mpr n.isLt)
  have hind : ∀ (j : ℕ) (m : ℕ), m + j = N → ∑ n ∈ Finset.univ.filter (fun n : Fin N => m ≤ n.val), a n * (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n = if h : m < N then lam ^ m * a ⟨m, h⟩ * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a ⟨m, h⟩) ^ 2 else 0 := by
    intro j
    induction j with
    | zero =>
      intro m hm
      have hmN : m = N := by omega
      subst hmN
      rw [dif_neg (lt_irrefl m)]
      exact hempty
    | succ j ih =>
      intro m hm
      have hmlt : m < N := by omega
      rw [hpeel m hmlt, ih (m + 1) (by omega), dif_pos hmlt]
      by_cases hm1 : m + 1 < N
      · simp only [dif_pos hm1, dif_pos (show 0 < m + 1 by omega), Nat.add_sub_cancel]
        ring
      · simp only [dif_neg hm1]
        ring
  have hcasc : ∑ n ∈ Finset.univ.filter (fun n : Fin N => k ≤ n.val), a n * (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n = lam ^ k * a ⟨k, hk⟩ * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a ⟨k, hk⟩) ^ 2 := by
    rw [hind (N - k) k (by omega), dif_pos hk]
  rw [Finset.sum_congr rfl (fun n _ => hsplit n), Finset.sum_sub_distrib, ← Finset.mul_sum, hcasc]
