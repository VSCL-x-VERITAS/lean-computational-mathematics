/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAAlgorithm
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleTranslation

/-!
# Conservative update of a rectangle-certified REA stage

A reconstructed REA stage whose evolution obeys time-integrated rectangle
conservation has the corresponding physical-flux cell update. Rectangle
conservation admits moving jumps, unlike an all-time mass derivative condition.
-/

namespace NumStability

/-- A rectangle-certified evolution stage averages to the physical finite-volume
flux update on each cell. The only initial mass used is the stage's certified
reconstruction average. -/
theorem Leveque04REAStage.nextAverage_eq_rectangleFluxUpdate
    {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    {grid : OneDimensionalFiniteVolumeGrid}
    {old : ℤ → (Fin m → ℝ)}
    (stage : Leveque04REAStage law grid old
      (fun q => IsRectangleConservationLawSolution q law.physicalFlux))
    (timeStep : ℝ) (htime : 0 < timeStep) (i : ℤ) :
    stage.nextAverage timeStep i =
      old i - (timeStep / grid.cellVolume i) •
        (oneDimensionalCellAverage
          (fun τ => law.physicalFlux (stage.evolved (grid.cellRight i) τ)) 0 timeStep -
          oneDimensionalCellAverage
            (fun τ => law.physicalFlux (stage.evolved (grid.cellLeft i) τ)) 0 timeStep) := by
  have hinitial : oneDimensionalCellAverage (fun x => stage.evolved x 0)
      (grid.cellLeft i) (grid.cellRight i) = old i := by
    simpa only [stage.initial_trace] using stage.old_averages i
  have hrectangle := IsRectangleConservationLawSolution.rectangleReferenceOn
    stage.evolved law.physicalFlux stage.evolution_valid
    (grid.cellLeft i) (grid.cellRight i) timeStep
  have h := rectangleReferenceOn_cellAverage_step_of_initial
    stage.evolved law.physicalFlux (old i)
    (grid.cellLeft i) (grid.cellRight i) timeStep
    (grid.cellLeft i) (grid.cellRight i) hrectangle
    ⟨le_refl _, (grid.cell_nonempty i).le⟩
    ⟨(grid.cell_nonempty i).le, le_refl _⟩
    (grid.cell_nonempty i) htime hinitial
  simpa only [Leveque04REAStage.nextAverage,
    OneDimensionalFiniteVolumeGrid.cellVolume] using h

/-- If the numerical interface flux is the physical time average of the
assembled evolution at each face, the REA average is the selected Riemann
flux-difference step. Constant-state consistency alone does not give this
face-trace hypothesis. -/
theorem Leveque04REAStage.nextAverage_eq_selectedRiemannStep
    {m : ℕ} {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    {grid : OneDimensionalFiniteVolumeGrid}
    {old : ℤ → (Fin m → ℝ)}
    (stage : Leveque04REAStage law grid old
      (fun q => IsRectangleConservationLawSolution q law.physicalFlux))
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    (timeStep : ℝ) (htime : 0 < timeStep)
    (hface : ∀ j,
      oneDimensionalCellAverage
        (fun τ => law.physicalFlux (stage.evolved (grid.cellLeft j) τ)) 0 timeStep =
        rectangleRiemannInterfaceFlux method old hdomain j)
    (i : ℤ) :
    stage.nextAverage timeStep i =
      riemannFiniteVolumeUpdate grid timeStep old
        (rectangleRiemannInterfaceFlux method old hdomain) i := by
  have hright : grid.cellRight i = grid.cellLeft (i + 1) := by
    simpa only [add_sub_cancel_right] using grid.adjacent (i + 1)
  rw [stage.nextAverage_eq_rectangleFluxUpdate timeStep htime i,
    hright, hface (i + 1), hface i]
  rfl

end NumStability
