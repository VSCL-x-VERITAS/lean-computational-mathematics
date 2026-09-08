import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TravelingWaveCharacterization
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

/-!
An unselected conditional-error capstone, assembled only from canonical owners.
The accuracy convention remains an unanswered source-scope choice.
-/

open MeasureTheory

namespace NumStability.FVUpdateCapstoneDraft

/-- The reference averages, weighted update error and conditional error bound
are linked to the same grid, independently supplied exact field, old numerical
array, two times, and full-array numerical flux rule. -/
theorem finiteVolumeUpdate_capstone {m : ℕ} (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    {s t : ℝ} (hst : s < t) (old : ℤ → (Fin m → ℝ)) :
    ∀ i,
      IsOneDimensionalCellAverage (fun x => q x s) (grid.cellLeft i) (grid.cellRight i)
        (finiteVolumeCellAverageOn grid (fun x => q x s) i) ∧
      IsOneDimensionalCellAverage (fun τ => flux (q (grid.cellLeft i) τ)) s t
        (timeAveragedPhysicalFaceFlux grid q flux s t i) ∧
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
  intro i
  refine ⟨finiteVolumeCellAverageOn_spec grid _ (fun _ => hq.1 _ _ _) i,
    timeAveragedPhysicalFaceFlux_isCellAverage grid hq hst i,
    riemannFiniteVolumeUpdate_weighted_error grid hq rule hst old i, ?_⟩
  intro oldBound leftBound rightBound hold hleft hright
  exact riemannFiniteVolumeUpdate_error_le grid hq rule hst old i hold hleft hright

end NumStability.FVUpdateCapstoneDraft

