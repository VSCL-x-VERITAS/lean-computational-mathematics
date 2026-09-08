/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.UniformAdvection
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation02
import ComputationalMathematics.Source.LeVeque.Chapter01.ScalarHyperbolicity

/-!
# LeVeque Chapter 1, equation (1.2): uniform transport model

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, printed page
1 (raw PDF page 23), the scalar specialization and constant-velocity contaminant
transport discussion, equations (1.1)–(1.3). Section 1.1.2, printed pages 4–5,
distinguishes classical and integral solutions.

The kinematic premise says each material trajectory carries the same field
value. It implies actual solution satisfaction, with differentiability or
interval integrability stated explicitly. Scalar hyperbolicity and the earlier
scalar/system equation correspondence are retained. No empirical model error
or additional physical constitutive law is asserted.
-/

open MeasureTheory

namespace NumStability

/-- Real-scalar hyperbolicity, scalar specialization, and actual solution
satisfaction for fields carried unchanged by a constant-velocity flow. -/
theorem leveque01_equation02_uniformTransportModel (speed : ℝ) :
    IsRealHyperbolicMatrix (constantCoefficientScalarMatrix speed) ∧
    (∀ q x t, leveque01_equation01_constantLinearSystemAt
        (scalarAsOneComponentSystem q) (constantCoefficientScalarMatrix speed) x t ↔
      leveque01_equation02_scalarAdvectionAt q speed x t) ∧
    ∀ q : ℝ → ℝ → ℝ, IsUniformAdvection q speed →
      (Differentiable ℝ (fun x => q x 0) → IsLinearAdvectionSolution q speed) ∧
      ((∀ a b, IntervalIntegrable (fun x => q x 0) volume a b) →
        IsRectangleConservationLawSolution q (fun state => speed * state)) := by
  refine ⟨leveque01_scalarEquation_isHyperbolic speed,
    fun q x t => leveque01_equation02_isOneDimensionalSpecialization q speed x t, ?_⟩
  intro q h
  exact ⟨h.isLinearAdvectionSolution, h.isRectangleConservationLawSolution⟩

end NumStability
