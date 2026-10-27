/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage

/-!
# Periodic one-dimensional cell averages

Cell averaging respects the spatial period of a field. This lets a
finite periodic grid use the same exact cell average at wraparound cells.
-/

namespace NumStability

/-- A periodic field has the same cell average on an interval shifted by
one period. -/
theorem oneDimensionalCellAverage_periodic_shift
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) (left right period : ℝ)
    (hperiod : ∀ x, field (x + period) = field x) :
    oneDimensionalCellAverage field (left - period) (right - period) =
      oneDimensionalCellAverage field left right := by
  have hfield : (fun x => field (x - period)) = field := by
    funext x
    have h := hperiod (x - period)
    simpa only [sub_add_cancel] using h.symm
  rw [← oneDimensionalCellAverage_comp_sub_right field left right period]
  rw [hfield]

/-- Moving a cell one period forward preserves its average. -/
theorem oneDimensionalCellAverage_periodic_add
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) (left right period : ℝ)
    (hperiod : ∀ x, field (x + period) = field x) :
    oneDimensionalCellAverage field (left + period) (right + period) =
      oneDimensionalCellAverage field left right := by
  have hperiodNeg : ∀ x, field (x + -period) = field x := by
    intro x
    have h := hperiod (x - period)
    simpa [sub_eq_add_neg] using h.symm
  simpa only [sub_neg_eq_add] using
    oneDimensionalCellAverage_periodic_shift field left right (-period) hperiodNeg

end NumStability
