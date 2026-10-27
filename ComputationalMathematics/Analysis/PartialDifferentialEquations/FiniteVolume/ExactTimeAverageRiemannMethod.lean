/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ConstantTraceAverage

/-!
# Exact time-average flux from a rectangle Riemann solver

A selected rectangle-certified solver yields a Riemann interface method
whose extracted information is its solution field and whose numerical
flux is the time average of the physical interface trace. A constant
trace condition supplies the required constant-state consistency.
-/

open MeasureTheory

namespace NumStability

/-- The positive-time average of a physical flux with a constant
interface trace is that state's physical flux. -/
theorem oneDimensionalCellAverage_flux_of_constantTrace
    {Component : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (field : ℝ → ℝ → Component → ℝ)
    (state : Component → ℝ) (timeStep : ℝ) (htime : 0 < timeStep)
    (htrace : ∀ τ ∈ Set.uIoc 0 timeStep, field 0 τ = state) :
    oneDimensionalCellAverage
      (fun τ => law.physicalFlux (field 0 τ)) 0 timeStep =
        law.physicalFlux state := by
  exact (oneDimensionalCellAverage_map_of_constantTrace law.physicalFlux
    (fun τ => field 0 τ) state timeStep htime htrace).2

/-- A rectangle-certified Riemann solver with constant-problem traces
defines an exact time-average interface-flux method on its domain. -/
noncomputable def rectangleExactTimeAverageRiemannMethod
    {Component : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (domain : HyperbolicRiemannProblem law → Prop)
    (solve : (problem : HyperbolicRiemannProblem law) → domain problem →
      CertifiedRectangleRiemannSolution law problem)
    (hconstants : ∀ state,
      domain ({ leftState := state, rightState := state } :
        HyperbolicRiemannProblem law))
    (timeStep : ℝ) (htime : 0 < timeStep)
    (hconstantTrace : ∀ state τ,
      (solve ({ leftState := state, rightState := state } :
        HyperbolicRiemannProblem law) (hconstants state)).solution 0 τ = state) :
    RectangleRiemannInterfaceFluxMethod law
      (ℝ → ℝ → Component → ℝ) where
  domain := domain
  solve := solve
  extractInformation := fun solved => solved.solution
  numericalFluxFromInformation := fun field =>
    oneDimensionalCellAverage
      (fun τ => law.physicalFlux (field 0 τ)) 0 timeStep
  constants_in_domain := hconstants
  consistent_on_constant_states := by
    intro state
    exact oneDimensionalCellAverage_flux_of_constantTrace law _ state
      timeStep htime (fun τ _ => hconstantTrace state τ)

end NumStability
