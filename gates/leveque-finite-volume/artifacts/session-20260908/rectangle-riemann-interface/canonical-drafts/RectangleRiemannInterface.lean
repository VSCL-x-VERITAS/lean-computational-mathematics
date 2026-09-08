/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle

/-!
# Rectangle-certified Riemann interface methods

A method solves ordered local Riemann problems on an explicit domain. Its
certificate includes the Riemann initial trace and time-integrated rectangle
conservation, including the integrability required for the rectangle identity.
The workflow uses normalized cell averages, extracted information, a consistent
interface flux, and the existing conservative finite-volume update.
-/

open MeasureTheory

namespace NumStability

/-- An ordered Riemann initial trace together with time-integrated rectangle conservation. -/
def IsRectangleHyperbolicRiemannSolution
    {Component : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (problem : HyperbolicRiemannProblem law)
    (solution : ℝ → ℝ → (Component → ℝ)) : Prop :=
  IsRiemannData (fun x => solution x 0) problem.leftState problem.rightState ∧
    IsRectangleConservationLawSolution solution law.physicalFlux

/-- A solution certified for the actual ordered problem it solves. -/
structure CertifiedRectangleRiemannSolution
    {Component : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (problem : HyperbolicRiemannProblem law) where
  solution : ℝ → ℝ → (Component → ℝ)
  solves : IsRectangleHyperbolicRiemannSolution law problem solution

/-- A solver on an explicit domain, followed by information extraction and a
numerical-flux procedure. Constant problems belong to the domain and have the
physical constant-state flux. No general nonlinear solvability is assumed. -/
structure RectangleRiemannInterfaceFluxMethod
    {Component : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (Information : Type*) where
  domain : HyperbolicRiemannProblem law → Prop
  solve : (problem : HyperbolicRiemannProblem law) → domain problem →
    CertifiedRectangleRiemannSolution law problem
  extractInformation : {problem : HyperbolicRiemannProblem law} →
    CertifiedRectangleRiemannSolution law problem → Information
  numericalFluxFromInformation : Information → (Component → ℝ)
  constants_in_domain : ∀ state,
    domain ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
  consistent_on_constant_states : ∀ state,
    numericalFluxFromInformation
      (extractInformation
        (solve ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
          (constants_in_domain state))) = law.physicalFlux state

/-- The information at interface `i` comes from the problem ordered from cell
`i - 1` to cell `i`, with explicit evidence that this problem is in the solver domain. -/
def adjacentCellRectangleRiemannInformation
    {Component Information : Type*} [Fintype Component]
    {law : OneDimensionalHyperbolicConservationLaw Component}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (cellAverages : ℤ → (Component → ℝ))
    (hdomain : ∀ i, method.domain (adjacentCellRiemannProblem law cellAverages i))
    (i : ℤ) : Information :=
  method.extractInformation
    (method.solve (adjacentCellRiemannProblem law cellAverages i) (hdomain i))

def rectangleRiemannInterfaceFlux
    {Component Information : Type*} [Fintype Component]
    {law : OneDimensionalHyperbolicConservationLaw Component}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (cellAverages : ℤ → (Component → ℝ))
    (hdomain : ∀ i, method.domain (adjacentCellRiemannProblem law cellAverages i))
    (i : ℤ) : Component → ℝ :=
  method.numericalFluxFromInformation
    (adjacentCellRectangleRiemannInformation method cellAverages hdomain i)

/-- The finite-volume interface workflow constructs actual normalized cell
averages, certified local solves, extracted information, interface fluxes and
the conservative update. Local Riemann coordinates put each interface at zero. -/
theorem rectangleRiemannInterface_finiteVolumeStep
    {Component Information : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (grid : OneDimensionalFiniteVolumeGrid)
    (initialState : ℝ → (Component → ℝ))
    (hintegrable : ∀ i, IntervalIntegrable initialState volume
      (grid.cellLeft i) (grid.cellRight i))
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hdomain : ∀ i, method.domain
      (adjacentCellRiemannProblem law (finiteVolumeCellAverageOn grid initialState) i))
    (timeStep : ℝ) :
    ∃ cellAverages : ℤ → (Component → ℝ),
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
          ∃ numericalFlux : ℤ → (Component → ℝ),
            (∀ i, numericalFlux i = method.numericalFluxFromInformation (information i)) ∧
            (∀ state, method.numericalFluxFromInformation
              (method.extractInformation
                (method.solve
                  ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
                  (method.constants_in_domain state))) = law.physicalFlux state) ∧
            ∃ updatedCellAverages : ℤ → (Component → ℝ),
              ∀ i, updatedCellAverages i =
                riemannFiniteVolumeUpdate grid timeStep cellAverages numericalFlux i := by
  let cellAverages := finiteVolumeCellAverageOn grid initialState
  refine ⟨cellAverages, ?_, grid.adjacent, hdomain, ?_⟩
  · exact finiteVolumeCellAverageOn_spec grid initialState hintegrable
  · let solved : (i : ℤ) → CertifiedRectangleRiemannSolution law
        (adjacentCellRiemannProblem law cellAverages i) :=
      fun i => method.solve (adjacentCellRiemannProblem law cellAverages i) (hdomain i)
    refine ⟨solved, fun i => (solved i).solves.1, fun i => (solved i).solves.2, ?_⟩
    let information : ℤ → Information := fun i => method.extractInformation (solved i)
    refine ⟨information, fun _ => rfl, ?_⟩
    let numericalFlux : ℤ → (Component → ℝ) :=
      fun i => method.numericalFluxFromInformation (information i)
    refine ⟨numericalFlux, fun _ => rfl, method.consistent_on_constant_states, ?_⟩
    exact ⟨riemannFiniteVolumeUpdate grid timeStep cellAverages numericalFlux, fun _ => rfl⟩

end NumStability
