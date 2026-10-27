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
# LogarithmicWeightedRiemann

Source-independent mathematics. Actual derivatives, integrability and displayed analytic hypotheses are retained.
-/

namespace NumStability

open Set Filter MeasureTheory Topology
open scoped BigOperators Topology NNReal

/-- The natural characteristic coordinate for positive speed x+1
transports the actual weighted spatial mass, including discontinuous profiles. -/
theorem positive_log_weighted_intervalIntegral {m : ℕ}
    (profile : ℝ → Fin (m+1) → ℝ) (a b : ℝ)
    (ha : 0 < a+1) (hb : 0 < b+1) (hab : a ≤ b)
    (hi : IntervalIntegrable profile volume (Real.log (a+1)) (Real.log (b+1))) :
    IntervalIntegrable (fun x => (x+1)⁻¹ • profile (Real.log (x+1))) volume a b ∧
    (∫ x in a..b, (x+1)⁻¹ • profile (Real.log (x+1))) =
      ∫ y in (Real.log (a+1))..(Real.log (b+1)), profile y := by
  let f := fun y : ℝ => Real.exp y-1
  let g := fun x : ℝ => (x+1)⁻¹ • profile (Real.log (x+1))
  let domain := Set.Icc (Real.log (a+1)) (Real.log (b+1))
  have hlog : Real.log (a+1) ≤ Real.log (b+1) := Real.log_le_log ha (by linarith)
  have hm : MonotoneOn f domain := by
    intro x _ y _ hxy
    exact sub_le_sub_right (Real.exp_le_exp.mpr hxy) 1
  have hd (y : ℝ) (_hy : y ∈ domain) : HasDerivWithinAt f (Real.exp y) domain y :=
    ((Real.hasDerivAt_exp y).sub_const 1).hasDerivWithinAt
  have himage : f '' domain = Set.Icc a b := by
    have h := ((Real.continuous_exp.sub continuous_const).continuousOn).image_Icc_of_monotoneOn hlog hm
    simpa only [f,domain,Real.exp_log ha,Real.exp_log hb,add_sub_cancel_right] using h
  have hcomp : (fun y => Real.exp y • g (f y)) = profile := by
    funext y
    simp only [g,f,sub_add_cancel,Real.log_exp,smul_smul,
      mul_inv_cancel₀ (Real.exp_ne_zero y),one_smul]
  have hsource : IntegrableOn profile domain :=
    (intervalIntegrable_iff_integrableOn_Icc_of_le hlog).mp hi
  have hg : IntegrableOn g (Set.Icc a b) := by
    rw [← himage]
    apply (integrableOn_image_iff_integrableOn_deriv_smul_of_monotoneOn measurableSet_Icc hd hm g).mpr
    simpa only [hcomp] using hsource
  refine ⟨(intervalIntegrable_iff_integrableOn_Icc_of_le hab).mpr hg,?_⟩
  have hint := integral_image_eq_integral_deriv_smul_of_monotoneOn measurableSet_Icc hd hm g
  rw [himage,hcomp] at hint
  rw [intervalIntegral.integral_of_le hab,← integral_Icc_eq_integral_Ioc,
    intervalIntegral.integral_of_le hlog,← integral_Icc_eq_integral_Ioc]
  exact hint

/-- The discontinuous characteristic step obeys weighted rectangle
conservation on the domain x>-1 for the original speed x+1. -/
theorem logarithmic_step_weighted_rectangle {m : ℕ}
    (L O R : Fin (m+1) → ℝ) (a b s t : ℝ)
    (ha : 0 < a+1) (hb : 0 < b+1) (hab : a ≤ b) :
    (∫ x in a..b, (x+1)⁻¹ • riemannData L O R (Real.log (x+1)-t)) -
      (∫ x in a..b, (x+1)⁻¹ • riemannData L O R (Real.log (x+1)-s)) =
      ∫ τ in s..t, riemannData L O R (Real.log (a+1)-τ) -
        riemannData L O R (Real.log (b+1)-τ) := by
  have hprofile := riemannData_intervalIntegrable L O R
  have hspace (time : ℝ) := positive_log_weighted_intervalIntegral
    (fun y => travelingWave (riemannData L O R) 1 y time) a b ha hb hab
    (travelingWave_intervalIntegrable_space _ hprofile 1 _ _ time)
  simp only [travelingWave,one_mul] at hspace
  rw [(hspace t).2,(hspace s).2]
  have hbalance := travelingWave_intervalBalance (riemannData L O R) hprofile 1
    (Real.log (a+1)) (Real.log (b+1)) s t
  have hl := travelingWave_intervalIntegrable_time _ hprofile 1 (Real.log (a+1)) s t
  have hr := travelingWave_intervalIntegrable_time _ hprofile 1 (Real.log (b+1)) s t
  simp only [travelingWave,one_mul] at hl hr
  rw [intervalIntegral.integral_sub hl hr]
  simpa only [travelingWave,one_mul,one_smul] using hbalance

/-- On x>-1 the actual backward characteristic label and logarithmic
coordinate select exactly the same discontinuous Riemann states. -/
theorem variableTransportRiemann_eq_log {State : Type*}
    (L O R : State) (x t : ℝ) (hx : 0 < x+1) :
    riemannData L O R (variableTransportLabel x t) =
      riemannData L O R (Real.log (x+1)-t) := by
  rw [(variableTransportRiemann_initial_and_front L O R).2.1 x t]
  have hneg : x-(Real.exp t-1)<0 ↔ Real.log (x+1)-t<0 := by
    rw [sub_lt_zero,sub_lt_zero,Real.log_lt_iff_lt_exp hx]
    constructor <;> intro h <;> linarith
  have hpos : 0<x-(Real.exp t-1) ↔ 0<Real.log (x+1)-t := by
    rw [sub_pos,sub_pos,Real.lt_log_iff_exp_lt hx]
    constructor <;> intro h <;> linarith
  simp only [riemannData,hneg,hpos]

/-- The actual original variable-speed characteristic step has an
integrable weighted rectangle law across its discontinuity. The weight
1/(x+1) is defined only on the explicit positive-speed domain x>-1. -/
theorem variableTransportRiemann_weighted_rectangle {m : ℕ}
    (L O R : Fin (m+1) → ℝ) (a b s t : ℝ)
    (ha : 0 < a+1) (hb : 0 < b+1) (hab : a ≤ b) :
    let q := fun x time => riemannData L O R (variableTransportLabel x time)
    IntervalIntegrable (fun x => (x+1)⁻¹ • q x t) volume a b ∧
    IntervalIntegrable (q a) volume s t ∧ IntervalIntegrable (q b) volume s t ∧
    (∫ x in a..b, (x+1)⁻¹ • q x t) - (∫ x in a..b, (x+1)⁻¹ • q x s) =
      ∫ τ in s..t, q a τ-q b τ := by
  dsimp only
  have hxpos (x : ℝ) (hx : x ∈ Set.uIcc a b) : 0 < x+1 := by
    rw [Set.uIcc_of_le hab] at hx
    linarith [hx.1]
  have hprofile := riemannData_intervalIntegrable L O R
  have hspace (time : ℝ) := positive_log_weighted_intervalIntegral
    (fun y => travelingWave (riemannData L O R) 1 y time) a b ha hb hab
    (travelingWave_intervalIntegrable_space _ hprofile 1 _ _ time)
  simp only [travelingWave,one_mul] at hspace
  have hleft := travelingWave_intervalIntegrable_time _ hprofile 1 (Real.log (a+1)) s t
  have hright := travelingWave_intervalIntegrable_time _ hprofile 1 (Real.log (b+1)) s t
  simp only [travelingWave,one_mul] at hleft hright
  have hmass (time : ℝ) :
      (∫ x in a..b, (x+1)⁻¹ • riemannData L O R (variableTransportLabel x time)) =
      ∫ x in a..b, (x+1)⁻¹ • riemannData L O R (Real.log (x+1)-time) := by
    apply intervalIntegral.integral_congr
    intro x hx
    dsimp only
    rw [variableTransportRiemann_eq_log L O R x time (hxpos x hx)]
  refine ⟨?_,?_,?_,?_⟩
  · apply (hspace t).1.congr
    intro x hx
    dsimp only
    rw [variableTransportRiemann_eq_log L O R x t
      (hxpos x (Set.uIoc_subset_uIcc hx))]
  · simpa only [variableTransportRiemann_eq_log L O R a _ ha] using hleft
  · simpa only [variableTransportRiemann_eq_log L O R b _ hb] using hright
  · rw [hmass t,hmass s]
    simpa only [variableTransportRiemann_eq_log L O R a _ ha,
      variableTransportRiemann_eq_log L O R b _ hb] using
      logarithmic_step_weighted_rectangle L O R a b s t ha hb hab

/-- The original variable-speed step, after the explicitly stated change
of density w=q/(x+1), is a canonical spatial-flux rectangle reference.
This asserts no conservative flux for the unchanged original density q. -/
theorem variableTransportRiemann_weighted_spatial_reference {m : ℕ}
    (L O R : Fin (m+1) → ℝ) (left right horizon : ℝ)
    (hleft : 0 < left+1) (hbox : left ≤ right) :
    LocalConservationLaw.SpatialRectangleReferenceOn
      (fun x t => (x+1)⁻¹ • riemannData L O R (variableTransportLabel x t))
      (fun x state => (x+1) • state) left right horizon := by
  let q := fun x t => riemannData L O R (variableTransportLabel x t)
  have hpos (x : ℝ) (hx : x ∈ Set.Icc left right) : 0 < x+1 := by linarith [hx.1]
  have hbalance (a b s t : ℝ) (ha : 0 < a+1) (hb : 0 < b+1) (hab : a ≤ b) :
      (∫ x in a..b, (x+1)⁻¹ • q x t) - (∫ x in a..b, (x+1)⁻¹ • q x s) =
      ∫ τ in s..t, q a τ-q b τ :=
    (variableTransportRiemann_weighted_rectangle L O R a b s t ha hb hab).2.2.2
  refine ⟨?_,?_,?_⟩
  · intro t _ht
    exact (variableTransportRiemann_weighted_rectangle L O R left right 0 t
      hleft (hpos right ⟨hbox,le_refl _⟩) hbox).1
  · intro x hx
    have h := (variableTransportRiemann_weighted_rectangle L O R x x 0 horizon
      (hpos x hx) (hpos x hx) (le_refl _)).2.1
    simpa only [smul_smul,mul_inv_cancel₀ (hpos x hx).ne',one_smul] using h
  · intro a ha b hb s _hs t _ht
    simp only [smul_smul,mul_inv_cancel₀ (hpos a ha).ne',
      mul_inv_cancel₀ (hpos b hb).ne',one_smul]
    by_cases hab : a ≤ b
    · exact hbalance a b s t (hpos a ha) (hpos b hb) hab
    · have h := hbalance b a s t (hpos b hb) (hpos a ha) (le_of_not_ge hab)
      rw [intervalIntegral.integral_symm b a (f := fun x => (x+1)⁻¹ • q x t),
        intervalIntegral.integral_symm b a (f := fun x => (x+1)⁻¹ • q x s)]
      have heq : (fun τ => q a τ-q b τ) = fun τ => -(q b τ-q a τ) := by
        funext τ
        abel
      rw [heq,intervalIntegral.integral_neg]
      rw [← h]
      abel

/-- The changed-density spatial conservation residual is exactly the
original nondivergence transport residual divided by the positive speed. -/
theorem positive_speed_weighted_classical_residual {m : ℕ}
    (q : ℝ → ℝ → Fin (m+1) → ℝ) (qt qx : Fin (m+1) → ℝ) (x t : ℝ)
    (hx : 0 < x+1) (hqt : HasDerivAt (q x) qt t)
    (hqx : HasDerivAt (fun ξ => q ξ t) qx x) :
    HasDerivAt (fun τ => (x+1)⁻¹ • q x τ) ((x+1)⁻¹ • qt) t ∧
    HasDerivAt (fun ξ => (ξ+1) • ((ξ+1)⁻¹ • q ξ t)) qx x ∧
    ((x+1)⁻¹ • qt+qx=0 ↔ qt+(x+1) • qx=0) := by
  have hnear : ∀ᶠ ξ in 𝓝 x, 0 < ξ+1 :=
    (continuousAt_id.add_const 1).eventually (Ioi_mem_nhds hx)
  have heq : (fun ξ => (ξ+1) • ((ξ+1)⁻¹ • q ξ t)) =ᶠ[𝓝 x] fun ξ => q ξ t := by
    filter_upwards [hnear] with ξ hξ
    rw [smul_smul,mul_inv_cancel₀ hξ.ne',one_smul]
  refine ⟨?_,hqx.congr_of_eventuallyEq heq,?_⟩
  · simpa only [Pi.smul_apply] using hqt.const_smul ((x+1)⁻¹)
  · constructor
    · intro h
      have hs := congrArg (fun v => (x+1) • v) h
      simpa only [smul_add,smul_smul,mul_inv_cancel₀ hx.ne',one_smul,smul_zero] using hs
    · intro h
      have hs := congrArg (fun v => (x+1)⁻¹ • v) h
      simpa only [smul_add,smul_smul,inv_mul_cancel₀ hx.ne',one_smul,smul_zero] using hs

end NumStability
