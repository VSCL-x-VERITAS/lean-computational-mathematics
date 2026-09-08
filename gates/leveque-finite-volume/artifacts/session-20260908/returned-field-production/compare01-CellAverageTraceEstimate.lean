/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates

/-!
# Cell-average estimates through an intermediate trace

Two pointwise trace bounds control the error against the normalized average.
The estimate is independent of any governing law or numerical method.
-/

open MeasureTheory

namespace NumStability

/-- A trace-level bound does not require a field or an exact local solution.
It can therefore also be used for a method that returns only interface data. -/
theorem norm_sub_oneDimensionalCellAverage_le_of_trace {E : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    {localTrace physicalTrace : ℝ → E} {numerical : E} {s t a b : ℝ}
    (hst : s < t) (hl : IntervalIntegrable localTrace volume s t)
    (hp : IntervalIntegrable physicalTrace volume s t)
    (hn : ∀ τ ∈ Set.uIoc s t, ‖numerical - localTrace τ‖ ≤ a)
    (he : ∀ τ ∈ Set.uIoc s t, ‖localTrace τ - physicalTrace τ‖ ≤ b) :
    ‖numerical - oneDimensionalCellAverage physicalTrace s t‖ ≤ a + b := by
  have hc : oneDimensionalCellAverage (fun _ : ℝ => numerical) s t = numerical := by
    simp [oneDimensionalCellAverage, intervalIntegral.integral_const, smul_smul,
      (sub_pos.mpr hst).ne']
  have hn' : ‖numerical - oneDimensionalCellAverage localTrace s t‖ ≤ a := by
    rw [← hc]
    exact norm_oneDimensionalCellAverage_sub_le hst intervalIntegrable_const hl hn
  exact (norm_sub_le_norm_sub_add_norm_sub numerical
    (oneDimensionalCellAverage localTrace s t) _).trans
    (add_le_add hn' (norm_oneDimensionalCellAverage_sub_le hst hl hp he))

end NumStability
