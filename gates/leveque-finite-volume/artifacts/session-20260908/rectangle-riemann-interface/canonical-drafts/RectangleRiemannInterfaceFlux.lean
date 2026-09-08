/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRectangleRiemannInterface

/-!
# LeVeque Chapter 1, rectangle-certified interface workflow

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 5 (raw PDF page 27), following equation (1.11).

This wrapper exposes the solver domain for the actual normalized cell averages.
Potentially discontinuous local solutions carry rectangle conservation and their
ordered Riemann initial traces. The imported linear construction inhabits the
method contract on all ordered state pairs. A positive time step is recorded;
no CFL, approximation-error, stability, convergence, or global gluing conclusion
is part of this interface workflow.
-/

open MeasureTheory

namespace NumStability
/-- LeVeque Chapter 1, printed page 5 (raw PDF page 27), following equation
(1.11): the interface workflow on the explicit solver domain, using rectangle
conservation for the potentially discontinuous local Riemann solutions. The
averages are actual normalized cell integrals, and left/right order is explicit. -/
theorem leveque01_rectangleRiemannInterfaceFlux_sourceContract
    {m : ℕ} (hm : 0 < m) {Information : Type*}
    (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (grid : OneDimensionalFiniteVolumeGrid)
    (initialState : ℝ → (Fin m → ℝ))
    (hintegrable : ∀ i, IntervalIntegrable initialState volume
      (grid.cellLeft i) (grid.cellRight i))
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hdomain : ∀ i, method.domain
      (adjacentCellRiemannProblem law (finiteVolumeCellAverageOn grid initialState) i))
    (timeStep : ℝ) (htimeStep : 0 < timeStep) :
    0 < m ∧ 0 < timeStep ∧
    ∃ cellAverages : ℤ → (Fin m → ℝ),
      (∀ i, IsOneDimensionalCellAverage initialState
        (grid.cellLeft i) (grid.cellRight i) (cellAverages i)) ∧
      (∀ i, grid.cellRight (i - 1) = grid.cellLeft i) ∧
      (∀ i, method.domain (adjacentCellRiemannProblem law cellAverages i)) ∧
      ∃ solved : (i : ℤ) → CertifiedRectangleRiemannSolution law
          (adjacentCellRiemannProblem law cellAverages i),
        (∀ i, IsRiemannData (fun x => (solved i).solution x 0)
          (cellAverages (i - 1)) (cellAverages i)) ∧
        (∀ i, IsRectangleConservationLawSolution (solved i).solution law.physicalFlux) ∧
        ∃ information : ℤ → Information,
          (∀ i, information i = method.extractInformation (solved i)) ∧
          ∃ numericalFlux : ℤ → (Fin m → ℝ),
            (∀ i, numericalFlux i = method.numericalFluxFromInformation (information i)) ∧
            (∀ state, method.numericalFluxFromInformation
              (method.extractInformation
                (method.solve
                  ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
                  (method.constants_in_domain state))) = law.physicalFlux state) ∧
            ∃ updatedCellAverages : ℤ → (Fin m → ℝ),
              ∀ i, updatedCellAverages i =
                riemannFiniteVolumeUpdate grid timeStep cellAverages numericalFlux i := by
  exact ⟨hm, htimeStep, rectangleRiemannInterface_finiteVolumeStep
    law grid initialState hintegrable method hdomain timeStep⟩

end NumStability
