/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage

/-!
# Positivity of real cell averages

The normalized interval integral preserves nonnegativity. A continuous
nonnegative profile that is positive at a point of a nondegenerate cell has a
strictly positive average. This also applies to localized bumps smaller than
the cell, without requiring the profile to be constant on the whole cell.
-/

namespace NumStability

open Set

theorem oneDimensionalCellAverage_nonneg
    (f : ℝ → ℝ) (a b : ℝ) (hab : a ≤ b)
    (hf : ∀ x ∈ Icc a b, 0 ≤ f x) :
    0 ≤ oneDimensionalCellAverage f a b := by
  exact mul_nonneg (inv_nonneg.mpr (sub_nonneg.mpr hab))
    (intervalIntegral.integral_nonneg hab hf)

theorem oneDimensionalCellAverage_pos_of_continuous_of_pos
    (f : ℝ → ℝ) (a b x : ℝ) (hab : a < b)
    (hf : ContinuousOn f (Icc a b)) (hnonneg : ∀ y ∈ Icc a b, 0 ≤ f y)
    (hx : x ∈ Icc a b) (hpos : 0 < f x) :
    0 < oneDimensionalCellAverage f a b := by
  have hi : 0 < ∫ y in a..b, f y := by
    have h := intervalIntegral.integral_lt_integral_of_continuousOn_of_le_of_exists_lt
      hab continuousOn_const hf (fun y hy => hnonneg y (Ioc_subset_Icc_self hy))
      ⟨x, hx, hpos⟩
    simpa only [intervalIntegral.integral_zero] using h
  exact mul_pos (inv_pos.mpr (sub_pos.mpr hab)) hi

end NumStability
