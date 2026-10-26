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
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolic.DomainOfDependence
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.AffineExponentialRiemann
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.AffineExponentialRiemannWeak
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.MaterialDerivative
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.ScalarNondivergenceRectangle
import ComputationalMathematics.Analysis.PartialDifferentialEquations.VariableLinearFlux
import ComputationalMathematics.Source.LeVeque.Chapter01.ScalarHyperbolicity
import ComputationalMathematics.Source.LeVeque.Chapter04.AcousticEigenbasis
import ComputationalMathematics.Source.LeVeque.Chapter04.LinearRiemannWaveJump
import ComputationalMathematics.Source.LeVeque.Chapter04.NonconservativeWaveScope
import ComputationalMathematics.Source.LeVeque.Chapter04.SpectralFluctuations
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
# NonconservativeRiemannDiscrepancy

Source correspondence and separately qualified corrections for LeVeque Chapter 4, printed page 76 (raw PDF page 98).
-/

namespace NumStability

open Set Filter MeasureTheory Topology
open scoped BigOperators Topology NNReal

theorem leveque04_variableTransportCoefficient_hyperbolic_no_flux :
    (∀ x : ℝ, IsRealHyperbolicMatrix (constantCoefficientScalarMatrix (x+1))) ∧
    ¬ ∃ flux : ℝ → ℝ → ℝ, RepresentsScalarTransportFlux (fun x => x+1) flux := by
  refine ⟨fun x => leveque01_scalarEquation_isHyperbolic (x+1),?_⟩
  rintro ⟨flux,hflux⟩
  have h := hflux.coefficient_eq 0 1
  norm_num at h

/-- Closed source-domain witness: the original variable-coefficient scalar
equation is pointwise hyperbolic and has a genuine original-density weak
Riemann solution whose discontinuity moves with nonconstant speed. -/
theorem leveque04_nonconservative_originalWeakRiemann_witness :
    let q := fun x τ => riemannData (0:ℝ) 0 1 (variableTransportLabel x τ)
    (∀ x : ℝ, IsRealHyperbolicMatrix (constantCoefficientScalarMatrix (x+1))) ∧
    (¬ ∃ flux : ℝ → ℝ → ℝ, RepresentsScalarTransportFlux (fun x => x+1) flux) ∧
    IsRiemannData (fun x => q x 0) 0 1 ∧
    IsScalarNondivergenceRectangleSolution (fun x => x+1) (fun _ => 1) q ∧
    (∀ τ, ¬ ContinuousAt (fun x => q x τ) (Real.exp τ-1)) ∧
    (¬ ∃ c : ℝ, ∀ τ ∈ Ioo (0:ℝ) 1, Real.exp τ-1=c*τ) := by
  dsimp only
  refine ⟨leveque04_variableTransportCoefficient_hyperbolic_no_flux.1,
    leveque04_variableTransportCoefficient_hyperbolic_no_flux.2,
    (variableTransportRiemann_initial_and_front (0:ℝ) 0 1).1,
    variableTransportRiemann_original_weak_solution 0 0 1,?_,
    variableTransportFront_not_constant_on_forward_step⟩
  intro τ hc
  have hv := variableTransportRiemann_discontinuous_front
    (0 : Fin 1 → ℝ) 0 (fun _ => 1)
    (by intro h; have hh := congrFun h (0 : Fin 1); norm_num at hh) τ
  apply hv
  have hpi : ContinuousAt (fun x => (fun _ : Fin 1 =>
      riemannData (0:ℝ) 0 1 (variableTransportLabel x τ))) (Real.exp τ-1) :=
    continuousAt_pi.mpr (fun _ => hc)
  have heq : (fun x => (fun _ : Fin 1 => riemannData (0:ℝ) 0 1 (variableTransportLabel x τ))) =
      (fun x => riemannData (0 : Fin 1 → ℝ) 0 (fun _ => 1) (variableTransportLabel x τ)) := by
    funext x j
    simp only [riemannData,ite_apply,Pi.zero_apply]
  rw [heq] at hpi
  exact hpi

/-- This diagnostic is about the actual original characteristic weak
Riemann solution, not every representative of an arbitrary weak solution.
It records the literal finite constant-speed jump-wave specialization only. -/
def leveque04_nonconservative_printed_constantSpeedWaves : Prop :=
  ∃ (m : ℕ) (base : ℝ) (left origin right speed : Fin m → ℝ),
    ∀ t ∈ Ioo (0:ℝ) 1,
      (fun x => riemannData (0:ℝ) 0 1 (variableTransportLabel x t)) =ᵐ[volume]
        (fun x => base+∑ p, riemannData (left p) (origin p) (right p) (x-speed p*t))

theorem leveque04_nonconservative_printed_constantSpeedWaves_refuted :
    ¬ leveque04_nonconservative_printed_constantSpeedWaves :=
  variableTransportRiemann_no_finite_constant_speed_waves (0:ℝ) 0 1 (by norm_num)

/-- Robust closed source-domain witness. The actual original weak solution
has a genuine limiting initial trace and finite bounded forward front speed.
Its failure of constant-speed waves holds modulo spatial null sets at every
positive time, so it is not an artifact of isolated representative values. -/
theorem leveque04_nonconservative_originalWeakRiemann_aeWitness :
    let q := fun x τ => riemannData (0:ℝ) 0 1 (variableTransportLabel x τ)
    (∀ x : ℝ, IsRealHyperbolicMatrix (constantCoefficientScalarMatrix (x+1))) ∧
    (¬ ∃ flux : ℝ → ℝ → ℝ, RepresentsScalarTransportFlux (fun x => x+1) flux) ∧
    IsRiemannData (fun x => q x 0) 0 1 ∧
    IsScalarNondivergenceRectangleSolution (fun x => x+1) (fun _ => 1) q ∧
    (∀ x, x ≠ 0 → Tendsto (q x) (𝓝 (0:ℝ)) (𝓝 (riemannData (0:ℝ) 0 1 x))) ∧
    (∀ τ, ¬ ContinuousAt (fun x => q x τ) (Real.exp τ-1)) ∧
    (¬ ∃ profile : ℝ → ℝ, ∀ t ∈ Ioo (0:ℝ) 1,
      (fun x => q x t) =ᵐ[volume] (fun x => profile (x/t))) ∧
    (¬ ∃ (m : ℕ) (base : ℝ) (left origin right speed : Fin m → ℝ),
      ∀ t ∈ Ioo (0:ℝ) 1, (fun x => q x t) =ᵐ[volume]
        (fun x => base+∑ p, riemannData (left p) (origin p) (right p) (x-speed p*t))) ∧
    (∀ t ∈ Icc (0:ℝ) 1,
      HasDerivAt (fun τ => Real.exp τ-1) ((Real.exp t-1)+1) t ∧
      0 < (Real.exp t-1)+1 ∧ (Real.exp t-1)+1 ≤ Real.exp 1) := by
  dsimp only
  have hw := leveque04_nonconservative_originalWeakRiemann_witness
  dsimp only at hw
  refine ⟨hw.1,hw.2.1,hw.2.2.1,hw.2.2.2.1,?_,hw.2.2.2.2.1,
    variableTransportRiemann_not_ae_selfsimilar (0:ℝ) 0 1 (by norm_num),
    variableTransportRiemann_no_finite_constant_speed_waves (0:ℝ) 0 1 (by norm_num),
    variableTransportRiemann_forward_variable_speed_corrected.1⟩
  intro x hx
  exact variableTransportRiemann_actual_initial_trace 0 0 1 x hx

end NumStability
