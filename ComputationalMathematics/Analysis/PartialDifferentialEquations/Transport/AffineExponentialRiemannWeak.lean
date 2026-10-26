/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.MovingRiemannJump
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.StationaryJump
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.VariableCoefficient
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageNeighborTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.TravelingJumpAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.AffineExponentialRiemann
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.AffineExponentialRiemannMass
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.LogarithmicWeightedRiemann
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.MaterialDerivative
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.ScalarNondivergenceRectangle
import ComputationalMathematics.Analysis.PartialDifferentialEquations.VariableLinearFlux
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.Order.Ring.Abs
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.Deriv.Pow
import Mathlib.Analysis.Calculus.Deriv.Prod
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Analysis.ODE.Gronwall
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.SpecialFunctions.Log.Deriv
import Mathlib.Data.Matrix.Mul
import Mathlib.Data.Real.Basic
import Mathlib.MeasureTheory.Function.JacobianOneDim
import Mathlib.MeasureTheory.Integral.IntervalIntegral.AbsolutelyContinuousFun
import Mathlib.MeasureTheory.Measure.Lebesgue.EqHaar
import Mathlib.MeasureTheory.Measure.OpenPos
import Mathlib.Tactic.Abel
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.FunProp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Mathlib.Topology.MetricSpace.Lipschitz
import Mathlib.Topology.Order.Compact

/-!
# AffineExponentialRiemannWeak

Source-independent mathematics. Actual derivatives, integrability and displayed analytic hypotheses are retained.
-/

namespace NumStability

open Set Filter MeasureTheory Topology
open scoped BigOperators Topology NNReal

theorem variableTransportRiemann_original_time_integrable
    (L O R x s t : ℝ) :
    IntervalIntegrable (fun τ => riemannData L O R (variableTransportLabel x τ)) volume s t := by
  by_cases hx : 0 < x+1
  · have h := travelingWave_intervalIntegrable_time (riemannData L O R)
      (riemannData_intervalIntegrable L O R) 1 (Real.log (x+1)) s t
    simpa only [variableTransportRiemann_eq_log L O R x _ hx,travelingWave,one_mul] using h
  · have heq : (fun τ => riemannData L O R (variableTransportLabel x τ)) = fun _ => L := by
      funext τ
      have hn : variableTransportLabel x τ < 0 := by
        dsimp only [variableTransportLabel]
        have hp := mul_nonpos_of_nonpos_of_nonneg (le_of_not_gt hx) (Real.exp_pos (-τ)).le
        linarith
      simp [riemannData,hn]
    rw [heq]
    exact intervalIntegrable_const

/-- The actual globally defined characteristic Riemann field is a weak
solution of the original scalar nondivergence equation under the explicit
source-bearing rectangle convention, with no positivity-domain restriction. -/
theorem variableTransportRiemann_original_weak_solution
    (L O R : ℝ) :
    IsScalarNondivergenceRectangleSolution (fun x => x+1) (fun _ => 1)
      (fun x τ => riemannData L O R (variableTransportLabel x τ)) := by
  refine ⟨fun x => (hasDerivAt_id x).add_const 1,?_,?_,?_,?_,?_⟩
  · intro a b τ hab
    exact (variableTransportRiemann_original_rectangle L O R a b τ τ hab).1 τ
  · intro x s t
    exact (variableTransportRiemann_original_time_integrable L O R x s t).const_mul (x+1)
  · intro a b τ hab
    simpa only [one_mul] using
      (variableTransportRiemann_original_rectangle L O R a b τ τ hab).1 τ
  · intro a b s t hab
    simpa only [one_mul] using
      (variableTransportRiemann_original_rectangle L O R a b s t hab).2.2.1
  · intro a b s t hab
    simpa only [one_mul] using
      (variableTransportRiemann_original_rectangle L O R a b s t hab).2.2.2

end NumStability
