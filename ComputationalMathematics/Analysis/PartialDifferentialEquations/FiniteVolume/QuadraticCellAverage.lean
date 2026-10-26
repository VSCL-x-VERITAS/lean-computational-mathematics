/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.CFLUnitShift
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# Exact quadratic cell averages

The quadratic average differs from the center value by `width²/12`.
Translation gives a convenient exact test for finite-volume methods.
-/

namespace NumStability

open intervalIntegral

/-- Exact quadratic average on a positive-width centered cell. -/
theorem oneDimensionalCellAverage_quadratic
    (center width : ℝ) (hwidth : 0 < width) :
    oneDimensionalCellAverage (fun x : ℝ => x ^ 2)
        (center - width / 2) (center + width / 2) =
      center ^ 2 + width ^ 2 / 12 := by
  have hne : width ≠ 0 := ne_of_gt hwidth
  simp only [oneDimensionalCellAverage, smul_eq_mul, integral_pow]
  have hspan : center + width / 2 - (center - width / 2) = width := by ring
  rw [hspan]
  field_simp [hne]
  ring

/-- Exact average of a translated quadratic. -/
theorem oneDimensionalCellAverage_translated_quadratic
    (center width offset : ℝ) (hwidth : 0 < width) :
    oneDimensionalCellAverage (fun x : ℝ => (x - offset) ^ 2)
        (center - width / 2) (center + width / 2) =
      (center - offset) ^ 2 + width ^ 2 / 12 := by
  have hleft : center - width / 2 - offset =
      center - offset - width / 2 := by ring
  have hright : center + width / 2 - offset =
      center - offset + width / 2 := by ring
  calc
    _ = oneDimensionalCellAverage (fun x : ℝ => x ^ 2)
        (center - width / 2 - offset) (center + width / 2 - offset) :=
      oneDimensionalCellAverage_comp_sub_right (fun x : ℝ => x ^ 2)
        (center - width / 2) (center + width / 2) offset
    _ = _ := by
      rw [hleft, hright]
      exact oneDimensionalCellAverage_quadratic (center - offset) width hwidth

/-- On the edge grid, the offset quadratic has center values `(j*width)²`. -/
theorem CFLUnitShift.averaged_quadratic_offset
    (width : ℝ) (hwidth : 0 < width) (distance : ℝ) (j : ℤ) (p : Fin 2) :
    CFLUnitShift.averaged width hwidth
      (fun x : ℝ => fun _ : Fin 2 => (x + width / 2) ^ 2) distance j p =
      ((j : ℝ) * width - distance) ^ 2 + width ^ 2 / 12 := by
  have hcont : Continuous (fun x : ℝ => fun _ : Fin 2 => (x-distance+width/2)^2) :=
    continuous_pi (fun _ => ((continuous_id.sub continuous_const).add continuous_const).pow 2)
  change (oneDimensionalCellAverage
    (fun x : ℝ => fun _ : Fin 2 => (x-distance+width/2)^2)
    (((j : ℝ)-1)*width) ((j : ℝ)*width)) p = _
  rw [oneDimensionalCellAverage_apply _ _ _
    (hcont.intervalIntegrable (((j : ℝ)-1)*width) ((j : ℝ)*width)) p]
  convert oneDimensionalCellAverage_translated_quadratic ((j : ℝ)*width-width/2)
    width (distance-width/2) hwidth using 1
  · congr 1
    · funext x
      congr 1
      ring
    · ring
    · ring
  · ring

end NumStability
