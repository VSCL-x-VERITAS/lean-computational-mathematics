/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsCosineMode
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

/-!
# Exact cell averages of a stationary cosine profile

The integral supplies the amplitude connecting the smooth periodic
stationary profile to the sampled discrete cosine eigenmode.
-/

namespace NumStability

open intervalIntegral

/-- The normalized average of a cosine with nonzero frequency on an
arbitrary real cell. -/
theorem leveque04_cosineCellAverage
    (frequency left right : ℝ) (hf : frequency ≠ 0) :
    oneDimensionalCellAverage
      (fun x => Real.cos (frequency * x)) left right =
      (Real.sin (frequency * right) -
        Real.sin (frequency * left)) /
          (frequency * (right - left)) := by
  simp only [oneDimensionalCellAverage, smul_eq_mul]
  rw [intervalIntegral.integral_comp_mul_left Real.cos hf]
  rw [integral_cos]
  simp only [smul_eq_mul]
  by_cases hspan : right - left = 0
  · have heq : right = left := sub_eq_zero.mp hspan
    subst right
    simp
  · field_simp [hf, hspan]

/-- Centered cell averages of one cosine are a common sinc amplitude
times its value at the cell center. -/
theorem leveque04_cosineCenteredCellAverage
    (frequency center width : ℝ)
    (hf : frequency ≠ 0) :
    oneDimensionalCellAverage
      (fun x => Real.cos (frequency * x))
      (center - width / 2) (center + width / 2) =
      (2 * Real.sin (frequency * width / 2) /
        (frequency * width)) * Real.cos (frequency * center) := by
  rw [leveque04_cosineCellAverage frequency _ _ hf]
  have hspan : center + width / 2 - (center - width / 2) = width := by ring
  rw [hspan]
  have hr : frequency * (center + width / 2) =
      frequency * center + frequency * width / 2 := by ring
  have hl : frequency * (center - width / 2) =
      frequency * center - frequency * width / 2 := by ring
  rw [hr, hl, Real.sin_add, Real.sin_sub]
  ring

/-- On a fixed physical period of length `2π`, every exact cell
average of the smooth stationary cosine has the same sinc amplitude
times the sampled discrete eigenmode. -/
theorem leveque04_periodicCosine_exactCellAverage
    (n : ℕ) [NeZero n] (i : ZMod n) :
    oneDimensionalCellAverage Real.cos
      ((i.val : ℝ) * (2 * Real.pi / (n : ℝ)) -
        (2 * Real.pi / (n : ℝ)) / 2)
      ((i.val : ℝ) * (2 * Real.pi / (n : ℝ)) +
        (2 * Real.pi / (n : ℝ)) / 2) =
      (2 * Real.sin ((2 * Real.pi / (n : ℝ)) / 2) /
        (2 * Real.pi / (n : ℝ))) *
          leveque04_periodicCosineMode n i := by
  have h := leveque04_cosineCenteredCellAverage 1
    ((i.val : ℝ) * (2 * Real.pi / (n : ℝ)))
    (2 * Real.pi / (n : ℝ)) (by norm_num)
  simpa [leveque04_periodicCosineMode_apply, mul_comm] using h

/-- The exact cosine cell-average amplitude stays uniformly positive
over all periodic refinements with at least two cells. -/
theorem leveque04_periodicCosine_cellAverageAmplitude_lower
    (n : ℕ) [NeZero n] (hn : 2 ≤ n) :
    2 / Real.pi ≤
      2 * Real.sin ((2 * Real.pi / (n : ℝ)) / 2) /
        (2 * Real.pi / (n : ℝ)) := by
  have hnreal : (2 : ℝ) ≤ n := by exact_mod_cast hn
  have hnpos : (0 : ℝ) < n := by linarith
  have hθpos : 0 < Real.pi / (n : ℝ) := by positivity
  have hθle : Real.pi / (n : ℝ) ≤ Real.pi / 2 := by
    apply (div_le_iff₀ hnpos).2
    nlinarith [Real.pi_pos]
  have hsin := Real.mul_le_sin hθpos.le hθle
  have harg : (2 * Real.pi / (n : ℝ)) / 2 =
      Real.pi / (n : ℝ) := by ring
  have hamp :
      2 * Real.sin ((2 * Real.pi / (n : ℝ)) / 2) /
          (2 * Real.pi / (n : ℝ)) =
        Real.sin (Real.pi / (n : ℝ)) /
          (Real.pi / (n : ℝ)) := by
    rw [harg]
    ring
  rw [hamp]
  apply (le_div_iff₀ hθpos).2
  simpa [mul_comm] using hsin

end NumStability
