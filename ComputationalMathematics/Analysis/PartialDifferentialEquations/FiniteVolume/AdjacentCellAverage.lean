/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# The mean of two adjacent cell averages

Two equal-width neighboring cell averages have as their mean the average
over their union. This identity lets midpoint quadrature estimate a
staggered finite-volume predictor directly.
-/

namespace NumStability

open MeasureTheory

/-- The mean of adjacent equal-width cell averages is the normalized
average over the doubled interval. -/
theorem adjacentCellAverage_mean_eq_unionAverage
    (profile : ℝ → ℝ) (face width : ℝ)
    (hwidth : 0 < width)
    (hleft : IntervalIntegrable profile volume (face - width) face)
    (hright : IntervalIntegrable profile volume face (face + width)) :
    (oneDimensionalCellAverage profile (face - width) face +
        oneDimensionalCellAverage profile face (face + width)) / 2 =
      oneDimensionalCellAverage profile (face - width) (face + width) := by
  have hsplit := intervalIntegral.integral_add_adjacent_intervals hleft hright
  simp only [oneDimensionalCellAverage, smul_eq_mul]
  rw [← hsplit]
  field_simp [hwidth.ne']
  ring

end NumStability
