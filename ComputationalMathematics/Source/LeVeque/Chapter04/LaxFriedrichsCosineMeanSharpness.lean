/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsPeriodicCosineSharpness

/-!
# Mean error sharpness on a smooth periodic cosine refinement

On the subsequence of grids with `8m` cells, the first `m` cosine
samples stay uniformly away from zero. This turns the already proved
pointwise damping rate into a mean L1 lower bound.
-/

namespace NumStability

/-- The first eighth of samples of a period-`2π` cosine grid have
absolute value at least one half. -/
private theorem periodicCosine_firstEighth_lower
    (m j : ℕ) (hm : 0 < m) (hj : j < m) :
    (1 / 2 : ℝ) ≤
      |leveque04_periodicCosineMode (8 * m)
        (j : ZMod (8 * m))| := by
  have hn : j < 8 * m := by omega
  have hmreal : (0 : ℝ) < m := by exact_mod_cast hm
  have hnreal : ((8 * m : ℕ) : ℝ) = 8 * (m : ℝ) := by push_cast; ring
  have hjreal : (j : ℝ) ≤ m := by exact_mod_cast (Nat.le_of_lt hj)
  have hfactor : 0 ≤ 2 * Real.pi / ((8 * m : ℕ) : ℝ) := by positivity
  have hangle :
      (2 * Real.pi / ((8 * m : ℕ) : ℝ)) * (j : ℝ) ≤
        Real.pi / 4 := by
    calc
      _ ≤ (2 * Real.pi / ((8 * m : ℕ) : ℝ)) * (m : ℝ) :=
        mul_le_mul_of_nonneg_left hjreal hfactor
      _ = Real.pi / 4 := by
        rw [hnreal]
        field_simp
        ring
  have hangle0 : 0 ≤
      (2 * Real.pi / ((8 * m : ℕ) : ℝ)) * (j : ℝ) := by positivity
  have hcos := Real.one_sub_mul_le_cos hangle0
    (by linarith [Real.pi_pos] :
      (2 * Real.pi / ((8 * m : ℕ) : ℝ)) * (j : ℝ) ≤ Real.pi / 2)
  have hscaled : (2 / Real.pi) *
      ((2 * Real.pi / ((8 * m : ℕ) : ℝ)) * (j : ℝ)) ≤ 1 / 2 := by
    have hπ : 0 ≤ 2 / Real.pi := by positivity
    have h := mul_le_mul_of_nonneg_left hangle hπ
    have heq : (2 / Real.pi) * (Real.pi / 4) = (1 / 2 : ℝ) := by
      field_simp
      ring
    linarith
  rw [leveque04_periodicCosineMode_apply,
    ZMod.val_natCast_of_lt hn]
  exact le_trans (by linarith [hcos, hscaled] :
      (1 / 2 : ℝ) ≤ Real.cos
        ((2 * Real.pi / ((8 * m : ℕ) : ℝ)) * (j : ℝ)))
      (le_abs_self _)

/-- The mean absolute value of the sampled cosine remains positive
uniformly along the eightfold refinement subsequence. -/
theorem leveque04_periodicCosineMode_meanAbs_lower
    (m : ℕ) [NeZero (8 * m)] (hm : 0 < m) :
    (1 / 16 : ℝ) ≤
      (∑ i : ZMod (8 * m),
        |leveque04_periodicCosineMode (8 * m) i|) /
          (8 * m : ℝ) := by
  classical
  let s : Finset (ZMod (8 * m)) :=
    (Finset.range m).image (fun j : ℕ => (j : ZMod (8 * m)))
  have hinj : ∀ a ∈ Finset.range m, ∀ b ∈ Finset.range m,
      (a : ZMod (8 * m)) = (b : ZMod (8 * m)) → a = b := by
    intro a ha b hb hab
    have ha' : a < 8 * m := by have := Finset.mem_range.mp ha; omega
    have hb' : b < 8 * m := by have := Finset.mem_range.mp hb; omega
    have hv := congrArg ZMod.val hab
    simpa [ZMod.val_natCast_of_lt ha', ZMod.val_natCast_of_lt hb'] using hv
  have hs : (s.card : ℝ) = m := by
    simp [s, Finset.card_image_iff.mpr hinj]
  have hsum : (m : ℝ) / 2 ≤
      ∑ i ∈ s, |leveque04_periodicCosineMode (8 * m) i| := by
    have hpoint : ∀ i ∈ s,
        (1 / 2 : ℝ) ≤ |leveque04_periodicCosineMode (8 * m) i| := by
      intro i hi
      obtain ⟨j, hj, rfl⟩ := Finset.mem_image.mp hi
      exact periodicCosine_firstEighth_lower m j hm (Finset.mem_range.mp hj)
    calc
      (m : ℝ) / 2 = ∑ i ∈ s, (1 / 2 : ℝ) := by simp [hs]; ring
      _ ≤ _ := Finset.sum_le_sum hpoint
  have hall : (m : ℝ) / 2 ≤
      ∑ i : ZMod (8 * m),
        |leveque04_periodicCosineMode (8 * m) i| :=
    hsum.trans (Finset.sum_le_sum_of_subset_of_nonneg
      (Finset.subset_univ s) (by intros; positivity))
  have hmreal : (0 : ℝ) < m := by exact_mod_cast hm
  have hnreal : ((8 * m : ℕ) : ℝ) = 8 * (m : ℝ) := by push_cast; ring
  apply (le_div_iff₀ (by positivity : (0 : ℝ) < 8 * m)).2
  nlinarith

/-- The smooth exact-average cosine has first-order mean absolute error
after one fixed physical horizon on the eightfold grid subsequence. -/
theorem leveque04_cosineExactPeriodicCellAverage_meanError_lower
    (m : ℕ) [NeZero (8 * m)] (hm : 0 < m) (ratio : ℝ) :
    1 / (Real.pi * (8 * m : ℝ) * (1 + Real.pi ^ 2)) ≤
      (∑ i : ZMod (8 * m),
        |((leveque04_periodicNonlinearLaxFriedrichsStep (8 * m)
          (fun _ => 0) ratio)^[8 * m]
            (leveque04_cosineExactPeriodicCellAverage (8 * m))) i -
          leveque04_cosineExactPeriodicCellAverage (8 * m) i|) /
        (8 * m : ℝ) := by
  let n := 8 * m
  haveI : NeZero n := ⟨by dsimp [n]; omega⟩
  have hn : 5 ≤ n := by dsimp [n]; omega
  let amplitude : ℝ :=
    2 * Real.sin ((2 * Real.pi / (n : ℝ)) / 2) /
      (2 * Real.pi / (n : ℝ))
  let factor : ℝ := Real.cos (2 * Real.pi / (n : ℝ))
  have hA : 2 / Real.pi ≤ amplitude :=
    leveque04_periodicCosine_cellAverageAmplitude_lower n (by omega)
  have hA0 : 0 ≤ amplitude :=
    le_trans (by positivity : 0 ≤ 2 / Real.pi) hA
  have hD : 8 / ((n : ℝ) * (1 + Real.pi ^ 2)) ≤
      1 - factor ^ n :=
    leveque04_periodicCosineMode_fixedHorizon_damping_lower n hn
  have hD0 : 0 ≤ 1 - factor ^ n :=
    le_trans (by positivity :
      0 ≤ 8 / ((n : ℝ) * (1 + Real.pi ^ 2))) hD
  have hpoint (i : ZMod n) :
      |((leveque04_periodicNonlinearLaxFriedrichsStep n
        (fun _ => 0) ratio)^[n]
          (leveque04_cosineExactPeriodicCellAverage n)) i -
        leveque04_cosineExactPeriodicCellAverage n i| =
        amplitude * (1 - factor ^ n) *
          |leveque04_periodicCosineMode n i| := by
    rw [leveque04_periodicLaxFriedrichs_zeroFlux_mode_error
      n ratio factor (leveque04_cosineExactPeriodicCellAverage n)
      (leveque04_cosineExactPeriodicCellAverage_eigen n (by omega)) n i]
    rw [leveque04_cosineExactPeriodicCellAverage_eq_mode]
    rw [← mul_assoc, abs_mul, abs_mul,
      abs_of_nonpos (by linarith [hD0] : factor ^ n - 1 ≤ 0),
      abs_of_nonneg hA0]
    ring
  have hmean : (1 / 16 : ℝ) ≤
      (∑ i : ZMod n, |leveque04_periodicCosineMode n i|) /
        (n : ℝ) :=
    by simpa only [n, Nat.cast_mul, Nat.cast_ofNat] using
      (leveque04_periodicCosineMode_meanAbs_lower m hm)
  have hprod :
      (2 / Real.pi) *
          (8 / ((n : ℝ) * (1 + Real.pi ^ 2))) * (1 / 16) ≤
        amplitude * (1 - factor ^ n) *
          ((∑ i : ZMod n,
            |leveque04_periodicCosineMode n i|) / (n : ℝ)) := by
    apply mul_le_mul
    · exact mul_le_mul hA hD (by positivity) hA0
    · exact hmean
    · positivity
    · exact mul_nonneg hA0 hD0
  have hfinal : 1 / (Real.pi * (n : ℝ) * (1 + Real.pi ^ 2)) ≤
      (∑ i : ZMod n,
        |((leveque04_periodicNonlinearLaxFriedrichsStep n
          (fun _ => 0) ratio)^[n]
            (leveque04_cosineExactPeriodicCellAverage n)) i -
          leveque04_cosineExactPeriodicCellAverage n i|) /
        (n : ℝ) := by
    calc
      _ = (2 / Real.pi) *
          (8 / ((n : ℝ) * (1 + Real.pi ^ 2))) * (1 / 16) := by
          field_simp
          norm_num
      _ ≤ amplitude * (1 - factor ^ n) *
          ((∑ i : ZMod n,
            |leveque04_periodicCosineMode n i|) / (n : ℝ)) := hprod
      _ = _ := by
        simp_rw [hpoint]
        rw [← mul_div_assoc, Finset.mul_sum]
  simpa only [n, Nat.cast_mul, Nat.cast_ofNat] using hfinal

end NumStability
