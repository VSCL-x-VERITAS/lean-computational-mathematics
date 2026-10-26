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
# EigenmodeCellAverage

Source-independent mathematics. Actual derivatives, integrability and displayed analytic hypotheses are retained.
-/

namespace NumStability

open Set Filter MeasureTheory Topology
open scoped BigOperators Topology NNReal

/-- A constant background plus one actual matrix eigenmode has the existing
integrated PDE certificate, including discontinuous integrable profiles. -/
theorem constant_add_eigenmode_rectangle
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (profile : ℝ → ℝ) (hprofile : ∀ a b, IntervalIntegrable profile volume a b)
    (speed : ℝ) (vector old : Fin m → ℝ)
    (heigen : coefficient.mulVec vector = speed • vector) :
    IsRectangleConservationLawSolution
      (fun x t => old+eigenmodeTravelingWave profile speed vector x t)
      coefficient.mulVec := by
  have hconst := stationaryField_constantFlux_rectangle (fun _ => old)
    (fun _ _ => intervalIntegrable_const) coefficient.mulVec (coefficient.mulVec old)
    (fun _ => rfl)
  have hmode := eigenmodeTravelingWave_isRectangleSolution coefficient profile
    hprofile speed vector heigen
  let q : Fin 2 → ℝ → ℝ → Fin m → ℝ :=
    ![fun _ _ => old,eigenmodeTravelingWave profile speed vector]
  have hq : ∀ p, IsRectangleConservationLawSolution (q p) coefficient.mulVec := by
    intro p
    fin_cases p
    · exact hconst
    · exact hmode
  simpa only [q,Fin.sum_univ_two,Matrix.cons_val_zero,Matrix.cons_val_one,
    Matrix.head_cons,Matrix.head_fin_const] using finite_sum_isRectangleSolution coefficient q hq

/-- The canonical average of an actual eigenmode field, obtained by splitting
the integral at the moving front. The front's point value is arbitrary. -/
theorem constant_add_eigenmode_average
    {m : ℕ} (old vector : Fin m → ℝ) (l z r speed time a b : ℝ)
    (hab : a < b) (hac : a ≤ speed*time) (hcb : speed*time ≤ b) :
    IntervalIntegrable
      (fun x => old+eigenmodeTravelingWave (riemannData l z r) speed vector x time)
      volume a b ∧
    oneDimensionalCellAverage
      (fun x => old+eigenmodeTravelingWave (riemannData l z r) speed vector x time) a b =
      old+(b-a)⁻¹ • ((speed*time-a) • (l • vector)+(b-speed*time) • (r • vector)) := by
  have heq (x : ℝ) : eigenmodeTravelingWave (riemannData l z r) speed vector x time =
      riemannData (l • vector) (z • vector) (r • vector) (x-speed*time) := by
    simp only [eigenmodeTravelingWave,travelingWave,riemannData]
    split_ifs <;> rfl
  have hj := riemannData_shifted_intervalIntegral (l • vector) (z • vector) (r • vector)
    a (speed*time) b hac hcb
  have hc : IntervalIntegrable (fun _ : ℝ => old) volume a b := intervalIntegrable_const
  simp_rw [heq]
  refine ⟨hc.add hj.1,?_⟩
  simp only [oneDimensionalCellAverage]
  rw [intervalIntegral.integral_add hc hj.1,intervalIntegral.integral_const,hj.2,
    smul_add,smul_smul,inv_mul_cancel₀ (sub_pos.mpr hab).ne',one_smul]

end NumStability
