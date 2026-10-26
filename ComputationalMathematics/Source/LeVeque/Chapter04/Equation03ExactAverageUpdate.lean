/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalIntegration

/-!
# LeVeque Chapter 4, equation (4.3): exact cell-average update

The exact cell average at the next time equals the old average minus the
time-integrated outward physical flux difference divided by the cell width.
The numerical flux proposal in (4.4) is a separate statement.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- Equation (4.3), with the right face flux outgoing and the left face flux
incoming. The grid may have nonuniform cell widths. -/
theorem leveque04_equation03
    {m : ℕ} (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsIntegralConservationLawSolution q flux)
    {s t : ℝ} (_hst : s < t) (i : ℤ)
    (hleft : IntervalIntegrable
      (fun τ => flux (q (grid.cellLeft i) τ)) volume s t)
    (hright : IntervalIntegrable
      (fun τ => flux (q (grid.cellRight i) τ)) volume s t) :
    finiteVolumeCellAverageOn grid (fun x => q x t) i =
      finiteVolumeCellAverageOn grid (fun x => q x s) i -
        (grid.cellVolume i)⁻¹ •
          ((∫ τ in s..t, flux (q (grid.cellRight i) τ)) -
            ∫ τ in s..t, flux (q (grid.cellLeft i) τ)) := by
  have hvol : grid.cellVolume i ≠ 0 := (grid.cellVolume_pos i).ne'
  have hmass :
      grid.cellVolume i • finiteVolumeCellAverageOn grid (fun x => q x t) i -
          grid.cellVolume i • finiteVolumeCellAverageOn grid (fun x => q x s) i =
        (∫ τ in s..t, flux (q (grid.cellLeft i) τ)) -
          ∫ τ in s..t, flux (q (grid.cellRight i) τ) := by
    change (grid.cellRight i - grid.cellLeft i) •
        oneDimensionalCellAverage (fun x => q x t) _ _ -
          (grid.cellRight i - grid.cellLeft i) •
            oneDimensionalCellAverage (fun x => q x s) _ _ = _
    rw [cellWidth_smul_oneDimensionalCellAverage _ (grid.cell_nonempty i),
      cellWidth_smul_oneDimensionalCellAverage _ (grid.cell_nonempty i)]
    exact hq.integratedBalance _ _ s t hleft hright
  have hscaled := congrArg
    (fun v : Fin m → ℝ => (grid.cellVolume i)⁻¹ • v) hmass
  have hdiff :
      finiteVolumeCellAverageOn grid (fun x => q x t) i -
          finiteVolumeCellAverageOn grid (fun x => q x s) i =
        (grid.cellVolume i)⁻¹ •
          ((∫ τ in s..t, flux (q (grid.cellLeft i) τ)) -
            ∫ τ in s..t, flux (q (grid.cellRight i) τ)) := by
    simpa only [← smul_sub, smul_smul, inv_mul_cancel₀ hvol, one_smul] using hscaled
  calc
    finiteVolumeCellAverageOn grid (fun x => q x t) i =
        finiteVolumeCellAverageOn grid (fun x => q x s) i +
          (finiteVolumeCellAverageOn grid (fun x => q x t) i -
            finiteVolumeCellAverageOn grid (fun x => q x s) i) := by abel
    _ = finiteVolumeCellAverageOn grid (fun x => q x s) i +
          (grid.cellVolume i)⁻¹ •
            ((∫ τ in s..t, flux (q (grid.cellLeft i) τ)) -
              ∫ τ in s..t, flux (q (grid.cellRight i) τ)) := by rw [hdiff]
    _ = _ := by simp only [sub_eq_add_neg, smul_add, smul_neg]; abel

end NumStability
