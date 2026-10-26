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
# VaryingCoordinates

Source-independent mathematics. Actual derivatives, integrability and displayed analytic hypotheses are retained.
-/

namespace NumStability

open Set Filter MeasureTheory Topology
open scoped BigOperators Topology NNReal

/-- Pointwise varying left coordinates expose the coupling terms of the
actual original system. Freezing the basis would omit these terms. This is
an auxiliary identity, with no propagation or coordinate-existence promise. -/
theorem firstOrderEquation_varying_coordinates_residual
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (equation : FirstOrderEquation ι) (q : ℝ → ℝ → ι → ℝ)
    (L : ℝ → ℝ → Matrix ι ι ℝ) (Lt Lx D : Matrix ι ι ℝ) (x t : ℝ)
    (hclass : equation.IsClassicalSolutionAt q x t)
    (hLt : ∀ i j, HasDerivAt (fun τ => L x τ i j) (Lt i j) t)
    (hLx : ∀ i j, HasDerivAt (fun ξ => L ξ t i j) (Lx i j) x)
    (hdiagonal : L x t * equation.principal x t (q x t) = D * L x t) :
    ∃ wt wx : ι → ℝ,
      HasDerivAt (fun τ => (L x τ).mulVec (q x τ)) wt t ∧
      HasDerivAt (fun ξ => (L ξ t).mulVec (q ξ t)) wx x ∧
      wt + D.mulVec wx = (Lt + D * Lx).mulVec (q x t) +
        (L x t).mulVec (equation.forcing x t (q x t)) := by
  rcases hclass with ⟨_hadmissible,qt,qx,hqt,hqx,hres⟩
  refine ⟨Lt.mulVec (q x t)+(L x t).mulVec qt,
    Lx.mulVec (q x t)+(L x t).mulVec qx,
    hasDerivAt_variableLinearFlux_comp (fun τ => L x τ) (fun τ => q x τ)
      Lt qt t hLt hqt,
    hasDerivAt_variableLinearFlux_comp (fun ξ => L ξ t) (fun ξ => q ξ t)
      Lx qx x hLx hqx,?_⟩
  have hpde := (equation.residual_eq_zero_iff x t (q x t) qt qx).mp hres
  have hactual := congrArg (fun v => (L x t).mulVec v) hpde
  dsimp only at hactual
  rw [Matrix.mulVec_add,Matrix.mulVec_mulVec,hdiagonal,
    ← Matrix.mulVec_mulVec] at hactual
  rw [Matrix.mulVec_add,Matrix.add_mulVec,← Matrix.mulVec_mulVec]
  rw [← hactual]
  abel

/-- The original varying-coordinate field has its actual coupling source
along each supplied eigencharacteristic. No frozen evolution is substituted. -/
theorem firstOrderEquation_varying_coordinate_characteristic
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (equation : FirstOrderEquation ι) (q : ℝ → ℝ → ι → ℝ)
    (L : ℝ → ℝ → Matrix ι ι ℝ) (Lt Lx : Matrix ι ι ℝ)
    (speeds : ι → ℝ) (curve : ℝ → ℝ) (p : ι) (t : ℝ)
    (hclass : equation.IsClassicalSolutionAt q (curve t) t)
    (hLt : ∀ i j, HasDerivAt (fun τ => L (curve t) τ i j) (Lt i j) t)
    (hLx : ∀ i j, HasDerivAt (fun ξ => L ξ t i j) (Lx i j) (curve t))
    (hdiagonal : L (curve t) t * equation.principal (curve t) t (q (curve t) t) =
      Matrix.diagonal speeds * L (curve t) t)
    (hjoint : DifferentiableAt ℝ
      (Function.uncurry (fun x τ => (L x τ).mulVec (q x τ) p)) (curve t,t))
    (hcurve : HasDerivAt curve (speeds p) t) :
    HasDerivAt (fun τ => (L (curve τ) τ).mulVec (q (curve τ) τ) p)
      (((Lt + Matrix.diagonal speeds * Lx).mulVec (q (curve t) t) +
        (L (curve t) t).mulVec (equation.forcing (curve t) t (q (curve t) t))) p) t := by
  obtain ⟨wt,wx,hwt,hwx,hres⟩ := firstOrderEquation_varying_coordinates_residual
    equation q L Lt Lx (Matrix.diagonal speeds) (curve t) t hclass hLt hLx hdiagonal
  have ht := hasDerivAt_pi.mp hwt p
  have hx := hasDerivAt_pi.mp hwx p
  have h := materialDerivative_hasDerivWithinAt
    (q := fun x τ => (L x τ).mulVec (q x τ) p)
    (velocity := fun _ => speeds p) (curve := curve) (t := t)
    (spaceDomain := Set.univ) (timeDomain := Set.univ) (characteristicTimes := Set.univ)
    (Set.mem_univ t) (fun τ _ => ⟨Set.mem_univ (curve τ),Set.mem_univ τ⟩)
    uniqueDiffWithinAt_univ uniqueDiffWithinAt_univ
    hjoint.hasFDerivAt.hasFDerivWithinAt
    ht.hasDerivWithinAt hx.hasDerivWithinAt hcurve.hasDerivWithinAt
  have hc := congrFun hres p
  simp only [Pi.add_apply,Matrix.mulVec_diagonal] at hc
  have hd : HasDerivAt (fun τ => (L (curve τ) τ).mulVec (q (curve τ) τ) p)
      (wt p + speeds p * wx p) t := by
    simpa only [smul_eq_mul] using hasDerivWithinAt_univ.mp h
  rw [hc] at hd
  exact hd

/-- The exact local energy identity for an actual diagonal coordinate
equation, retaining both coordinate coupling and speed derivatives. This
pointwise prerequisite does not yet assert a spacetime cone estimate. -/
theorem varyingCoordinate_local_energy_identity
    {ι : Type*} [Fintype ι]
    (w : ℝ → ℝ → ι → ℝ) (speed : ℝ → ι → ℝ)
    (wt wx speedDerivative source : ι → ℝ) (x t : ℝ)
    (hwt : ∀ p, HasDerivAt (fun τ => w x τ p) (wt p) t)
    (hwx : ∀ p, HasDerivAt (fun ξ => w ξ t p) (wx p) x)
    (hspeed : ∀ p, HasDerivAt (fun ξ => speed ξ p) (speedDerivative p) x)
    (hres : ∀ p, wt p + speed x p * wx p = source p) :
    ∃ energyTime fluxSpace : ℝ,
      HasDerivAt (fun τ => ∑ p : ι, (w x τ p)^2) energyTime t ∧
      HasDerivAt (fun ξ => ∑ p : ι, speed ξ p * (w ξ t p)^2) fluxSpace x ∧
      energyTime + fluxSpace =
        ∑ p : ι, (2 * w x t p * source p + speedDerivative p * (w x t p)^2) := by
  classical
  refine ⟨∑ p : ι, 2 * w x t p * wt p,
    ∑ p : ι, (speedDerivative p * (w x t p)^2 +
      speed x p * (2 * w x t p * wx p)),?_,?_,?_⟩
  · simpa only [Nat.cast_ofNat,Nat.reduceSub,pow_one,Pi.pow_apply,Pi.mul_apply] using
      HasDerivAt.fun_sum (u := Finset.univ) (fun p _ => (hwt p).pow 2)
  · simpa only [Nat.cast_ofNat,Nat.reduceSub,pow_one,Pi.pow_apply,Pi.mul_apply] using
      HasDerivAt.fun_sum (u := Finset.univ)
        (fun p _ => (hspeed p).mul ((hwx p).pow 2))
  · rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro p _
    calc
      _ = 2 * w x t p * (wt p + speed x p * wx p) +
          speedDerivative p * (w x t p)^2 := by ring
      _ = _ := by rw [hres p]

/-- The existing finite operator bound controls the actual coordinate energy
source. No new norm or alternative matrix-vector product is defined. -/
theorem varyingCoordinate_energy_growth_bound
    {ι : Type*} [Fintype ι]
    (w d : ι → ℝ) (B : Matrix ι ι ℝ) (K H : ℝ)
    (hB : finiteOpNorm2Le B K) (hd : ∀ i, d i ≤ H) :
    (∑ i : ι, (2 * w i * (B.mulVec w) i + d i * (w i)^2)) ≤
      (2 * K + H) * (∑ i : ι, (w i)^2) := by
  classical
  have inner : (∑ i : ι, w i * (B.mulVec w) i) ≤ K * (∑ i : ι, (w i)^2) := by
    have h := (le_abs_self (∑ i : ι, w i * finiteMatVec B w i)).trans
      (abs_finiteVecInnerProduct_finiteMatVec_le_of_finiteOpNorm2Le B hB w)
    simpa only [finiteMatVec, Matrix.mulVec, dotProduct, finiteVecNorm2Sq] using h
  have coupling : (∑ i : ι, 2 * w i * (B.mulVec w) i) ≤
      2 * K * (∑ i : ι, (w i)^2) := by
    calc
      _ = 2 * (∑ i : ι, w i * (B.mulVec w) i) := by
        rw [Finset.mul_sum]; apply Finset.sum_congr rfl; intro i _; ring
      _ ≤ 2 * (K * (∑ i : ι, (w i)^2)) := mul_le_mul_of_nonneg_left inner (by norm_num)
      _ = _ := by ring
  have diagonal : (∑ i : ι, d i * (w i)^2) ≤ H * (∑ i : ι, (w i)^2) := by
    rw [Finset.mul_sum]
    exact Finset.sum_le_sum (fun i _ => mul_le_mul_of_nonneg_right (hd i) (sq_nonneg _))
  rw [Finset.sum_add_distrib, add_mul]
  exact add_le_add coupling diagonal

/-- The actual diagonal energy flux is bounded by the local speed bound.
This gives the boundary sign for a cone contracting at speed C. -/
theorem diagonalEnergyFlux_boundary_bound
    {ι : Type*} [Fintype ι] (state speed : ι → ℝ) (C : ℝ)
    (hbound : ∀ p, |speed p| ≤ C) :
    |∑ p : ι, speed p * (state p)^2| ≤ C * (∑ p : ι, (state p)^2) := by
  classical
  apply abs_le.mpr
  constructor
  · have h := Finset.sum_le_sum (s := Finset.univ)
      (fun p _ => mul_le_mul_of_nonneg_right (abs_le.mp (hbound p)).1 (sq_nonneg (state p)))
    rw [← Finset.mul_sum] at h
    simpa only [neg_mul] using h
  · have h := Finset.sum_le_sum (s := Finset.univ)
      (fun p _ => mul_le_mul_of_nonneg_right (abs_le.mp (hbound p)).2 (sq_nonneg (state p)))
    rw [← Finset.mul_sum] at h
    exact h

/-- The original homogeneous equation in actual varying coordinates,
including the derived matrix coupling through the actual inverse. -/
theorem firstOrderEquation_actual_coupled_coordinates
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (equation : FirstOrderEquation ι) (q : ℝ → ℝ → ι → ℝ)
    (L : ℝ → ℝ → Matrix ι ι ℝ) (R Lt Lx : Matrix ι ι ℝ)
    (speed : ι → ℝ) (x t : ℝ)
    (hclass : equation.IsClassicalSolutionAt q x t)
    (hforcing : equation.forcing x t (q x t) = 0)
    (hLt : ∀ i j, HasDerivAt (fun τ => L x τ i j) (Lt i j) t)
    (hLx : ∀ i j, HasDerivAt (fun ξ => L ξ t i j) (Lx i j) x)
    (hdiag : L x t * equation.principal x t (q x t) = Matrix.diagonal speed * L x t)
    (hinverse : R * L x t = 1) :
    ∃ wt wx : ι → ℝ,
      HasDerivAt (fun τ => (L x τ).mulVec (q x τ)) wt t ∧
      HasDerivAt (fun ξ => (L ξ t).mulVec (q ξ t)) wx x ∧
      wt + (Matrix.diagonal speed).mulVec wx =
        ((Lt+Matrix.diagonal speed*Lx)*R).mulVec ((L x t).mulVec (q x t)) := by
  obtain ⟨wt,wx,hwt,hwx,hres⟩ := firstOrderEquation_varying_coordinates_residual
    equation q L Lt Lx (Matrix.diagonal speed) x t hclass hLt hLx hdiag
  refine ⟨wt,wx,hwt,hwx,?_⟩
  rw [hforcing,Matrix.mulVec_zero,add_zero] at hres
  rw [hres,Matrix.mulVec_mulVec,Matrix.mul_assoc,hinverse,Matrix.mul_one]

/-- Actual original-system coordinate energy has its local differential
inequality and bounded flux; no cone propagation or energy derivative is
assumed. Bounds use the existing finite Euclidean operator norm API. -/
theorem firstOrderEquation_actual_coordinate_energy
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (equation : FirstOrderEquation ι) (q : ℝ → ℝ → ι → ℝ)
    (L : ℝ → ℝ → Matrix ι ι ℝ) (R Lt Lx : Matrix ι ι ℝ)
    (speed : ℝ → ℝ → ι → ℝ) (speedDerivative : ι → ℝ)
    (x t C K H : ℝ)
    (hclass : equation.IsClassicalSolutionAt q x t)
    (hforcing : equation.forcing x t (q x t) = 0)
    (hLt : ∀ i j, HasDerivAt (fun τ => L x τ i j) (Lt i j) t)
    (hLx : ∀ i j, HasDerivAt (fun ξ => L ξ t i j) (Lx i j) x)
    (hdiag : L x t * equation.principal x t (q x t) = Matrix.diagonal (speed x t) * L x t)
    (hinverse : R * L x t = 1)
    (hspeed : ∀ p, HasDerivAt (fun ξ => speed ξ t p) (speedDerivative p) x)
    (hB : finiteOpNorm2Le ((Lt+Matrix.diagonal (speed x t)*Lx)*R) K)
    (hH : ∀ p, speedDerivative p ≤ H)
    (hC : ∀ p, |speed x t p| ≤ C) :
    ∃ energyTime fluxSpace : ℝ,
      HasDerivAt (fun τ => ∑ p : ι, ((L x τ).mulVec (q x τ) p)^2) energyTime t ∧
      HasDerivAt (fun ξ => ∑ p : ι, speed ξ t p * ((L ξ t).mulVec (q ξ t) p)^2) fluxSpace x ∧
      energyTime + fluxSpace ≤ (2*K+H) * (∑ p : ι, ((L x t).mulVec (q x t) p)^2) ∧
      |∑ p : ι, speed x t p * ((L x t).mulVec (q x t) p)^2| ≤
        C * (∑ p : ι, ((L x t).mulVec (q x t) p)^2) := by
  obtain ⟨wt,wx,hwt,hwx,hres⟩ := firstOrderEquation_actual_coupled_coordinates
    equation q L R Lt Lx (speed x t) x t hclass hforcing hLt hLx hdiag hinverse
  have hpoint (p : ι) : wt p + speed x t p * wx p =
      (((Lt+Matrix.diagonal (speed x t)*Lx)*R).mulVec ((L x t).mulVec (q x t))) p := by
    simpa only [Pi.add_apply,Matrix.mulVec_diagonal] using congrFun hres p
  obtain ⟨Et,Fx,hEt,hFx,henergy⟩ := varyingCoordinate_local_energy_identity
    (fun ξ τ => (L ξ τ).mulVec (q ξ τ)) (fun ξ => speed ξ t)
    wt wx speedDerivative
    (((Lt+Matrix.diagonal (speed x t)*Lx)*R).mulVec ((L x t).mulVec (q x t))) x t
    (hasDerivAt_pi.mp hwt) (hasDerivAt_pi.mp hwx) hspeed hpoint
  refine ⟨Et,Fx,hEt,hFx,?_,diagonalEnergyFlux_boundary_bound _ _ C hC⟩
  rw [henergy]
  exact varyingCoordinate_energy_growth_bound _ speedDerivative _ K H hB hH

end NumStability
