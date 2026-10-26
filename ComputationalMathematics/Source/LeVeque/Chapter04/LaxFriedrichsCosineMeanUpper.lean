/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsCosineMeanSharpness

/-!
# Matching upper bound for the smooth periodic cosine example

The upper bound uses the same exact cell-average family and mean error
norm as the lower bound, with a fixed number of steps per refinement.
-/

namespace NumStability

/-- The accumulated damping of the first cosine mode is at most first
order in the reciprocal number of periodic cells. -/
theorem leveque04_periodicCosineMode_fixedHorizon_damping_upper
    (n : ℕ) [NeZero n] (hn : 5 ≤ n) :
    1 - Real.cos (2 * Real.pi / (n : ℝ)) ^ n ≤
      2 * Real.pi ^ 2 / (n : ℝ) := by
  let z : ℝ := Real.cos (2 * Real.pi / (n : ℝ))
  have hnreal : (5 : ℝ) ≤ n := by exact_mod_cast hn
  have hnpos : (0 : ℝ) < n := by linarith
  have hanglePos : 0 < 2 * Real.pi / (n : ℝ) := by positivity
  have hangleHalf : 2 * Real.pi / (n : ℝ) < Real.pi / 2 := by
    apply (div_lt_iff₀ hnpos).2
    nlinarith [Real.pi_pos]
  have hz0 : 0 ≤ z :=
    (Real.cos_pos_of_mem_Ioo ⟨by linarith [Real.pi_pos], hangleHalf⟩).le
  have hδhi : 1 - z ≤ 2 * Real.pi ^ 2 / (n : ℝ) ^ 2 := by
    have h := Real.one_sub_sq_div_two_le_cos
      (x := 2 * Real.pi / (n : ℝ))
    have hsq : (2 * Real.pi / (n : ℝ)) ^ 2 / 2 =
        2 * Real.pi ^ 2 / (n : ℝ) ^ 2 := by field_simp
    dsimp [z]
    linarith [h, hsq]
  have hbern : 1 + (n : ℝ) * (z - 1) ≤ z ^ n := by
    convert (one_add_mul_le_pow
      (by linarith [hz0] : (-2 : ℝ) ≤ z - 1) n) using 1; ring
  have hmul : (n : ℝ) * (1 - z) ≤
      2 * Real.pi ^ 2 / (n : ℝ) := by
    have h := mul_le_mul_of_nonneg_left hδhi hnpos.le
    have heq : (n : ℝ) *
        (2 * Real.pi ^ 2 / (n : ℝ) ^ 2) =
          2 * Real.pi ^ 2 / (n : ℝ) := by field_simp
    linarith
  linarith [hbern, hmul]

/-- The exact-average amplitude of the sampled cosine is at most one. -/
theorem leveque04_periodicCosine_cellAverageAmplitude_upper
    (n : ℕ) [NeZero n] :
    2 * Real.sin ((2 * Real.pi / (n : ℝ)) / 2) /
        (2 * Real.pi / (n : ℝ)) ≤ 1 := by
  have hnpos : (0 : ℝ) < n := by exact_mod_cast (NeZero.pos n)
  have hxpos : 0 < 2 * Real.pi / (n : ℝ) := by positivity
  have hsin := Real.sin_le (by positivity :
    (0 : ℝ) ≤ (2 * Real.pi / (n : ℝ)) / 2)
  apply (div_le_iff₀ hxpos).2
  linarith

/-- The exact-average smooth stationary cosine has a matching first-order
mean absolute error upper bound at the same fixed physical horizon. -/
theorem leveque04_cosineExactPeriodicCellAverage_meanError_upper
    (n : ℕ) [NeZero n] (hn : 5 ≤ n) (ratio : ℝ) :
    (∑ i : ZMod n,
      |((leveque04_periodicNonlinearLaxFriedrichsStep n
        (fun _ => 0) ratio)^[n]
          (leveque04_cosineExactPeriodicCellAverage n)) i -
        leveque04_cosineExactPeriodicCellAverage n i|) /
      (n : ℝ) ≤ 2 * Real.pi ^ 2 / (n : ℝ) := by
  let amplitude : ℝ :=
    2 * Real.sin ((2 * Real.pi / (n : ℝ)) / 2) /
      (2 * Real.pi / (n : ℝ))
  let factor : ℝ := Real.cos (2 * Real.pi / (n : ℝ))
  have hA0 : 0 ≤ amplitude :=
    le_trans (by positivity : 0 ≤ 2 / Real.pi)
      (leveque04_periodicCosine_cellAverageAmplitude_lower n (by omega))
  have hA : amplitude ≤ 1 :=
    leveque04_periodicCosine_cellAverageAmplitude_upper n
  have hD0 : 0 ≤ 1 - factor ^ n :=
    le_trans (by positivity :
      0 ≤ 8 / ((n : ℝ) * (1 + Real.pi ^ 2)))
        (leveque04_periodicCosineMode_fixedHorizon_damping_lower n hn)
  have hD : 1 - factor ^ n ≤ 2 * Real.pi ^ 2 / (n : ℝ) :=
    leveque04_periodicCosineMode_fixedHorizon_damping_upper n hn
  have hpoint (i : ZMod n) :
      |((leveque04_periodicNonlinearLaxFriedrichsStep n
        (fun _ => 0) ratio)^[n]
          (leveque04_cosineExactPeriodicCellAverage n)) i -
        leveque04_cosineExactPeriodicCellAverage n i| ≤
          2 * Real.pi ^ 2 / (n : ℝ) := by
    rw [leveque04_periodicLaxFriedrichs_zeroFlux_mode_error
      n ratio factor (leveque04_cosineExactPeriodicCellAverage n)
      (leveque04_cosineExactPeriodicCellAverage_eigen n (by omega)) n i]
    rw [leveque04_cosineExactPeriodicCellAverage_eq_mode]
    rw [← mul_assoc, abs_mul, abs_mul,
      abs_of_nonpos (by linarith [hD0] : factor ^ n - 1 ≤ 0),
      abs_of_nonneg hA0]
    have hmode : |leveque04_periodicCosineMode n i| ≤ 1 := by
      rw [leveque04_periodicCosineMode_apply]
      exact Real.abs_cos_le_one _
    have hprod : amplitude * (1 - factor ^ n) ≤
        2 * Real.pi ^ 2 / (n : ℝ) := by
      calc
        _ ≤ 1 * (1 - factor ^ n) :=
          mul_le_mul_of_nonneg_right hA hD0
        _ ≤ _ := by simpa using hD
    calc
      _ = amplitude * (1 - factor ^ n) *
          |leveque04_periodicCosineMode n i| := by ring
      _ ≤ amplitude * (1 - factor ^ n) := by
        simpa using mul_le_mul_of_nonneg_left hmode
          (mul_nonneg hA0 hD0)
      _ ≤ _ := hprod
  have hnpos : (0 : ℝ) < n := by exact_mod_cast (lt_of_lt_of_le (by decide : 0 < 5) hn)
  have hsum : (∑ i : ZMod n,
      |((leveque04_periodicNonlinearLaxFriedrichsStep n
        (fun _ => 0) ratio)^[n]
          (leveque04_cosineExactPeriodicCellAverage n)) i -
        leveque04_cosineExactPeriodicCellAverage n i|) ≤
          ∑ _i : ZMod n, 2 * Real.pi ^ 2 / (n : ℝ) :=
    Finset.sum_le_sum (fun i _ => hpoint i)
  calc
    _ ≤ (∑ _i : ZMod n, 2 * Real.pi ^ 2 / (n : ℝ)) /
          (n : ℝ) := div_le_div_of_nonneg_right hsum hnpos.le
    _ = _ := by
      simp [ZMod.card]
      field_simp

/-- The same exact-average cosine family has matching first-order mean
absolute error bounds along the eightfold refinement subsequence. -/
theorem leveque04_cosineExactPeriodicCellAverage_meanError_twoSided
    (m : ℕ) [NeZero (8 * m)] (hm : 0 < m) (ratio : ℝ) :
    1 / (Real.pi * (8 * m : ℝ) * (1 + Real.pi ^ 2)) ≤
      (∑ i : ZMod (8 * m),
        |((leveque04_periodicNonlinearLaxFriedrichsStep (8 * m)
          (fun _ => 0) ratio)^[8 * m]
            (leveque04_cosineExactPeriodicCellAverage (8 * m))) i -
          leveque04_cosineExactPeriodicCellAverage (8 * m) i|) /
        (8 * m : ℝ) ∧
      (∑ i : ZMod (8 * m),
        |((leveque04_periodicNonlinearLaxFriedrichsStep (8 * m)
          (fun _ => 0) ratio)^[8 * m]
            (leveque04_cosineExactPeriodicCellAverage (8 * m))) i -
          leveque04_cosineExactPeriodicCellAverage (8 * m) i|) /
        (8 * m : ℝ) ≤
          2 * Real.pi ^ 2 / (8 * m : ℝ) := by
  refine ⟨leveque04_cosineExactPeriodicCellAverage_meanError_lower m hm ratio, ?_⟩
  simpa only [Nat.cast_mul, Nat.cast_ofNat] using
    (leveque04_cosineExactPeriodicCellAverage_meanError_upper
      (8 * m) (by omega) ratio)

end NumStability
