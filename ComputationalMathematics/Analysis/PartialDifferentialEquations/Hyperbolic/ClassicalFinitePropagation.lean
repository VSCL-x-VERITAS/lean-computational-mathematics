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
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolic.ContractingEnergy
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolic.ForcedEnergyCone
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolic.VaryingCoordinates
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
# ClassicalFinitePropagation

Source-independent mathematics. Actual derivatives, integrability and displayed analytic hypotheses are retained.
-/

namespace NumStability

open Set Filter MeasureTheory Topology
open scoped BigOperators Topology NNReal

/-- Actual zero initial data cannot enter the finite cone of an original
homogeneous classical system with bounded actual varying-coordinate coupling.
The actual coordinate energy and flux are identified, and their growth
inequality is derived from the original PDE rather than assumed. -/
theorem firstOrderEquation_actual_local_cone_zero
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (equation : FirstOrderEquation ι) (q : ℝ → ℝ → ι → ℝ)
    (L R Lt Lx : ℝ → ℝ → Matrix ι ι ℝ)
    (speed speedDerivative : ℝ → ℝ → ι → ℝ)
    (E Et Ex F Fx : ℝ → ℝ → ℝ) (a b C T K H δ lo hi : ℝ)
    (hC : 0 ≤ C) (hT : 0 ≤ T) (hwidth : 0 < b-a-2*C*T) (hδ : 0 < δ)
    (hposition : ∀ τ ∈ Icc (-δ) (T+δ), ∀ y ∈ Icc (0:ℝ) 1,
      a+C*τ+(b-a-2*C*τ)*y ∈ Icc lo hi)
    (henergy : ∀ x τ, E x τ = ∑ p : ι, ((L x τ).mulVec (q x τ) p)^2)
    (hphysicalflux : ∀ x τ, F x τ = ∑ p : ι, speed x τ p * ((L x τ).mulVec (q x τ) p)^2)
    (hE : ContinuousOn (Function.uncurry (fun τ x => E x τ)) (Icc (-δ) (T+δ) ×ˢ Icc lo hi))
    (hEt : ContinuousOn (Function.uncurry (fun τ x => Et x τ)) (Icc (-δ) (T+δ) ×ˢ Icc lo hi))
    (hEx : ContinuousOn (Function.uncurry (fun τ x => Ex x τ)) (Icc (-δ) (T+δ) ×ˢ Icc lo hi))
    (hFx : ContinuousOn (Function.uncurry (fun τ x => Fx x τ)) (Icc (-δ) (T+δ) ×ˢ Icc lo hi))
    (hjoint : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (-δ) (T+δ) → DifferentiableAt ℝ (Function.uncurry E) (x,τ))
    (htime : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (-δ) (T+δ) → HasDerivAt (fun s => E x s) (Et x τ) τ)
    (hspace : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (-δ) (T+δ) → HasDerivAt (fun ξ => E ξ τ) (Ex x τ) x)
    (hflux : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (-δ) (T+δ) → HasDerivAt (fun ξ => F ξ τ) (Fx x τ) x)
    (hclass : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), equation.IsClassicalSolutionAt q x τ)
    (hforcing : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), equation.forcing x τ (q x τ) = 0)
    (hLt : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ i j, HasDerivAt (fun s => L x s i j) (Lt x τ i j) τ)
    (hLx : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ i j, HasDerivAt (fun ξ => L ξ τ i j) (Lx x τ i j) x)
    (hdiag : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), L x τ * equation.principal x τ (q x τ) = Matrix.diagonal (speed x τ) * L x τ)
    (hinverse : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), R x τ * L x τ = 1)
    (hspeed : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ p, HasDerivAt (fun ξ => speed ξ τ p) (speedDerivative x τ p) x)
    (hB : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), finiteOpNorm2Le ((Lt x τ+Matrix.diagonal (speed x τ)*Lx x τ)*R x τ) K)
    (hH : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ p, speedDerivative x τ p ≤ H)
    (hbound : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ p, |speed x τ p| ≤ C)
    (hinit : ∀ x ∈ Icc a b, q x 0 = 0) :
    ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), q x τ = 0 := by
  have hforcingBound :
      ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ),
        finiteVecNorm2 ((L x τ).mulVec (equation.forcing x τ (q x τ))) ≤
          (0:ℝ)*finiteVecNorm2 ((L x τ).mulVec (q x τ)) := by
    intro τ hτ x hx
    rw [hforcing τ hτ x hx, Matrix.mulVec_zero]
    change finiteVecNorm2 (fun _ : ι => (0 : ℝ)) ≤
      (0 : ℝ) * finiteVecNorm2 ((L x τ).mulVec (q x τ))
    rw [finiteVecNorm2_zero]
    simp
  exact firstOrderEquation_actual_forced_local_cone_zero
    equation q L R Lt Lx speed speedDerivative E Et Ex F Fx
    a b C T K H 0 δ lo hi hC hT hwidth hδ hposition henergy hphysicalflux
    hE hEt hEx hFx hjoint htime hspace hflux hclass hforcingBound
    hLt hLx hdiag hinverse hspeed hB hH hbound hinit

/-- Finite local C1 regularity of the actual original field and varying basis supplies all energy and flux regularity for zero-data cone propagation. -/
theorem firstOrderEquation_actual_c1_cone_zero
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (equation : FirstOrderEquation ι) (q : ℝ → ℝ → ι → ℝ)
    (L R Lt Lx : ℝ → ℝ → Matrix ι ι ℝ)
    (speed speedDerivative : ℝ → ℝ → ι → ℝ)

    (a b C T K H δ lo hi : ℝ) (X U : Set ℝ)
    (hX : IsOpen X) (hU : IsOpen U)
    (hbox : Icc lo hi ×ˢ Icc (-δ) (T+δ) ⊆ X ×ˢ U)
    (hq : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => q p.1 p.2 i) (X ×ˢ U))
    (hL : ∀ i j, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => L p.1 p.2 i j) (X ×ˢ U))
    (hs : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => speed p.1 p.2 i) (X ×ˢ U))
    (hC : 0 ≤ C) (hT : 0 ≤ T) (hwidth : 0 < b-a-2*C*T) (hδ : 0 < δ)
    (hposition : ∀ τ ∈ Icc (-δ) (T+δ), ∀ y ∈ Icc (0:ℝ) 1,
      a+C*τ+(b-a-2*C*τ)*y ∈ Icc lo hi)
    (hclass : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), equation.IsClassicalSolutionAt q x τ)
    (hforcing : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), equation.forcing x τ (q x τ) = 0)
    (hLt : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ i j, HasDerivAt (fun s => L x s i j) (Lt x τ i j) τ)
    (hLx : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ i j, HasDerivAt (fun ξ => L ξ τ i j) (Lx x τ i j) x)
    (hdiag : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), L x τ * equation.principal x τ (q x τ) = Matrix.diagonal (speed x τ) * L x τ)
    (hinverse : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), R x τ * L x τ = 1)
    (hspeed : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ p, HasDerivAt (fun ξ => speed ξ τ p) (speedDerivative x τ p) x)
    (hB : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), finiteOpNorm2Le ((Lt x τ+Matrix.diagonal (speed x τ)*Lx x τ)*R x τ) K)
    (hH : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ p, speedDerivative x τ p ≤ H)
    (hbound : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ p, |speed x τ p| ≤ C)
    (hinit : ∀ x ∈ Icc a b, q x 0 = 0) :
    ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), q x τ = 0 := by
  have hforcingBound :
      ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ),
        finiteVecNorm2 ((L x τ).mulVec (equation.forcing x τ (q x τ))) ≤
          (0:ℝ)*finiteVecNorm2 ((L x τ).mulVec (q x τ)) := by
    intro τ hτ x hx
    rw [hforcing τ hτ x hx, Matrix.mulVec_zero]
    change finiteVecNorm2 (fun _ : ι => (0 : ℝ)) ≤
      (0 : ℝ) * finiteVecNorm2 ((L x τ).mulVec (q x τ))
    rw [finiteVecNorm2_zero]
    simp
  exact firstOrderEquation_actual_forced_c1_cone_zero
    equation q L R Lt Lx speed speedDerivative
    a b C T K H 0 δ lo hi X U hX hU hbox hq hL hs
    hC hT hwidth hδ hposition hclass hforcingBound
    hLt hLx hdiag hinverse hspeed hB hH hbound hinit

/-- Actual local C1 homogeneous original systems have finite zero-data propagation; compactness derives the coupling constants and all energy regularity. -/
theorem firstOrderEquation_actual_c1_finite_propagation
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (equation : FirstOrderEquation ι) (q : ℝ → ℝ → ι → ℝ)
    (L R : ℝ → ℝ → Matrix ι ι ℝ)
    (speed : ℝ → ℝ → ι → ℝ)

    (a b C T δ lo hi : ℝ) (X U : Set ℝ)
    (hX : IsOpen X) (hU : IsOpen U)
    (hbox : Icc lo hi ×ˢ Icc (-δ) (T+δ) ⊆ X ×ˢ U)
    (hq : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => q p.1 p.2 i) (X ×ˢ U))
    (hL : ∀ i j, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => L p.1 p.2 i j) (X ×ˢ U))
    (hR : ∀ i j, ContinuousOn (fun p : ℝ × ℝ => R p.1 p.2 i j) (X ×ˢ U))
    (hs : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => speed p.1 p.2 i) (X ×ˢ U))
    (hC : 0 ≤ C) (hT : 0 ≤ T) (hwidth : 0 < b-a-2*C*T) (hδ : 0 < δ)
    (hposition : ∀ τ ∈ Icc (-δ) (T+δ), ∀ y ∈ Icc (0:ℝ) 1,
      a+C*τ+(b-a-2*C*τ)*y ∈ Icc lo hi)
    (hclass : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), equation.IsClassicalSolutionAt q x τ)
    (hforcing : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), equation.forcing x τ (q x τ) = 0)
    (hdiag : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), L x τ * equation.principal x τ (q x τ) = Matrix.diagonal (speed x τ) * L x τ)
    (hinverse : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), R x τ * L x τ = 1)
    (hbound : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ p, |speed x τ p| ≤ C)
    (hinit : ∀ x ∈ Icc a b, q x 0 = 0) :
    ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), q x τ = 0 := by
  have hforcingBound :
      ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ),
        finiteVecNorm2 ((L x τ).mulVec (equation.forcing x τ (q x τ))) ≤
          (0:ℝ)*finiteVecNorm2 ((L x τ).mulVec (q x τ)) := by
    intro τ hτ x hx
    rw [hforcing τ hτ x hx, Matrix.mulVec_zero]
    change finiteVecNorm2 (fun _ : ι => (0 : ℝ)) ≤
      (0 : ℝ) * finiteVecNorm2 ((L x τ).mulVec (q x τ))
    rw [finiteVecNorm2_zero]
    simp
  exact firstOrderEquation_actual_forced_c1_finite_propagation
    equation q L R speed a b C T 0 δ lo hi X U hX hU hbox hq hL hR hs
    hC hT hwidth hδ hposition hclass hforcingBound hdiag hinverse hbound hinit

end NumStability
