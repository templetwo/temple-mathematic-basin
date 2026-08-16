import Mathlib

theorem agent6_4 : ∀ (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)), (fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) => (∀ x, u x 2 = 0) ∧ (∀ x, (fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 2 x = 0)) u → ContDiff ℝ 2 u → ∀ x : EuclideanSpace ℝ (Fin 3), ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (x : EuclideanSpace ℝ (Fin 3)) => (WithLp.toLp 2 ![ ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 1 x) 2 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 2 x) 1, ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 2 x) 0 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 0 x) 2, ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 0 x) 1 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 1 x) 0 ] : EuclideanSpace ℝ (Fin 3))) ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (x : EuclideanSpace ℝ (Fin 3)) => ∑ i : Fin 3, (u x i) • (fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u i x) u) x) 2 = (∑ i : Fin 3, (u x i) * (fun (p : EuclideanSpace ℝ (Fin 3) → ℝ) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ p x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) (fun y => (fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (x : EuclideanSpace ℝ (Fin 3)) => (WithLp.toLp 2 ![ ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 1 x) 2 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 2 x) 1, ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 2 x) 0 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 0 x) 2, ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 0 x) 1 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 1 x) 0 ] : EuclideanSpace ℝ (Fin 3))) u y 2) i x) + ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (x : EuclideanSpace ℝ (Fin 3)) => ∑ i : Fin 3, (fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u i x i) u x) * ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (x : EuclideanSpace ℝ (Fin 3)) => (WithLp.toLp 2 ![ ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 1 x) 2 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 2 x) 1, ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 2 x) 0 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 0 x) 2, ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 0 x) 1 - ((fun (u : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (i : Fin 3) (x : EuclideanSpace ℝ (Fin 3)) => fderiv ℝ u x ((fun i : Fin 3 => (EuclideanSpace.single i (1:ℝ) : EuclideanSpace ℝ (Fin 3))) i)) u 1 x) 0 ] : EuclideanSpace ℝ (Fin 3))) u x 2) := by
  intro u hu hd x
  obtain ⟨h2, hpd2'⟩ := hu
  have hpd2 : ∀ y : EuclideanSpace ℝ (Fin 3), fderiv ℝ u y (EuclideanSpace.single 2 (1:ℝ)) = 0 := hpd2'
  have hd0 : Differentiable ℝ u := hd.differentiable (by norm_num)
  have h1 : Differentiable ℝ (fderiv ℝ u) :=
    (hd.fderiv_right (m := 1) (by norm_num)).differentiable (by norm_num)
  have hfk : ∀ k : Fin 3, Differentiable ℝ (fun y => fderiv ℝ u y (EuclideanSpace.single k (1:ℝ))) :=
    fun k y => ((h1 y).clm_apply (differentiableAt_const _))
  have hpdd : ∀ k m : Fin 3, Differentiable ℝ (fun y => fderiv ℝ u y (EuclideanSpace.single k (1:ℝ)) m) :=
    fun k m => (differentiable_piLp 2).mp (hfk k) m
  have hui : ∀ i : Fin 3, Differentiable ℝ (fun y => u y i) :=
    fun i => (differentiable_piLp 2).mp hd0 i
  have hproj : ∀ i j : Fin 3, fderiv ℝ (fun y => u y i) x (EuclideanSpace.single j (1:ℝ)) = fderiv ℝ u x (EuclideanSpace.single j (1:ℝ)) i := by
    intro i j
    have hg := PiLp.hasFDerivAt_apply (𝕜 := ℝ) 2 (u x) i
    have h3 : HasFDerivAt (fun y => u y i) ((PiLp.proj 2 (fun _ : Fin 3 => ℝ) i).comp (fderiv ℝ u x)) x := hg.comp x (hd0 x).hasFDerivAt
    rw [h3.fderiv]
    simp
  have hclm : ∀ k : Fin 3, fderiv ℝ (fun y => fderiv ℝ u y (EuclideanSpace.single k (1:ℝ))) x = (fderiv ℝ (fderiv ℝ u) x).flip (EuclideanSpace.single k (1:ℝ)) := by
    intro k
    rw [fderiv_clm_apply (h1 x) (differentiableAt_const _)]
    simp
  have hcomp : ∀ k m : Fin 3, fderiv ℝ (fun y => fderiv ℝ u y (EuclideanSpace.single k (1:ℝ)) m) x = (PiLp.proj 2 (fun _ : Fin 3 => ℝ) m).comp (fderiv ℝ (fun y => fderiv ℝ u y (EuclideanSpace.single k (1:ℝ))) x) := by
    intro k m
    have hg := PiLp.hasFDerivAt_apply (𝕜 := ℝ) 2 (fderiv ℝ u x (EuclideanSpace.single k (1:ℝ))) m
    exact (hg.comp x (hfk k x).hasFDerivAt).fderiv
  have hsc : ∀ k m j : Fin 3, fderiv ℝ (fun y => fderiv ℝ u y (EuclideanSpace.single k (1:ℝ)) m) x (EuclideanSpace.single j (1:ℝ)) = fderiv ℝ (fderiv ℝ u) x (EuclideanSpace.single j (1:ℝ)) (EuclideanSpace.single k (1:ℝ)) m := by
    intro k m j
    rw [hcomp k m, hclm k]
    simp
  have hsymm : ∀ i j : Fin 3, fderiv ℝ (fderiv ℝ u) x (EuclideanSpace.single i (1:ℝ)) (EuclideanSpace.single j (1:ℝ)) = fderiv ℝ (fderiv ℝ u) x (EuclideanSpace.single j (1:ℝ)) (EuclideanSpace.single i (1:ℝ)) := by
    intro i j
    exact (hd.contDiffAt.isSymmSndFDerivAt (by simp [minSmoothness_of_isRCLikeNormedField])) (EuclideanSpace.single i (1:ℝ)) (EuclideanSpace.single j (1:ℝ))
  have hC : ∀ j k : Fin 3, (fderiv ℝ (fun y => u y 0 • fderiv ℝ u y (EuclideanSpace.single 0 (1:ℝ)) + u y 1 • fderiv ℝ u y (EuclideanSpace.single 1 (1:ℝ)) + u y 2 • fderiv ℝ u y (EuclideanSpace.single 2 (1:ℝ))) x (EuclideanSpace.single j (1:ℝ))) k = (u x 0 * fderiv ℝ (fderiv ℝ u) x (EuclideanSpace.single j (1:ℝ)) (EuclideanSpace.single 0 (1:ℝ)) k + fderiv ℝ u x (EuclideanSpace.single j (1:ℝ)) 0 * fderiv ℝ u x (EuclideanSpace.single 0 (1:ℝ)) k) + (u x 1 * fderiv ℝ (fderiv ℝ u) x (EuclideanSpace.single j (1:ℝ)) (EuclideanSpace.single 1 (1:ℝ)) k + fderiv ℝ u x (EuclideanSpace.single j (1:ℝ)) 1 * fderiv ℝ u x (EuclideanSpace.single 1 (1:ℝ)) k) + (u x 2 * fderiv ℝ (fderiv ℝ u) x (EuclideanSpace.single j (1:ℝ)) (EuclideanSpace.single 2 (1:ℝ)) k + fderiv ℝ u x (EuclideanSpace.single j (1:ℝ)) 2 * fderiv ℝ u x (EuclideanSpace.single 2 (1:ℝ)) k) := by
    intro j k
    have hF : HasFDerivAt (fun y => u y 0 • fderiv ℝ u y (EuclideanSpace.single 0 (1:ℝ)) + u y 1 • fderiv ℝ u y (EuclideanSpace.single 1 (1:ℝ)) + u y 2 • fderiv ℝ u y (EuclideanSpace.single 2 (1:ℝ))) _ x := (((hui 0 x).hasFDerivAt.smul (hfk 0 x).hasFDerivAt).add ((hui 1 x).hasFDerivAt.smul (hfk 1 x).hasFDerivAt)).add ((hui 2 x).hasFDerivAt.smul (hfk 2 x).hasFDerivAt)
    rw [hF.fderiv]
    simp only [add_apply, smul_apply, ContinuousLinearMap.smulRight_apply, PiLp.add_apply, PiLp.smul_apply, smul_eq_mul, hclm, hproj, ContinuousLinearMap.flip_apply]
  simp only [Fin.sum_univ_three, Matrix.cons_val]
  rw [hC 0 1, hC 1 0]
  have hsub : ∀ i : Fin 3, fderiv ℝ (fun y => fderiv ℝ u y (EuclideanSpace.single 0 (1:ℝ)) 1 - fderiv ℝ u y (EuclideanSpace.single 1 (1:ℝ)) 0) x (EuclideanSpace.single i (1:ℝ)) = fderiv ℝ (fderiv ℝ u) x (EuclideanSpace.single i (1:ℝ)) (EuclideanSpace.single 0 (1:ℝ)) 1 - fderiv ℝ (fderiv ℝ u) x (EuclideanSpace.single i (1:ℝ)) (EuclideanSpace.single 1 (1:ℝ)) 0 := by
    intro i
    rw [fderiv_fun_sub (hpdd 0 1 x) (hpdd 1 0 x)]
    simp only [sub_apply, hsc]
  have hpdi2 : ∀ i : Fin 3, fderiv ℝ u x (EuclideanSpace.single i (1:ℝ)) 2 = 0 := by
    intro i
    rw [← hproj 2 i]
    have hz : (fun y : EuclideanSpace ℝ (Fin 3) => u y 2) = fun _ => (0:ℝ) := funext h2
    rw [hz]
    simp
  have hz2 : ∀ k : Fin 3, fderiv ℝ u x (EuclideanSpace.single 2 (1:ℝ)) k = 0 := by
    intro k
    rw [hpd2 x]
    simp
  rw [hsub 0, hsub 1, hsub 2, hsymm 1 0]
  simp only [h2 x, hpdi2, hz2]
  ring
