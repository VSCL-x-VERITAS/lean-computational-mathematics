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
# CellAverageSpatialSlope

Source-independent mathematics. Actual derivatives, integrability and displayed analytic hypotheses are retained.
-/

namespace NumStability

open Set Filter MeasureTheory Topology
open scoped BigOperators Topology NNReal

theorem trueCellAverage_backwardSlope_error_le
    (f f' : ℝ → ℝ) (K center width : ℝ)
    (hK : 0 ≤ K) (hw : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hLip : ∀ x y, |f' x-f' y| ≤ K*|x-y|) :
    let avg := fun c => oneDimensionalCellAverage f (c-width/2) (c+width/2)
    |(avg center-avg (center-width))/width-f' center| ≤ (3*K/2)*width := by
  let avg := fun c => oneDimensionalCellAverage f (c-width/2) (c+width/2)
  let face := (f (center+width/2)-f (center-width/2))/width
  have hlip : LipschitzWith ⟨K,hK⟩ f' :=
    LipschitzWith.of_dist_le_mul (fun x y => by simpa only [Real.dist_eq] using hLip x y)
  have hfaces := oneDimensionalCellAverage_sub_center_le_of_lipschitz
    f' K center width hK hw hlip.continuous hLip
  rw [oneDimensionalCellAverage_derivativeProfile_eq_faceSlope
    f f' _ _ hf hlip.continuous] at hfaces
  have hspan : center+width/2-(center-width/2)=width := by ring
  rw [hspan] at hfaces
  have hneighbor := (oneDimensionalCellAverage_neighborTaylor f f' K center width
    hK hw hf hLip).1
  change |avg (center-width)-(avg center-width*face)| ≤ K*width^2 at hneighbor
  have hid : (avg center-avg (center-width))/width-face =
      -(avg (center-width)-(avg center-width*face))/width := by
    field_simp
    ring
  have hback : |(avg center-avg (center-width))/width-face| ≤ K*width := by
    rw [hid,abs_div,abs_neg,abs_of_pos hw]
    apply (div_le_iff₀ hw).mpr
    convert hneighbor using 1
    ring
  have htri := abs_add_le ((avg center-avg (center-width))/width-face) (face-f' center)
  have heq : (avg center-avg (center-width))/width-face+(face-f' center) =
      (avg center-avg (center-width))/width-f' center := by ring
  rw [heq] at htri
  change |(avg center-avg (center-width))/width-f' center| ≤ _
  change |face-f' center| ≤ K*(width/2) at hfaces
  linarith

theorem trueCellAverage_forwardSlope_error_le
    (f f' : ℝ → ℝ) (K center width : ℝ)
    (hK : 0 ≤ K) (hw : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hLip : ∀ x y, |f' x-f' y| ≤ K*|x-y|) :
    let avg := fun c => oneDimensionalCellAverage f (c-width/2) (c+width/2)
    |(avg (center+width)-avg center)/width-f' center| ≤ (3*K/2)*width := by
  let avg := fun c => oneDimensionalCellAverage f (c-width/2) (c+width/2)
  let face := (f (center+width/2)-f (center-width/2))/width
  have hlip : LipschitzWith ⟨K,hK⟩ f' :=
    LipschitzWith.of_dist_le_mul (fun x y => by simpa only [Real.dist_eq] using hLip x y)
  have hfaces := oneDimensionalCellAverage_sub_center_le_of_lipschitz
    f' K center width hK hw hlip.continuous hLip
  rw [oneDimensionalCellAverage_derivativeProfile_eq_faceSlope
    f f' _ _ hf hlip.continuous] at hfaces
  have hspan : center+width/2-(center-width/2)=width := by ring
  rw [hspan] at hfaces
  have hneighbor := (oneDimensionalCellAverage_neighborTaylor f f' K center width
    hK hw hf hLip).2
  change |avg (center+width)-(avg center+width*face)| ≤ K*width^2 at hneighbor
  have hid : (avg (center+width)-avg center)/width-face =
      (avg (center+width)-(avg center+width*face))/width := by
    field_simp
    ring
  have hforw : |(avg (center+width)-avg center)/width-face| ≤ K*width := by
    rw [hid,abs_div,abs_of_pos hw]
    apply (div_le_iff₀ hw).mpr
    convert hneighbor using 1
    ring
  have htri := abs_add_le ((avg (center+width)-avg center)/width-face) (face-f' center)
  have heq : (avg (center+width)-avg center)/width-face+(face-f' center) =
      (avg (center+width)-avg center)/width-f' center := by ring
  rw [heq] at htri
  change |(avg (center+width)-avg center)/width-f' center| ≤ _
  change |face-f' center| ≤ K*(width/2) at hfaces
  linarith

theorem trueVectorAverage_slopes_tendsto
    {ι : Type*} {L : Filter ι} {m : ℕ}
    (f f' : ℝ → Fin m → ℝ) (K : Fin m → ℝ) (center : ℝ) (width : ι → ℝ)
    (hK : ∀ p, 0 ≤ K p)
    (hf : ∀ p x, HasDerivAt (fun y => f y p) (f' x p) x)
    (hLip : ∀ p x y, |f' x p-f' y p| ≤ K p*|x-y|)
    (hw : Tendsto width L (𝓝[>] 0)) :
    let avg := fun k c => oneDimensionalCellAverage f (c-width k/2) (c+width k/2)
    Tendsto (fun k => (width k)⁻¹ • (avg k center-avg k (center-width k))) L (𝓝 (f' center)) ∧
    Tendsto (fun k => (width k)⁻¹ • (avg k (center+width k)-avg k center)) L (𝓝 (f' center)) := by
  have hcont : Continuous f := continuous_pi (fun p =>
    continuous_iff_continuousAt.mpr (fun x => (hf p x).continuousAt))
  have hpos : ∀ᶠ k in L, 0 < width k := hw.eventually self_mem_nhdsWithin
  have hzero : Tendsto width L (𝓝 0) := hw.mono_right nhdsWithin_le_nhds
  constructor
  · apply tendsto_pi_nhds.2
    intro p
    apply tendsto_iff_norm_sub_tendsto_zero.2
    apply squeeze_zero' (Eventually.of_forall (fun _ => norm_nonneg _))
    · filter_upwards [hpos] with k hk
      have h := trueCellAverage_backwardSlope_error_le
        (fun x => f x p) (fun x => f' x p) (K p) center (width k) (hK p) hk (hf p) (hLip p)
      simp only [Pi.smul_apply,Pi.sub_apply,smul_eq_mul,Real.norm_eq_abs]
      simp_rw [oneDimensionalCellAverage_apply _ _ _ (hcont.intervalIntegrable _ _) p]
      simpa only [div_eq_mul_inv,mul_comm] using h
    · simpa using hzero.mul (tendsto_const_nhds (x := (2:ℝ)⁻¹ * (K p * 3)))
  · apply tendsto_pi_nhds.2
    intro p
    apply tendsto_iff_norm_sub_tendsto_zero.2
    apply squeeze_zero' (Eventually.of_forall (fun _ => norm_nonneg _))
    · filter_upwards [hpos] with k hk
      have h := trueCellAverage_forwardSlope_error_le
        (fun x => f x p) (fun x => f' x p) (K p) center (width k) (hK p) hk (hf p) (hLip p)
      simp only [Pi.smul_apply,Pi.sub_apply,smul_eq_mul,Real.norm_eq_abs]
      simp_rw [oneDimensionalCellAverage_apply _ _ _ (hcont.intervalIntegrable _ _) p]
      simpa only [div_eq_mul_inv,mul_comm] using h
    · simpa using hzero.mul (tendsto_const_nhds (x := (2:ℝ)⁻¹ * (K p * 3)))

theorem trueVectorAverage_moving_center_tendsto
    {ι : Type*} {L : Filter ι} {m : ℕ}
    (f : ℝ → Fin m → ℝ) (M : Fin m → ℝ) (center : ℝ) (width offset : ι → ℝ)
    (hM : ∀ p, 0 ≤ M p) (hf : Continuous f)
    (hLip : ∀ p x y, |f x p-f y p| ≤ M p*|x-y|)
    (hw : Tendsto width L (𝓝[>] 0)) (ho : Tendsto offset L (𝓝 0)) :
    Tendsto (fun k => oneDimensionalCellAverage f
      (center+offset k-width k/2) (center+offset k+width k/2)) L (𝓝 (f center)) := by
  have hpos : ∀ᶠ k in L, 0 < width k := hw.eventually self_mem_nhdsWithin
  have hzero : Tendsto width L (𝓝 0) := hw.mono_right nhdsWithin_le_nhds
  apply tendsto_pi_nhds.2
  intro p
  let a := fun k => oneDimensionalCellAverage f
    (center+offset k-width k/2) (center+offset k+width k/2) p
  have hc : Continuous (fun x => f x p) := (continuous_apply p).comp hf
  have hpoint : Tendsto (fun k => f (center+offset k) p) L (𝓝 (f center p)) := by
    have hs : Tendsto (fun k => center+offset k) L (𝓝 center) := by
      simpa using (tendsto_const_nhds (x := center)).add ho
    exact hc.continuousAt.tendsto.comp hs
  have herr : Tendsto (fun k => a k-f (center+offset k) p) L (𝓝 0) := by
    apply tendsto_iff_norm_sub_tendsto_zero.2
    simp only [sub_zero]
    apply squeeze_zero' (g := fun k => M p*(width k/2)) (Eventually.of_forall (fun _ => norm_nonneg _))
    · filter_upwards [hpos] with k hk
      have h := oneDimensionalCellAverage_sub_center_le_of_lipschitz
        (fun x => f x p) (M p) (center+offset k) (width k) (hM p) hk hc (hLip p)
      dsimp only [a]
      simp only [oneDimensionalCellAverage_apply _ _ _ (hf.intervalIntegrable _ _) p]
      simpa only [Real.norm_eq_abs] using h
    · simpa using
        (tendsto_const_nhds (x := M p)).mul (hzero.div_const 2)
  simpa only [zero_add,sub_add_cancel] using herr.add hpoint

end NumStability
