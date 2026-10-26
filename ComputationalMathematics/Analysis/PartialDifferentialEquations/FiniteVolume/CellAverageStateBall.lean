/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalDerivativeVariation
import ComputationalMathematics.Analysis.Calculus.LocalFirstOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSecondOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSymmetricTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.C2RectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedTimePartialRegularity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalEndpointMeanQuadrature
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage
import Mathlib.Analysis.Calculus.BumpFunction.FiniteDimension
import Mathlib.Analysis.Calculus.ContDiff.Bounds
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.FDeriv.Symmetric
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Tactic

/-!
# CellAverageStateBall

Source-independent local calculus and actual physical cell-average mathematics. Closed forward-time endpoints and explicit quantitative domains are preserved.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem intervalAverage_mem_ball_of_halfRadius
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (profile : ℝ → E) (center : E) (radius left right : ℝ)
    (hradius : 0 < radius) (hinterval : left < right)
    (hprofile : IntervalIntegrable profile volume left right)
    (hball : ∀ x ∈ Icc left right, profile x ∈ ball center (radius/2)) :
    oneDimensionalCellAverage profile left right ∈ ball center radius := by
  have he := norm_oneDimensionalCellAverage_sub_le (f:=profile) (g:=fun _=>center)
    hinterval hprofile intervalIntegrable_const (bound:=radius/2) (fun x hx => by
      rw [uIoc_of_le hinterval.le] at hx
      have h := hball x ⟨hx.1.le,hx.2⟩
      rw [mem_ball,dist_eq_norm] at h
      exact h.le)
  rw [oneDimensionalCellAverage_const center left right hinterval.ne] at he
  rw [mem_ball,dist_eq_norm]
  exact he.trans_lt (half_lt_self hradius)

theorem independent_quadratic_predictor_mem_ball
    {E : Type*} [NormedAddCommGroup E]
    (C radius : ℝ) (hC : 0 ≤ C) (hradius : 0 < radius) :
    ∃ δ : ℝ, 0 < δ ∧ δ ≤ 1 ∧
      ∀ (predicted trace center : E) (dt width : ℝ),
      0 < dt → dt ≤ δ → 0 < width → width ≤ δ →
      ‖predicted-trace‖ ≤ C*(width^2+dt^2) →
      trace ∈ ball center (radius/2) → predicted ∈ ball center radius := by
  let δ := min 1 (radius/(4*(C+1)))
  have hδ : 0 < δ := lt_min (by norm_num) (div_pos hradius (by positivity))
  have hδone : δ ≤ 1 := min_le_left _ _
  have hδr : 4*(C+1)*δ ≤ radius := by
    have h := (le_div_iff₀ (show 0 < 4*(C+1) by positivity)).mp
      (show δ ≤ radius/(4*(C+1)) from min_le_right _ _)
    nlinarith
  refine ⟨δ,hδ,hδone,?_⟩
  intro predicted trace center dt width hdt hdtδ hw hwδ herr htrace
  have hdtone : dt ≤ 1 := hdtδ.trans hδone
  have hwone : width ≤ 1 := hwδ.trans hδone
  have hdtSq : dt^2 ≤ δ := by nlinarith [mul_nonneg hdt.le (sub_nonneg.mpr hdtone)]
  have hwSq : width^2 ≤ δ := by nlinarith [mul_nonneg hw.le (sub_nonneg.mpr hwone)]
  have hquadratic : C*(width^2+dt^2) ≤ radius/2 := by
    have hb := mul_le_mul_of_nonneg_left (add_le_add hwSq hdtSq) hC
    nlinarith
  rw [mem_ball,dist_eq_norm] at htrace ⊢
  have htriangle := norm_sub_le_norm_sub_add_norm_sub predicted trace center
  exact lt_of_le_of_lt (htriangle.trans (add_le_add (herr.trans hquadratic) (le_refl _)))
    (by linarith)

theorem uniform_neighboringCellAverage_mem_ball
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (profile : ℝ → E) (state : E) (anchor spatialRadius stateRadius : ℝ)
    (hspatial : 0 < spatialRadius) (hstate : 0 < stateRadius)
    (hc : ContinuousOn profile (Icc (anchor-spatialRadius) (anchor+spatialRadius)))
    (hvalues : ∀ x ∈ Icc (anchor-spatialRadius) (anchor+spatialRadius),
      profile x ∈ ball state (stateRadius/2)) :
    ∀ face width : ℝ, |face-anchor| ≤ spatialRadius/2 →
      0 < width → width ≤ spatialRadius/2 →
      oneDimensionalCellAverage profile (face-width) face ∈ ball state stateRadius ∧
      oneDimensionalCellAverage profile face (face+width) ∈ ball state stateRadius := by
  intro face width hface hwidth hsmall
  have habs := abs_le.mp hface
  have hleft : Icc (face-width) face ⊆ Icc (anchor-spatialRadius) (anchor+spatialRadius) := by
    intro x hx
    constructor
    · linarith [hx.1,habs.1]
    · exact hx.2.trans ((show face ≤ anchor+spatialRadius/2 by linarith [habs.2]).trans
        (add_le_add (le_refl anchor) (half_le_self hspatial.le)))
  have hright : Icc face (face+width) ⊆ Icc (anchor-spatialRadius) (anchor+spatialRadius) := by
    intro x hx
    constructor <;> linarith [hx.1,hx.2,habs.1,habs.2,hspatial]
  constructor
  · exact intervalAverage_mem_ball_of_halfRadius profile state stateRadius
      (face-width) face hstate (by linarith)
      ((hc.mono hleft).intervalIntegrable_of_Icc (by linarith))
      (fun x hx => hvalues x (hleft hx))
  · exact intervalAverage_mem_ball_of_halfRadius profile state stateRadius
      face (face+width) hstate (by linarith)
      ((hc.mono hright).intervalIntegrable_of_Icc (by linarith))
      (fun x hx => hvalues x (hright hx))

end NumStability
