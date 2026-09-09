/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalDerivative

/-!
# Chapter 1: information from adjacent Riemann problems

Ordered numerical cell values determine the actual selected problem, result,
extracted information and shared numerical flux. The result type is arbitrary;
it need not contain a complete space-time field. Applicability is explicit.

The coordinator-selected accuracy interpretation compares these numerical
fluxes with time averages of an independent rectangle-conserved physical
reference. Input bounds imply the next-step bound. The fixed-interval mass
derivative is almost everywhere, using the previously selected convention.
These conventions qualify this source correspondence rather than supplying
unstated printed numerical tolerances or an unconditional accuracy theorem.
-/

open MeasureTheory

namespace NumStability

/-- The complete solve/extract/flux/update workflow with normalized reference
averages, constant consistency, and direct conditional face-error bounds. -/
theorem leveque01_riemannInformationInterfaceFlux_sourceContract
    {m : ℕ} (hm : 0 < m) (grid : OneDimensionalFiniteVolumeGrid)
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}
    (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {q : ℝ → ℝ → Fin m → ℝ}
    (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    {s t : ℝ} (hst : s < t) :
    0 < m ∧
    (∀ a b : ℝ, ∀ᵐ τ, HasDerivAt (fun r => ∫ x in a..b, q x r)
      (law.physicalFlux (q a τ) - law.physicalFlux (q b τ)) τ) ∧
    (∀ state j, method.interfaceFlux (fun _ => state)
      (fun _ => method.constants_in_domain state) j = law.physicalFlux state) ∧
    (∀ j,
      let problem := adjacentCellRiemannProblem law old j
      let result := method.solve problem (hdomain j)
      grid.cellRight (j - 1) = grid.cellLeft j ∧
      problem.leftState = old (j - 1) ∧ problem.rightState = old j ∧
      method.selectedResult old hdomain j = result ∧
      method.interfaceFlux old hdomain j = method.numericalFlux (method.extract result)) ∧
    ∀ i,
      IsOneDimensionalCellAverage (fun x => q x s) (grid.cellLeft i) (grid.cellRight i)
        (finiteVolumeCellAverageOn grid (fun x => q x s) i) ∧
      IsOneDimensionalCellAverage (fun x => q x t) (grid.cellLeft i) (grid.cellRight i)
        (finiteVolumeCellAverageOn grid (fun x => q x t) i) ∧
      finiteVolumeCellAverageOn grid (fun x => q x s) i =
        cellVolumeAverage volume (Set.Ioc (grid.cellLeft i) (grid.cellRight i))
          (fun x => q x s) ∧
      IsOneDimensionalCellAverage (fun τ => law.physicalFlux (q (grid.cellLeft i) τ)) s t
        (timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t i) ∧
      timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t i =
        cellVolumeAverage volume (Set.Ioc s t)
          (fun τ => law.physicalFlux (q (grid.cellLeft i) τ)) ∧
      riemannFiniteVolumeUpdate grid (t - s) old (method.interfaceFlux old hdomain) i =
        old i - ((t - s) / grid.cellVolume i) •
          (method.interfaceFlux old hdomain (i + 1) - method.interfaceFlux old hdomain i) ∧
      grid.cellVolume i •
          (riemannFiniteVolumeUpdate grid (t - s) old (method.interfaceFlux old hdomain) i -
            finiteVolumeCellAverageOn grid (fun x => q x t) i) =
        grid.cellVolume i • (old i - finiteVolumeCellAverageOn grid (fun x => q x s) i) +
          (t - s) •
            ((method.interfaceFlux old hdomain i - timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t i) -
              (method.interfaceFlux old hdomain (i + 1) - timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t (i + 1))) ∧
      ∀ oldBound leftBound rightBound : ℝ,
        ‖old i - finiteVolumeCellAverageOn grid (fun x => q x s) i‖ ≤ oldBound →
        ‖method.interfaceFlux old hdomain i -
          timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t i‖ ≤ leftBound →
        ‖method.interfaceFlux old hdomain (i + 1) -
          timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t (i + 1)‖ ≤ rightBound →
        ‖riemannFiniteVolumeUpdate grid (t - s) old (method.interfaceFlux old hdomain) i -
          finiteVolumeCellAverageOn grid (fun x => q x t) i‖ ≤
          oldBound + (t - s) / grid.cellVolume i * (leftBound + rightBound) := by
  refine ⟨hm, hq.hasDerivAt_mass_ae, ?_, ?_, ?_⟩
  · intro state j
    exact method.interfaceFlux_constant state _ j
  · intro j
    exact ⟨grid.adjacent j, method.interface_execution old hdomain j⟩
  · intro i
    refine ⟨finiteVolumeCellAverageOn_spec grid _ (fun _ => hq.1 _ _ _) i,
      finiteVolumeCellAverageOn_spec grid _ (fun _ => hq.1 _ _ _) i,
      (cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage _ (grid.cell_nonempty i)).symm,
      timeAveragedPhysicalFaceFlux_isCellAverage grid hq hst i,
      (cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage _ hst).symm, rfl,
      riemannFiniteVolumeUpdate_weighted_error grid hq
        (fun _ _ _ => method.interfaceFlux old hdomain) hst old i, ?_⟩
    intro oldBound leftBound rightBound hold hleft hright
    exact riemannFiniteVolumeUpdate_error_le grid hq
      (fun _ _ _ => method.interfaceFlux old hdomain) hst old i hold hleft hright

end NumStability
