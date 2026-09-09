/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds

/-!
# Chapter 1: a conditional finite-volume update estimate

This source correspondence uses the coordinator-selected interpretation of
the qualitative accuracy statement: independent old-average and time-averaged
physical face-flux bounds imply a next-step bound. The norm and numerical
bounds are explicit mathematical parameters, not quantities supplied by the
printed paragraph. The numerical rule may read the entire old array.

The reference satisfies rectangle conservation. Its normalized averages are
not identified with the independently supplied numerical old values. No
unconditional accuracy, convergence order or step-size criterion is asserted.
-/

open MeasureTheory

namespace NumStability

/-- Normalized physical reference data, the actual numerical update, its exact
weighted error identity, and the selected conditional accuracy interpretation. -/
theorem leveque01_finiteVolumeUpdateError_sourceContract {m : ℕ} (hm : 0 < m)
    (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → Fin m → ℝ} {flux : (Fin m → ℝ) → Fin m → ℝ}
    (hq : IsRectangleConservationLawSolution q flux)
    (rule : ℝ → ℝ → (ℤ → Fin m → ℝ) → ℤ → Fin m → ℝ)
    {s t : ℝ} (hst : s < t) (old : ℤ → Fin m → ℝ) :
    0 < m ∧ ∀ i,
      IsOneDimensionalCellAverage (fun x => q x s) (grid.cellLeft i) (grid.cellRight i)
        (finiteVolumeCellAverageOn grid (fun x => q x s) i) ∧
      IsOneDimensionalCellAverage (fun x => q x t) (grid.cellLeft i) (grid.cellRight i)
        (finiteVolumeCellAverageOn grid (fun x => q x t) i) ∧
      finiteVolumeCellAverageOn grid (fun x => q x s) i =
        cellVolumeAverage volume (Set.Ioc (grid.cellLeft i) (grid.cellRight i))
          (fun x => q x s) ∧
      IsOneDimensionalCellAverage (fun τ => flux (q (grid.cellLeft i) τ)) s t
        (timeAveragedPhysicalFaceFlux grid q flux s t i) ∧
      timeAveragedPhysicalFaceFlux grid q flux s t i =
        cellVolumeAverage volume (Set.Ioc s t) (fun τ => flux (q (grid.cellLeft i) τ)) ∧
      riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i =
        old i - ((t - s) / grid.cellVolume i) • (rule s t old (i + 1) - rule s t old i) ∧
      grid.cellVolume i • (riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i -
          finiteVolumeCellAverageOn grid (fun x => q x t) i) =
        grid.cellVolume i • (old i - finiteVolumeCellAverageOn grid (fun x => q x s) i) +
          (t - s) • ((rule s t old i - timeAveragedPhysicalFaceFlux grid q flux s t i) -
            (rule s t old (i + 1) - timeAveragedPhysicalFaceFlux grid q flux s t (i + 1))) ∧
      ∀ oldBound leftBound rightBound : ℝ,
        ‖old i - finiteVolumeCellAverageOn grid (fun x => q x s) i‖ ≤ oldBound →
        ‖rule s t old i - timeAveragedPhysicalFaceFlux grid q flux s t i‖ ≤ leftBound →
        ‖rule s t old (i + 1) -
          timeAveragedPhysicalFaceFlux grid q flux s t (i + 1)‖ ≤ rightBound →
        ‖riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i -
          finiteVolumeCellAverageOn grid (fun x => q x t) i‖ ≤
          oldBound + (t - s) / grid.cellVolume i * (leftBound + rightBound) := by
  refine ⟨hm, ?_⟩
  intro i
  refine ⟨finiteVolumeCellAverageOn_spec grid _ (fun _ => hq.1 _ _ _) i,
    finiteVolumeCellAverageOn_spec grid _ (fun _ => hq.1 _ _ _) i,
    (cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage _ (grid.cell_nonempty i)).symm,
    timeAveragedPhysicalFaceFlux_isCellAverage grid hq hst i,
    (cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage _ hst).symm, rfl,
    riemannFiniteVolumeUpdate_weighted_error grid hq rule hst old i, ?_⟩
  intro oldBound leftBound rightBound hold hleft hright
  exact riemannFiniteVolumeUpdate_error_le grid hq rule hst old i hold hleft hright

end NumStability
