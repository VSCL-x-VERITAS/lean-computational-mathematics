/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage

/-!
# Moving exact averages at a Richtmyer face

The two states passed to the scalar Richtmyer flux are exact averages
over the cells immediately left and right of a moving face. Their
derivatives follow from the library's centered moving-average formula.
-/

namespace NumStability

open MeasureTheory

/-- The exact average on the cell immediately left of a moving face
has the endpoint-value difference quotient as its derivative. -/
theorem leveque04_richtmyer_leftExactAverage_hasDerivAt
    (profile : ℝ → ℝ) (face width : ℝ)
    (hprofile : Continuous profile) (hwidth : 0 < width) :
    HasDerivAt
      (fun x => oneDimensionalCellAverage profile (x - width) x)
      ((profile face - profile (face - width)) / width) face := by
  have h := oneDimensionalCellAverage_hasDerivAt_center
    profile width (face - width / 2) hprofile hwidth
  have hshift : HasDerivAt (fun x : ℝ => x - width / 2) 1 face := by
    convert (hasDerivAt_id face).sub_const (width / 2) using 1
  have hc := h.comp face hshift
  have heq : (fun x => oneDimensionalCellAverage profile (x - width) x) =
      (fun c => oneDimensionalCellAverage profile
        (c - width / 2) (c + width / 2)) ∘
        (fun x => x - width / 2) := by
    funext x
    dsimp
    congr 1 <;> ring
  rw [← heq] at hc
  have hright : face - width / 2 + width / 2 = face := by ring
  have hleft : face - width / 2 - width / 2 = face - width := by ring
  simpa only [hright, hleft, mul_one] using hc

/-- The exact average on the cell immediately right of a moving face
has the endpoint-value difference quotient as its derivative. -/
theorem leveque04_richtmyer_rightExactAverage_hasDerivAt
    (profile : ℝ → ℝ) (face width : ℝ)
    (hprofile : Continuous profile) (hwidth : 0 < width) :
    HasDerivAt
      (fun x => oneDimensionalCellAverage profile x (x + width))
      ((profile (face + width) - profile face) / width) face := by
  have h := oneDimensionalCellAverage_hasDerivAt_center
    profile width (face + width / 2) hprofile hwidth
  have hshift : HasDerivAt (fun x : ℝ => x + width / 2) 1 face := by
    convert (hasDerivAt_id face).add_const (width / 2) using 1
  have hc := h.comp face hshift
  have heq : (fun x => oneDimensionalCellAverage profile x (x + width)) =
      (fun c => oneDimensionalCellAverage profile
        (c - width / 2) (c + width / 2)) ∘
        (fun x => x + width / 2) := by
    funext x
    dsimp
    congr 1 <;> ring
  rw [← heq] at hc
  have hright : face + width / 2 + width / 2 = face + width := by ring
  have hleft : face + width / 2 - width / 2 = face := by ring
  simpa only [hright, hleft, mul_one] using hc

end NumStability
