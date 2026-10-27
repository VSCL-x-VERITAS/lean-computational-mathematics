/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalDerivativeVariation
import ComputationalMathematics.Analysis.Calculus.LocalFirstOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSecondOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSymmetricTaylor
import ComputationalMathematics.Analysis.Calculus.LocalWithinFirstOrderTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.C2RectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedTimePartialRegularity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalEndpointMeanQuadrature
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.MidpointAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorCenteredSecant
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorFaceDerivativeBudget
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorPhysicalFluxAverageDerivative
import Mathlib.Analysis.Calculus.BumpFunction.FiniteDimension
import Mathlib.Analysis.Calculus.ContDiff.Bounds
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.FDeriv.Symmetric
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Tactic

/-!
# RichtmyerForwardPredictorGradient

Source correspondence for LeVeque section4.7, printed72/PDF94. Smooth formal local accuracy is separate from accumulated global accuracy and behavior at discontinuities.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem leveque04_richtmyer_fixedRatio_forward_predictorGradient_error
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (centeredSlope fluxGradient initialSlope physicalSecond : E)
    (halfSlope timeSlope : ℝ → E)
    (ratio timeStep width S F T : ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hstep : timeStep = ratio * width)
    (hT : 0 ≤ T)
    (hstate : ‖centeredSlope - initialSlope‖ ≤ S * width ^ 2)
    (hflux : ‖fluxGradient - physicalSecond‖ ≤ F * width)
    (htraceDeriv : ∀ τ ∈ Set.uIcc 0 (timeStep / 2), HasDerivWithinAt halfSlope (timeSlope τ) (Set.uIcc 0 (timeStep / 2)) τ)
    (htraceLip : ∀ τ ∈ Set.uIcc 0 (timeStep / 2),
      ‖timeSlope τ - timeSlope 0‖ ≤ T * |τ|)
    (hinitial : initialSlope = halfSlope 0)
    (hpde : timeSlope 0 + physicalSecond = 0) :
    ‖(centeredSlope - (timeStep / 2) • fluxGradient) -
        halfSlope (timeStep / 2)‖ ≤
          (S + ratio * F / 2 + T * ratio ^ 2 / 4) * width ^ 2 := by
  have htime : 0 < timeStep := by rw [hstep]; positivity
  have hzero : timeSlope 0 = -physicalSecond := eq_neg_of_add_eq_zero_left hpde
  have htaylor0 := norm_firstOrderTaylorError_le_of_local_within_deriv_variation
    halfSlope timeSlope T 0 (timeStep / 2) hT htraceDeriv
    (by simpa only [sub_zero] using htraceLip)
  have htaylor : ‖halfSlope (timeStep / 2) -
      (halfSlope 0 - (timeStep / 2) • physicalSecond)‖ ≤
        (T / 4) * timeStep ^ 2 := by
    convert htaylor0 using 1 <;> simp [hzero, sub_eq_add_neg]
    ring
  rw [← hinitial] at htaylor
  have hfluxTerm :
      ‖(timeStep / 2) • (fluxGradient - physicalSecond)‖ ≤
        (ratio * F / 2) * width ^ 2 := by
    rw [norm_smul, Real.norm_eq_abs,
      abs_of_pos (by positivity : 0 < timeStep / 2)]
    calc
      _ ≤ (timeStep / 2) * (F * width) :=
        mul_le_mul_of_nonneg_left hflux (by positivity)
      _ = (ratio * F / 2) * width ^ 2 := by rw [hstep]; ring
  have htimeTerm :
      ‖initialSlope - (timeStep / 2) • physicalSecond -
          halfSlope (timeStep / 2)‖ ≤
        (T * ratio ^ 2 / 4) * width ^ 2 := by
    calc
      _ = ‖halfSlope (timeStep / 2) -
          (initialSlope - (timeStep / 2) • physicalSecond)‖ := by
            rw [norm_sub_rev]
      _ ≤ (T / 4) * timeStep ^ 2 := htaylor
      _ = (T * ratio ^ 2 / 4) * width ^ 2 := by rw [hstep]; ring
  have hid : (centeredSlope - (timeStep / 2) • fluxGradient) -
      halfSlope (timeStep / 2) =
      (centeredSlope - initialSlope) -
        (timeStep / 2) • (fluxGradient - physicalSecond) +
        (initialSlope - (timeStep / 2) • physicalSecond -
          halfSlope (timeStep / 2)) := by
    simp only [smul_sub]
    abel
  rw [hid]
  have htriangle :
      ‖(centeredSlope - initialSlope) -
        (timeStep / 2) • (fluxGradient - physicalSecond)‖ ≤
        ‖centeredSlope - initialSlope‖ +
          ‖(timeStep / 2) • (fluxGradient - physicalSecond)‖ :=
    norm_sub_le _ _
  calc
    _ ≤ ‖(centeredSlope - initialSlope) -
          (timeStep / 2) • (fluxGradient - physicalSecond)‖ +
        ‖initialSlope - (timeStep / 2) • physicalSecond -
          halfSlope (timeStep / 2)‖ := norm_add_le _ _
    _ ≤ (‖centeredSlope - initialSlope‖ +
          ‖(timeStep / 2) • (fluxGradient - physicalSecond)‖) +
        ‖initialSlope - (timeStep / 2) • physicalSecond -
          halfSlope (timeStep / 2)‖ :=
      add_le_add htriangle (le_refl _)
    _ ≤ S * width ^ 2 + (ratio * F / 2) * width ^ 2 +
          (T * ratio ^ 2 / 4) * width ^ 2 :=
      add_le_add (add_le_add hstate hfluxTerm) htimeTerm
    _ = (S + ratio * F / 2 + T * ratio ^ 2 / 4) * width ^ 2 := by ring

theorem leveque04_richtmyer_independent_forward_predictorGradient_error
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (centeredSlope fluxGradient initialSlope physicalSecond : E)
    (halfSlope timeSlope : ℝ → E)
    (timeStep width S F T : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hS : 0 ≤ S) (hF : 0 ≤ F) (hT : 0 ≤ T)
    (hstate : ‖centeredSlope - initialSlope‖ ≤ S * width ^ 2)
    (hflux : ‖fluxGradient - physicalSecond‖ ≤ F * width)
    (htraceDeriv : ∀ τ ∈ Set.uIcc 0 (timeStep / 2),
      HasDerivWithinAt halfSlope (timeSlope τ) (Set.uIcc 0 (timeStep / 2)) τ)
    (htraceLip : ∀ τ ∈ Set.uIcc 0 (timeStep / 2),
      ‖timeSlope τ - timeSlope 0‖ ≤ T * |τ|)
    (hinitial : initialSlope = halfSlope 0)
    (hpde : timeSlope 0 + physicalSecond = 0) :
    ‖(centeredSlope - (timeStep / 2) • fluxGradient) -
        halfSlope (timeStep / 2)‖ ≤
          (S + F / 4 + T / 4) * (width ^ 2 + timeStep ^ 2) := by
  have hratio : 0 < timeStep / width := div_pos htime hwidth
  have hstep : timeStep = (timeStep / width) * width := by field_simp
  have hbase := leveque04_richtmyer_fixedRatio_forward_predictorGradient_error
    centeredSlope fluxGradient initialSlope physicalSecond halfSlope timeSlope
    (timeStep / width) timeStep width S F T hratio hwidth hstep hT
    hstate hflux htraceDeriv htraceLip hinitial hpde
  have hidentity : (S + timeStep / width * F / 2 + T * (timeStep / width) ^ 2 / 4) * width ^ 2 =
      S * width ^ 2 + F / 2 * timeStep * width + T / 4 * timeStep ^ 2 := by
    field_simp
  rw [hidentity] at hbase
  apply hbase.trans
  have hyoung : 2 * timeStep * width ≤ width ^ 2 + timeStep ^ 2 := by
    nlinarith [sq_nonneg (timeStep - width)]
  have hcross := mul_le_mul_of_nonneg_left hyoung (show 0 ≤ F / 4 by positivity)
  have hspatial := mul_nonneg hS (sq_nonneg timeStep)
  have htemporal := mul_nonneg hT (sq_nonneg width)
  nlinarith

end NumStability
