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
# AffineExponentialRiemannMass

Source-independent mathematics. Actual derivatives, integrability and displayed analytic hypotheses are retained.
-/

namespace NumStability

open Set Filter MeasureTheory Topology
open scoped BigOperators Topology NNReal

/-- On a rectangle containing the actual curved front, the original density,
without a weight or a singular spatial domain restriction, satisfies the
integrated distributional rewriting q_t + ((x+1)q)_x = q. -/
theorem variableTransportRiemann_original_front_rectangle
    (L O R a b s t : ℝ)
    (hfront : ∀ τ ∈ uIcc s t, a < Real.exp τ-1 ∧ Real.exp τ-1 < b) :
    let q := fun x τ => riemannData L O R (variableTransportLabel x τ)
    (∀ τ ∈ uIcc s t, IntervalIntegrable (fun x => q x τ) volume a b) ∧
    IntervalIntegrable (fun τ => (a+1)*q a τ-(b+1)*q b τ) volume s t ∧
    IntervalIntegrable (fun τ => ∫ x in a..b, q x τ) volume s t ∧
    (∫ x in a..b, q x t)-(∫ x in a..b, q x s) =
      (∫ τ in s..t, (a+1)*q a τ-(b+1)*q b τ) +
      (∫ τ in s..t, ∫ x in a..b, q x τ) := by
  dsimp only
  let M := fun τ : ℝ => (Real.exp τ-1-a)*L+(b-(Real.exp τ-1))*R
  let B := (a+1)*L-(b+1)*R
  have hm (τ : ℝ) (hτ : τ ∈ uIcc s t) :
      IntervalIntegrable (fun x => riemannData L O R (variableTransportLabel x τ)) volume a b ∧
      (∫ x in a..b, riemannData L O R (variableTransportLabel x τ)) = M τ := by
    have h := riemannData_shifted_intervalIntegral L O R a (Real.exp τ-1) b
      (hfront τ hτ).1.le (hfront τ hτ).2.le
    simpa only [(variableTransportRiemann_initial_and_front L O R).2.1,
      smul_eq_mul, M] using h
  have hb (τ : ℝ) (hτ : τ ∈ uIcc s t) :
      (a+1)*riemannData L O R (variableTransportLabel a τ)-
        (b+1)*riemannData L O R (variableTransportLabel b τ) = B := by
    rw [(variableTransportRiemann_initial_and_front L O R).2.1,
      (variableTransportRiemann_initial_and_front L O R).2.1]
    simp only [riemannData,sub_neg.mpr (hfront τ hτ).1,ite_true,
      sub_pos.mpr (hfront τ hτ).2,not_lt.mpr (sub_pos.mpr (hfront τ hτ).2).le,
      ite_false,B]
  have hc : Continuous M := by dsimp only [M]; fun_prop
  have hi : IntervalIntegrable M volume s t := hc.intervalIntegrable s t
  have hconst : IntervalIntegrable (fun _τ : ℝ => B) volume s t := intervalIntegrable_const
  have hbi : IntervalIntegrable (fun τ =>
      (a+1)*riemannData L O R (variableTransportLabel a τ)-
        (b+1)*riemannData L O R (variableTransportLabel b τ)) volume s t :=
    hconst.congr (fun τ hτ => (hb τ (uIoc_subset_uIcc hτ)).symm)
  have hmi : IntervalIntegrable (fun τ =>
      ∫ x in a..b, riemannData L O R (variableTransportLabel x τ)) volume s t :=
    hi.congr (fun τ hτ => (hm τ (uIoc_subset_uIcc hτ)).2.symm)
  have hd (τ : ℝ) : HasDerivAt M (B+M τ) τ := by
    have h := (((Real.hasDerivAt_exp τ).sub_const 1).sub_const a).mul_const L
    have h' := ((hasDerivAt_const τ b).sub ((Real.hasDerivAt_exp τ).sub_const 1)).mul_const R
    convert h.add h' using 1
    dsimp only [M,B]
    ring
  refine ⟨fun τ hτ => (hm τ hτ).1,hbi,hmi,?_⟩
  rw [(hm t (right_mem_uIcc)).2,(hm s (left_mem_uIcc)).2]
  have hB : (∫ τ in s..t,
      (a+1)*riemannData L O R (variableTransportLabel a τ)-
        (b+1)*riemannData L O R (variableTransportLabel b τ)) = ∫ _τ in s..t, B :=
    intervalIntegral.integral_congr hb
  have hM : (∫ τ in s..t, ∫ x in a..b,
      riemannData L O R (variableTransportLabel x τ)) = ∫ τ in s..t, M τ :=
    intervalIntegral.integral_congr (fun τ hτ => (hm τ hτ).2)
  rw [hB,hM,← intervalIntegral.integral_add intervalIntegrable_const hi]
  exact (intervalIntegral.integral_eq_sub_of_hasDerivAt
    (fun τ _ => hd τ) (hconst.add hi)).symm

/-- The actual original Riemann density has an integrated source balance
through its curved discontinuity in this finite forward-time rectangle.
The spatial interval contains x=-1; no division or weight is used. This
statement asserts this rectangle identity, not a universal weak theory. -/
theorem variableTransportRiemann_original_forward_box_balance
    (L O R : ℝ) (s t : ℝ) (hs : s ∈ Icc (0:ℝ) 1) (ht : t ∈ Icc (0:ℝ) 1) :
    let q := fun x τ => riemannData L O R (variableTransportLabel x τ)
    (∀ τ ∈ uIcc s t, IntervalIntegrable (fun x => q x τ) volume (-2) (Real.exp 1+1)) ∧
    IntervalIntegrable (fun τ => (-2+1)*q (-2) τ-(Real.exp 1+1+1)*q (Real.exp 1+1) τ) volume s t ∧
    IntervalIntegrable (fun τ => ∫ x in (-2)..(Real.exp 1+1), q x τ) volume s t ∧
    (∫ x in (-2)..(Real.exp 1+1), q x t)-(∫ x in (-2)..(Real.exp 1+1), q x s) =
      (∫ τ in s..t, (-2+1)*q (-2) τ-(Real.exp 1+1+1)*q (Real.exp 1+1) τ) +
      (∫ τ in s..t, ∫ x in (-2)..(Real.exp 1+1), q x τ) := by
  apply variableTransportRiemann_original_front_rectangle L O R
  intro τ hτ
  have hτ' : τ ∈ Icc (0:ℝ) 1 := (uIcc_subset_Icc hs ht) hτ
  have hlo := Real.one_le_exp_iff.mpr hτ'.1
  have hhi := Real.exp_le_exp.mpr hτ'.2
  constructor <;> linarith

/-- Actual mass of a shifted step over any ordered spatial interval.
The clamped front handles both time-dependent entry and exit. -/
theorem riemannData_clamped_intervalIntegral
    (L O R a b cut : ℝ) (hab : a ≤ b) :
    (∫ x in a..b, riemannData L O R (x-cut)) =
      (min b (max a cut)-a)*L+(b-min b (max a cut))*R := by
  by_cases hca : cut ≤ a
  · rw [max_eq_left hca,min_eq_right hab]
    have heq : (∫ x in a..b, riemannData L O R (x-cut)) = ∫ _x in a..b, R := by
      apply intervalIntegral.integral_congr_ae
      filter_upwards [] with x hx
      have hx' : x ∈ Ioc a b := by simpa only [uIoc_of_le hab] using hx
      have hp : 0 < x-cut := by linarith [hx'.1]
      simp [riemannData,hp,not_lt.mpr hp.le]
    rw [heq,intervalIntegral.integral_const]
    simp
  · by_cases hbc : b ≤ cut
    · rw [max_eq_right (le_of_not_ge hca),min_eq_left hbc]
      have heq : (∫ x in a..b, riemannData L O R (x-cut)) = ∫ _x in a..b, L := by
        apply intervalIntegral.integral_congr_ae
        filter_upwards [volume.ae_ne b] with x hne hx
        have hx' : x ∈ Ioc a b := by simpa only [uIoc_of_le hab] using hx
        have hn : x-cut < 0 := by have hlt := lt_of_le_of_ne hx'.2 hne; linarith
        simp [riemannData,hn]
      rw [heq,intervalIntegral.integral_const]
      simp
    · rw [max_eq_right (le_of_not_ge hca),min_eq_right (le_of_not_ge hbc)]
      simpa only [smul_eq_mul] using
        (riemannData_shifted_intervalIntegral L O R a cut b
          (le_of_not_ge hca) (le_of_not_ge hbc)).2

noncomputable def variableTransportOriginalMass (L R a b τ : ℝ) : ℝ :=
  (min b (max a (Real.exp τ-1))-a)*L+(b-min b (max a (Real.exp τ-1)))*R

theorem variableTransportRiemann_original_mass
    (L O R a b τ : ℝ) (hab : a ≤ b) :
    IntervalIntegrable (fun x => riemannData L O R (variableTransportLabel x τ)) volume a b ∧
    (∫ x in a..b, riemannData L O R (variableTransportLabel x τ)) =
      variableTransportOriginalMass L R a b τ := by
  have hi := (riemannData_intervalIntegrable L O R
    (a-(Real.exp τ-1)) (b-(Real.exp τ-1))).comp_sub_right (Real.exp τ-1)
  refine ⟨?_,?_⟩
  · simpa only [(variableTransportRiemann_initial_and_front L O R).2.1,sub_add_cancel] using hi
  · simp only [(variableTransportRiemann_initial_and_front L O R).2.1]
    exact riemannData_clamped_intervalIntegral L O R a b (Real.exp τ-1) hab

/-- The true spatial mass is absolutely continuous on every finite time
interval, including entry/exit of the curved front. -/
theorem variableTransportOriginalMass_absolutelyContinuous
    (L R a b s t : ℝ) :
    AbsolutelyContinuousOnInterval (variableTransportOriginalMass L R a b) s t := by
  let C : ℝ≥0 := ⟨Real.exp (max s t), (Real.exp_pos _).le⟩
  have hl : LipschitzOnWith C (fun τ : ℝ => Real.exp τ-1) (uIcc s t) := by
    apply (convex_uIcc s t).lipschitzOnWith_of_nnnorm_hasDerivWithin_le
      (fun τ _ => ((Real.hasDerivAt_exp τ).sub_const 1).hasDerivWithinAt)
    intro τ hτ
    change |Real.exp τ| ≤ Real.exp (max s t)
    rw [abs_of_pos (Real.exp_pos τ)]
    exact Real.exp_le_exp.mpr hτ.2
  have hclamp : LipschitzWith 1 (fun y : ℝ => min b (max a y)) :=
    (LipschitzWith.id.const_max a).const_min b
  have hcl : AbsolutelyContinuousOnInterval
      (fun τ : ℝ => min b (max a (Real.exp τ-1))) s t := by
    exact (hclamp.comp_lipschitzOnWith hl).absolutelyContinuousOnInterval
  have hconst (k : ℝ) : AbsolutelyContinuousOnInterval (fun _τ : ℝ => k) s t :=
    (LipschitzWith.const k).lipschitzOnWith.absolutelyContinuousOnInterval
  have h1 := (hcl.sub (hconst a)).const_mul L
  have h2 := ((hconst b).sub hcl).const_mul R
  have hresult := h1.add h2
  change AbsolutelyContinuousOnInterval (fun τ => L*(min b (max a (Real.exp τ-1))-a)+R*(b-min b (max a (Real.exp τ-1)))) s t at hresult
  change AbsolutelyContinuousOnInterval (fun τ => (min b (max a (Real.exp τ-1))-a)*L+(b-min b (max a (Real.exp τ-1)))*R) s t
  simpa only [mul_comm] using hresult

/-- At all times except the two endpoint crossing times, the actual mass
derivative is the original-density boundary inflow plus the true source mass. -/
theorem variableTransportOriginalMass_actual_derivative
    (L O R a b τ : ℝ) (hab : a ≤ b)
    (hna : Real.exp τ-1 ≠ a) (hnb : Real.exp τ-1 ≠ b) :
    HasDerivAt (variableTransportOriginalMass L R a b)
      ((a+1)*riemannData L O R (variableTransportLabel a τ)-
        (b+1)*riemannData L O R (variableTransportLabel b τ)+
        variableTransportOriginalMass L R a b τ) τ := by
  let M := variableTransportOriginalMass L R a b
  have hc : Continuous (fun σ : ℝ => Real.exp σ-1) := by fun_prop
  by_cases hca : Real.exp τ-1 < a
  · have heq : M =ᶠ[𝓝 τ] fun _ => (b-a)*R := by
      filter_upwards [hc.continuousAt.eventually (Iio_mem_nhds hca)] with σ hσ
      simp only [M,variableTransportOriginalMass,max_eq_left hσ.le,min_eq_right hab,
        sub_self,zero_mul,zero_add]
    have hqa : riemannData L O R (variableTransportLabel a τ)=R := by
      rw [(variableTransportRiemann_initial_and_front L O R).2.1]
      simp [riemannData,sub_pos.mpr hca,not_lt.mpr (sub_pos.mpr hca).le]
    have hcb : Real.exp τ-1 < b := hca.trans_le hab
    have hqb : riemannData L O R (variableTransportLabel b τ)=R := by
      rw [(variableTransportRiemann_initial_and_front L O R).2.1]
      simp [riemannData,sub_pos.mpr hcb,not_lt.mpr (sub_pos.mpr hcb).le]
    have hm : M τ=(b-a)*R := by
      simp only [M,variableTransportOriginalMass,max_eq_left hca.le,min_eq_right hab,
        sub_self,zero_mul,zero_add]
    have hz : (a+1)*riemannData L O R (variableTransportLabel a τ)-
        (b+1)*riemannData L O R (variableTransportLabel b τ)+M τ=0 := by
      rw [hqa,hqb,hm];ring
    change HasDerivAt M _ τ
    rw [hz]
    exact (hasDerivAt_const τ ((b-a)*R)).congr_of_eventuallyEq heq
  · have hac : a < Real.exp τ-1 := lt_of_le_of_ne (le_of_not_gt hca) hna.symm
    by_cases hbc : b < Real.exp τ-1
    · have heq : M =ᶠ[𝓝 τ] fun _ => (b-a)*L := by
        filter_upwards [hc.continuousAt.eventually (Ioi_mem_nhds hbc)] with σ hσ
        simp only [M,variableTransportOriginalMass,max_eq_right (hab.trans hσ.le),
          min_eq_left hσ.le,sub_self,zero_mul,add_zero]
      have hqa : riemannData L O R (variableTransportLabel a τ)=L := by
        rw [(variableTransportRiemann_initial_and_front L O R).2.1]
        simp [riemannData,sub_neg.mpr hac]
      have hqb : riemannData L O R (variableTransportLabel b τ)=L := by
        rw [(variableTransportRiemann_initial_and_front L O R).2.1]
        simp [riemannData,sub_neg.mpr hbc]
      have hm : M τ=(b-a)*L := by
        simp only [M,variableTransportOriginalMass,max_eq_right hac.le,
          min_eq_left hbc.le,sub_self,zero_mul,add_zero]
      have hz : (a+1)*riemannData L O R (variableTransportLabel a τ)-
          (b+1)*riemannData L O R (variableTransportLabel b τ)+M τ=0 := by
        rw [hqa,hqb,hm];ring
      change HasDerivAt M _ τ
      rw [hz]
      exact (hasDerivAt_const τ ((b-a)*L)).congr_of_eventuallyEq heq
    · have hcb : Real.exp τ-1 < b := lt_of_le_of_ne (le_of_not_gt hbc) hnb
      have heq : M =ᶠ[𝓝 τ] fun σ => (Real.exp σ-1-a)*L+(b-(Real.exp σ-1))*R := by
        filter_upwards [hc.continuousAt.eventually (Ioi_mem_nhds hac),
          hc.continuousAt.eventually (Iio_mem_nhds hcb)] with σ hσa hσb
        simp only [M,variableTransportOriginalMass,max_eq_right hσa.le,min_eq_right hσb.le]
      have hqa : riemannData L O R (variableTransportLabel a τ)=L := by
        rw [(variableTransportRiemann_initial_and_front L O R).2.1]
        simp [riemannData,sub_neg.mpr hac]
      have hqb : riemannData L O R (variableTransportLabel b τ)=R := by
        rw [(variableTransportRiemann_initial_and_front L O R).2.1]
        simp [riemannData,sub_pos.mpr hcb,not_lt.mpr (sub_pos.mpr hcb).le]
      have hd := ((((Real.hasDerivAt_exp τ).sub_const 1).sub_const a).mul_const L).add
        (((hasDerivAt_const τ b).sub ((Real.hasDerivAt_exp τ).sub_const 1)).mul_const R)
      have hactual := hd.congr_of_eventuallyEq heq
      convert hactual using 1
      rw [hqa,hqb]
      dsimp only [M,variableTransportOriginalMass]
      rw [max_eq_right hac.le,min_eq_right hcb.le]
      ring

/-- The actual discontinuous solution of q_t+(x+1)q_x=0 satisfies its
original-density distributional rectangle balance for all ordered spatial
endpoints and arbitrary real temporal endpoints, including front entry/exit
and intervals crossing x=-1. It has the derived production q, not zero. -/
theorem variableTransportRiemann_original_rectangle
    (L O R a b s t : ℝ) (hab : a ≤ b) :
    let q := fun x τ => riemannData L O R (variableTransportLabel x τ)
    (∀ τ, IntervalIntegrable (fun x => q x τ) volume a b) ∧
    IntervalIntegrable (fun τ => (a+1)*q a τ-(b+1)*q b τ) volume s t ∧
    IntervalIntegrable (fun τ => ∫ x in a..b, q x τ) volume s t ∧
    (∫ x in a..b, q x t)-(∫ x in a..b, q x s) =
      (∫ τ in s..t, (a+1)*q a τ-(b+1)*q b τ) +
      (∫ τ in s..t, ∫ x in a..b, q x τ) := by
  dsimp only
  let M := variableTransportOriginalMass L R a b
  let B := fun τ => (a+1)*riemannData L O R (variableTransportLabel a τ)-
    (b+1)*riemannData L O R (variableTransportLabel b τ)
  have hAC : AbsolutelyContinuousOnInterval M s t :=
    variableTransportOriginalMass_absolutelyContinuous L R a b s t
  have hM : IntervalIntegrable M volume s t := hAC.continuousOn.intervalIntegrable
  have hinj : Function.Injective (fun τ : ℝ => Real.exp τ-1) := by
    intro x y h
    apply Real.exp_injective
    linarith
  have hnull (c : ℝ) : ∀ᵐ τ ∂volume, Real.exp τ-1 ≠ c := by
    simpa only [mem_preimage,mem_singleton_iff] using
      ((countable_singleton c).preimage hinj).ae_notMem volume
  have hderivAE : ∀ᵐ τ ∂volume, HasDerivAt M (B τ+M τ) τ := by
    filter_upwards [hnull a,hnull b] with τ hna hnb
    exact variableTransportOriginalMass_actual_derivative L O R a b τ hab hna hnb
  have heq : (fun τ => deriv M τ) =ᵐ[volume.restrict (uIoc s t)] (fun τ => B τ+M τ) := by
    filter_upwards [ae_restrict_of_ae hderivAE] with τ hτ
    exact hτ.deriv
  have hsum : IntervalIntegrable (fun τ => B τ+M τ) volume s t :=
    hAC.intervalIntegrable_deriv.congr_ae heq
  have hB : IntervalIntegrable B volume s t := by
    have h := hsum.sub hM
    change IntervalIntegrable (fun τ => (B τ+M τ)-M τ) volume s t at h
    simpa only [add_sub_cancel_right] using h
  have hm (τ : ℝ) :
      (∫ x in a..b, riemannData L O R (variableTransportLabel x τ))=M τ :=
    (variableTransportRiemann_original_mass L O R a b τ hab).2
  have hactualM : IntervalIntegrable (fun τ =>
      ∫ x in a..b, riemannData L O R (variableTransportLabel x τ)) volume s t :=
    hM.congr (fun τ _ => (hm τ).symm)
  refine ⟨fun τ => (variableTransportRiemann_original_mass L O R a b τ hab).1,
    hB,hactualM,?_⟩
  rw [hm t,hm s]
  have hmass : (∫ τ in s..t, ∫ x in a..b,
      riemannData L O R (variableTransportLabel x τ))=∫ τ in s..t, M τ :=
    intervalIntegral.integral_congr (fun τ _ => hm τ)
  rw [hmass]
  change M t-M s=(∫ τ in s..t, B τ)+(∫ τ in s..t, M τ)
  rw [← intervalIntegral.integral_add hB hM,← hAC.integral_deriv_eq_sub]
  exact intervalIntegral.integral_congr_ae_restrict heq

end NumStability
