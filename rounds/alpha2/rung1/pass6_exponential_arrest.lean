import Mathlib

theorem agent6_1 : ∀ (N : ℕ) (nu lam : ℝ) (a : ℝ → (Fin N → ℝ)) (T : ℝ), 0 ≤ nu → 1 ≤ lam → (fun (nu lam : ℝ) (a : ℝ → (Fin N → ℝ)) (T : ℝ) => ∀ t ∈ Set.Ico (0:ℝ) T, HasDerivAt a ((fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => - nu * lam ^ (2 * n.val) * a n) nu lam a n + (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n) nu lam (a t)) t) nu lam a T → ∀ t ∈ Set.Ico (0:ℝ) T, (fun (a : Fin N → ℝ) => (1/2 : ℝ) * ∑ n : Fin N, (a n) ^ 2) (a t) ≤ (fun (a : Fin N → ℝ) => (1/2 : ℝ) * ∑ n : Fin N, (a n) ^ 2) (a 0) * Real.exp (-(2 * nu) * t) := by
  intro N nu lam a T hnu hlam hsol t ht
  have hE : ∀ t ∈ Set.Ico (0:ℝ) T, HasDerivAt (fun s => (fun (a : Fin N → ℝ) => (1/2 : ℝ) * ∑ n : Fin N, (a n) ^ 2) (a s)) ((1/2 : ℝ) * ∑ n, 2 * a t n * (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => - nu * lam ^ (2 * n.val) * a n) nu lam a n + (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n) nu lam (a t) n) t := by
    intro t ht
    have hd := hsol t ht
    have hcoord : ∀ n : Fin N, HasDerivAt (fun s => a s n) ((fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => - nu * lam ^ (2 * n.val) * a n) nu lam a n + (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n) nu lam (a t) n) t :=
      fun n => (hasDerivAt_pi.mp hd) n
    have hsq : ∀ n : Fin N, HasDerivAt (fun s => (a s n) ^ 2) (2 * a t n * (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => - nu * lam ^ (2 * n.val) * a n) nu lam a n + (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n) nu lam (a t) n) t := by
      intro n
      have h := (hcoord n).mul (hcoord n)
      have hf : ((fun s => a s n) * fun s => a s n : ℝ → ℝ) = fun s => (a s n) ^ 2 := by
        funext s; simp [sq]
      rw [hf] at h
      exact h.congr_deriv (by ring)
    have hsum : HasDerivAt (fun s => ∑ n, (a s n) ^ 2) (∑ n, 2 * a t n * (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => - nu * lam ^ (2 * n.val) * a n) nu lam a n + (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n) nu lam (a t) n) t := by
      have h := HasDerivAt.sum (u := Finset.univ) (fun n _ => hsq n)
      have hf : (∑ n : Fin N, fun s => (a s n) ^ 2 : ℝ → ℝ) = fun s => ∑ n, (a s n) ^ 2 := by
        funext s; simp [Finset.sum_apply]
      rw [hf] at h
      exact h
    exact hsum.const_mul (1/2 : ℝ)
  have horth : ∀ (b : Fin N → ℝ), ∑ n : Fin N, b n * (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam b n = 0 := by
    induction N with
    | zero => intro b; simp
    | succ M ih =>
      intro b
      simp only [mul_sub, Finset.sum_sub_distrib]
      rw [Fin.sum_univ_succ, Fin.sum_univ_castSucc]
      have hbot : (fun (a : Fin (M+1) → ℝ) (n : Fin (M+1)) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) b (0 : Fin (M+1)) = 0 := by simp
      have htop : (fun (a : Fin (M+1) → ℝ) (n : Fin (M+1)) => if h : n.val + 1 < M+1 then a ⟨n.val + 1, h⟩ else (0:ℝ)) b (Fin.last M) = 0 := by simp
      have hp : ∀ i : Fin M, (fun (a : Fin (M+1) → ℝ) (n : Fin (M+1)) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) b i.succ = b i.castSucc := by
        intro i; simp only [Fin.val_succ, Nat.add_sub_cancel]
        rw [dif_pos (Nat.succ_pos _)]; rfl
      have hn : ∀ i : Fin M, (fun (a : Fin (M+1) → ℝ) (n : Fin (M+1)) => if h : n.val + 1 < M+1 then a ⟨n.val + 1, h⟩ else (0:ℝ)) b i.castSucc = b i.succ := by
        intro i; simp only [Fin.val_castSucc]
        rw [dif_pos (by omega)]; rfl
      simp only [hbot, htop, hp, hn, mul_zero, zero_pow (two_ne_zero), zero_add, add_zero]
      rw [sub_eq_zero]
      apply Finset.sum_congr rfl
      intro i _
      simp only [Fin.val_succ, Fin.val_castSucc]
      ring
  have hrate : ∀ t ∈ Set.Ico (0:ℝ) T, (1/2 : ℝ) * ∑ n, 2 * a t n * (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => - nu * lam ^ (2 * n.val) * a n) nu lam a n + (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n) nu lam (a t) n ≤ -(2 * nu) * (fun (a : Fin N → ℝ) => (1/2 : ℝ) * ∑ n : Fin N, (a n) ^ 2) (a t) := by
    intro t ht
    have h1 : ∑ n, 2 * a t n * (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => - nu * lam ^ (2 * n.val) * a n) nu lam a n + (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n) nu lam (a t) n = 2 * (∑ n, a t n * (- nu * lam ^ (2 * n.val) * a t n) + ∑ n, a t n * (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam (a t) n) := by
      rw [← Finset.sum_add_distrib, Finset.mul_sum]; apply Finset.sum_congr rfl; intro n _; ring
    rw [h1, horth (a t), add_zero]
    have hdiss : ∑ n, a t n * (- nu * lam ^ (2 * n.val) * a t n) ≤ ∑ n, - nu * (a t n) ^ 2 := by
      apply Finset.sum_le_sum
      intro n _
      have hpow : 1 ≤ lam ^ (2 * n.val) := one_le_pow₀ hlam
      nlinarith [mul_nonneg (mul_nonneg hnu (sq_nonneg (a t n))) (sub_nonneg.mpr hpow)]
    have h2 : ∑ n, - nu * (a t n) ^ 2 = - nu * ∑ n, (a t n) ^ 2 := by
      rw [Finset.mul_sum]
    rw [h2] at hdiss
    nlinarith [hdiss]
  set g : ℝ → ℝ := fun s => (fun (a : Fin N → ℝ) => (1/2 : ℝ) * ∑ n : Fin N, (a n) ^ 2) (a s) * Real.exp (2 * nu * s) with hg
  have hg' : ∀ s ∈ Set.Ico (0:ℝ) T, HasDerivAt g (((1/2 : ℝ) * ∑ n, 2 * a s n * (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => (fun (nu lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => - nu * lam ^ (2 * n.val) * a n) nu lam a n + (fun (lam : ℝ) (a : Fin N → ℝ) (n : Fin N) => lam ^ n.val * ((fun (a : Fin N → ℝ) (n : Fin N) => if h : 0 < n.val then a ⟨n.val - 1, by omega⟩ else (0:ℝ)) a n) ^ 2 - lam ^ (n.val + 1) * a n * (fun (a : Fin N → ℝ) (n : Fin N) => if h : n.val + 1 < N then a ⟨n.val + 1, h⟩ else (0:ℝ)) a n) lam a n) nu lam (a s) n) * Real.exp (2 * nu * s) + (fun (a : Fin N → ℝ) => (1/2 : ℝ) * ∑ n : Fin N, (a n) ^ 2) (a s) * (Real.exp (2 * nu * s) * (2 * nu * 1))) s := by
    intro s hs
    have h1 := (hE s hs).mul (((hasDerivAt_id' s).const_mul (2 * nu)).exp)
    have hfun : ((fun s => (fun (a : Fin N → ℝ) => (1/2 : ℝ) * ∑ n : Fin N, (a n) ^ 2) (a s)) * fun x => Real.exp (2 * nu * x) : ℝ → ℝ) = g := by
      funext x; simp [hg]
    rw [hfun] at h1
    exact h1
  have hle : ∀ u ∈ Set.Icc (0:ℝ) t, deriv g u ≤ 0 := by
    intro u hu
    have hu' : u ∈ Set.Ico (0:ℝ) T := ⟨hu.1, lt_of_le_of_lt hu.2 ht.2⟩
    rw [(hg' u hu').deriv]
    have hr := hrate u hu'
    have hex := Real.exp_pos (2 * nu * u)
    nlinarith [mul_le_mul_of_nonneg_right hr hex.le]
  have hcont : ContinuousOn g (Set.Icc (0:ℝ) t) := fun u hu =>
    (hg' u ⟨hu.1, lt_of_le_of_lt hu.2 ht.2⟩).continuousAt.continuousWithinAt
  have hdiff : DifferentiableOn ℝ g (interior (Set.Icc (0:ℝ) t)) := by
    rw [interior_Icc]
    exact fun u hu => (hg' u ⟨hu.1.le, lt_of_le_of_lt hu.2.le ht.2⟩).differentiableAt.differentiableWithinAt
  have hle' : ∀ u ∈ interior (Set.Icc (0:ℝ) t), deriv g u ≤ 0 := by
    rw [interior_Icc]; exact fun u hu => hle u (Set.Ioo_subset_Icc_self hu)
  have hmono := antitoneOn_of_deriv_nonpos (convex_Icc (0:ℝ) t) hcont hdiff hle' ⟨le_refl 0, ht.1⟩ ⟨ht.1, le_refl t⟩ ht.1
  simp only [hg] at hmono
  have hexp0 : Real.exp (2 * nu * 0) = 1 := by simp
  rw [hexp0, mul_one] at hmono
  calc (fun (a : Fin N → ℝ) => (1/2 : ℝ) * ∑ n : Fin N, (a n) ^ 2) (a t) = ((fun (a : Fin N → ℝ) => (1/2 : ℝ) * ∑ n : Fin N, (a n) ^ 2) (a t) * Real.exp (2 * nu * t)) * Real.exp (-(2 * nu) * t) := by
          rw [mul_assoc, ← Real.exp_add]; simp
    _ ≤ (fun (a : Fin N → ℝ) => (1/2 : ℝ) * ∑ n : Fin N, (a n) ^ 2) (a 0) * Real.exp (-(2 * nu) * t) := by
          apply mul_le_mul_of_nonneg_right hmono (Real.exp_pos _).le
