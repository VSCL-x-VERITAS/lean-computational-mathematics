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
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.MaterialDerivative
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
# ScalarNondivergenceRectangle

Source-independent mathematics. Actual derivatives, integrability and displayed analytic hypotheses are retained.
-/

namespace NumStability

open Set Filter MeasureTheory Topology
open scoped BigOperators Topology NNReal

/-- The distributional balance rewriting uses the original density and a
coefficient derivative. Its classical residual agrees exactly with the
nondivergence residual; the source term is derived, not discarded. -/
theorem scalarTransport_original_balance_residual
    (coefficient profile : ℝ → ℝ) (x coefficientDerivative qt qx : ℝ)
    (ha : HasDerivAt coefficient coefficientDerivative x)
    (hq : HasDerivAt profile qx x) :
    HasDerivAt (fun y => coefficient y*profile y)
      (coefficientDerivative*profile x+coefficient x*qx) x ∧
    (qt+coefficient x*qx=0 ↔
      qt+(coefficientDerivative*profile x+coefficient x*qx)=coefficientDerivative*profile x) := by
  refine ⟨?_,?_⟩
  · exact ha.mul hq
  · constructor <;> intro h <;> linarith

/-- Explicit rectangle weak convention for a smooth scalar nondivergence
coefficient. The original density q obeys q_t+(a q)_x=a' q, with both
boundary transport and actual source integrable. This convention contains
no characteristic, propagation, Riemann or desired witness assumption. -/
def IsScalarNondivergenceRectangleSolution
    (coefficient coefficientDerivative : ℝ → ℝ) (q : ℝ → ℝ → ℝ) : Prop :=
  (∀ x, HasDerivAt coefficient (coefficientDerivative x) x) ∧
  (∀ a b τ, a ≤ b → IntervalIntegrable (fun x => q x τ) volume a b) ∧
  (∀ x s t, IntervalIntegrable (fun τ => coefficient x*q x τ) volume s t) ∧
  (∀ a b τ, a ≤ b → IntervalIntegrable (fun x => coefficientDerivative x*q x τ) volume a b) ∧
  (∀ a b s t, a ≤ b → IntervalIntegrable
    (fun τ => ∫ x in a..b, coefficientDerivative x*q x τ) volume s t) ∧
  (∀ a b s t, a ≤ b →
    (∫ x in a..b, q x t)-(∫ x in a..b, q x s) =
      (∫ τ in s..t, coefficient a*q a τ-coefficient b*q b τ)+
      (∫ τ in s..t, ∫ x in a..b, coefficientDerivative x*q x τ))

/-- Qualified corrected regime: the actual selected scalar constant-
coefficient Riemann solution obeys the original weak convention, has
true Riemann initial data and constant-speed self-similarity. This asserts
neither universal variable-coefficient waves nor a general weak theory. -/
theorem constantCoefficient_scalar_riemann_corrected (L O R speed : ℝ) :
    let q := travelingWave (riemannData L O R) speed
    IsScalarNondivergenceRectangleSolution (fun _ => speed) (fun _ => 0) q ∧
    IsRiemannData (fun x => q x 0) L R ∧
    (∃ profile : ℝ → ℝ, ∀ x t, 0 < t → q x t=profile (x/t)) := by
  dsimp only
  have hrect := travelingWave_isRectangleConservationLawSolution (riemannData L O R)
    (riemannData_intervalIntegrable L O R) speed
  refine ⟨?_,?_,?_⟩
  · refine ⟨fun x => hasDerivAt_const x speed,?_,?_,?_,?_,?_⟩
    · intro a b τ _hab
      exact hrect.1 a b τ
    · intro x s t
      simpa only [smul_eq_mul] using hrect.2.1 x s t
    · intro a b τ _hab
      simp only [zero_mul]
      exact intervalIntegrable_const
    · intro a b s t _hab
      simp only [zero_mul,intervalIntegral.integral_zero]
      exact intervalIntegrable_const
    · intro a b s t _hab
      simpa only [zero_mul,intervalIntegral.integral_zero,add_zero,smul_eq_mul] using hrect.2.2 a b s t
  · simpa only [travelingWave,mul_zero,sub_zero] using riemannData_isRiemannData L O R
  · refine ⟨fun ray => riemannData L O R (ray-speed),?_⟩
    intro x t ht
    dsimp only [travelingWave]
    rw [show x-speed*t=(x/t-speed)*t by field_simp]
    exact riemannData_mul_pos L O R _ ht

end NumStability
