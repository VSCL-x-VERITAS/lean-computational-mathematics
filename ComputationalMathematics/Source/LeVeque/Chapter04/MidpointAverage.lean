/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: midpoint and cell average

An affine field has an exact midpoint cell average. This is the zero-curvature
case underlying the source's second-order midpoint statement. A bound for a
general smooth field requires a controlled second derivative.
-/

namespace NumStability

/-- The normalized average of the coordinate over an ordered cell is its
midpoint. -/
theorem leveque04_coordinateAverage_eq_midpoint
    (left right : ℝ) (hcell : left < right) :
    oneDimensionalCellAverage (fun x : ℝ => x) left right =
      (left + right) / 2 := by
  have hwidth : right - left ≠ 0 := ne_of_gt (sub_pos.mpr hcell)
  simp only [oneDimensionalCellAverage, integral_id,
    smul_eq_mul]
  field_simp
  ring

/-- Affine fields have no midpoint quadrature error. Their second derivative
vanishes, so this is an exact special case of the source's smooth-field claim. -/
theorem leveque04_affineAverage_eq_midpoint
    (slope intercept left right : ℝ) (hcell : left < right) :
    oneDimensionalCellAverage (fun x : ℝ => slope * x + intercept) left right =
      slope * ((left + right) / 2) + intercept := by
  have hwidth : right - left ≠ 0 := ne_of_gt (sub_pos.mpr hcell)
  have hlinear : IntervalIntegrable (fun x : ℝ => slope * x) MeasureTheory.volume
      left right :=
    (continuous_const.mul continuous_id).intervalIntegrable left right
  have hconstant : IntervalIntegrable (fun _ : ℝ => intercept) MeasureTheory.volume
      left right :=
    continuous_const.intervalIntegrable left right
  simp only [oneDimensionalCellAverage, intervalIntegral.integral_add hlinear hconstant,
    intervalIntegral.integral_const, smul_eq_mul]
  rw [intervalIntegral.integral_const_mul slope (fun x : ℝ => x), integral_id]
  field_simp
  ring

end NumStability
