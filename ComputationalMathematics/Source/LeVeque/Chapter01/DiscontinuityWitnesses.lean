/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.MovingStep

/-!
# LeVeque Chapter 1, discontinuities and integral balance

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, printed
pages 4–5 (raw PDF pages 26–27), equation (1.10) and Section 1.1.2.
These distinct declarations supply a counterexample to an everywhere classical
mass-rate interpretation and the valid time-integrated balance for that field.
The source interpretation is a separate audit obligation.
-/

open MeasureTheory

namespace NumStability

/-- At a positive-time endpoint crossing, the cell mass has no classical
time derivative, and the field has no classical advection solution at the jump.
Both failures hold for every selected point value at that jump. -/
theorem leveque01_movingStep_classicalDerivative_witness (valueAtJump : ℝ) :
    (∀ d : ℝ, ¬ HasDerivAt
      (fun t => ∫ x in (0 : ℝ)..1, MovingStep.timeShiftedStep valueAtJump 1 x t) d 1) ∧
    ¬ IsLinearAdvectionSolutionAt (MovingStep.timeShiftedStep valueAtJump 1) 1 0 1 :=
  ⟨MovingStep.timeShiftedStep_no_classical_mass_derivative valueAtJump 1,
    MovingStep.timeShiftedStep_no_classical_advection_at_crossing valueAtJump 1⟩

/-- The same discontinuous field satisfies the complete oriented rectangle
conservation law, including explicit spatial and temporal flux integrability. -/
theorem leveque01_movingStep_rectangleBalance (valueAtJump : ℝ) :
    IsRectangleConservationLawSolution (MovingStep.timeShiftedStep valueAtJump 1) id :=
  MovingStep.timeShiftedStep_rectangle valueAtJump 1

/-- A single explicit discontinuous field satisfies rectangle balance while
both its classical PDE and its classical cell-mass derivative fail at the
positive-time endpoint crossing. This is a witness for the distinction between
the two integral interpretations, not an equivalence with an unqualified
everywhere-derivative reading of equation (1.10). -/
theorem leveque01_discontinuity_integralBalance_witness (valueAtJump : ℝ) :
    IsRectangleConservationLawSolution (MovingStep.timeShiftedStep valueAtJump 1) id ∧
    ¬ IsLinearAdvectionSolutionAt (MovingStep.timeShiftedStep valueAtJump 1) 1 0 1 ∧
    (∀ d : ℝ, ¬ HasDerivAt
      (fun t => ∫ x in (0 : ℝ)..1, MovingStep.timeShiftedStep valueAtJump 1 x t) d 1) :=
  ⟨leveque01_movingStep_rectangleBalance valueAtJump,
    (leveque01_movingStep_classicalDerivative_witness valueAtJump).2,
    (leveque01_movingStep_classicalDerivative_witness valueAtJump).1⟩

end NumStability
