/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorMidpointError

/-!
# Vector Richtmyer face derivative with midpoint quadrature

The vector midpoint theorem discharges the physical time-average
premise of the Jacobian error budget. The remaining inputs are
predictor state and gradient estimates.
-/

namespace NumStability

open MeasureTheory Set

theorem leveque04_richtmyer_vectorFaceDerivative_error_of_midpoint
    {m : ℕ}
    (jacobian : (Fin m → ℝ) → (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (predictor predictorSlope halfState halfSlope : Fin m → ℝ)
    (physicalSlopeTime : ℝ → Fin m → ℝ)
    (timeStep width L A B M N C : ℝ)
    (htime : 0 < timeStep) (hmesh : timeStep ≤ width)
    (hL : 0 ≤ L) (hA : 0 ≤ A) (hN : 0 ≤ N) (hC : 0 ≤ C)
    (hstate : ‖predictor - halfState‖ ≤ A * width ^ 2)
    (hslope : ‖predictorSlope - halfSlope‖ ≤ B * width ^ 2)
    (hpredSlope : ‖predictorSlope‖ ≤ M)
    (hhalfJacobian : ‖jacobian halfState‖ ≤ N)
    (hjacobianLip :
      ‖jacobian predictor - jacobian halfState‖ ≤
        L * ‖predictor - halfState‖)
    (hphysicalHalf :
      physicalSlopeTime (timeStep / 2) =
        jacobian halfState halfSlope)
    (hphysicalCont : Continuous physicalSlopeTime)
    (hphysicalSmooth : ∀ p, ContDiffOn ℝ 2
      (fun τ => physicalSlopeTime τ p) (Icc 0 timeStep))
    (hphysicalCurvature : ∀ p τ,
      |iteratedDerivWithin 2 (fun σ => physicalSlopeTime σ p)
        (Icc 0 timeStep) τ| ≤ C) :
    ‖jacobian predictor predictorSlope -
        oneDimensionalCellAverage physicalSlopeTime 0 timeStep‖ ≤
      (L * A * M + N * B + C / 8) * width ^ 2 := by
  have hmid := leveque04_richtmyer_vectorMidpointTimeAverage_meshError
    physicalSlopeTime timeStep width C
    htime hmesh hC hphysicalCont hphysicalSmooth hphysicalCurvature
  rw [hphysicalHalf] at hmid
  exact leveque04_richtmyer_vectorFaceDerivative_errorBudget
    jacobian predictor predictorSlope halfState halfSlope
    (oneDimensionalCellAverage physicalSlopeTime 0 timeStep)
    width L A B M N (C / 8)
    hL hA hN hstate hslope hpredSlope hhalfJacobian
    hjacobianLip hmid

/-- On meshes of width at most one, a physical half-time gradient bound
and the quadratic gradient error bound the numerical predictor gradient. -/
theorem leveque04_richtmyer_vectorFaceDerivative_error_of_halfSlopeBound
    {m : ℕ}
    (jacobian : (Fin m → ℝ) → (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (predictor predictorSlope halfState halfSlope : Fin m → ℝ)
    (physicalSlopeTime : ℝ → Fin m → ℝ)
    (timeStep width L A B M N C : ℝ)
    (htime : 0 < timeStep) (hmesh : timeStep ≤ width)
    (hwidthOne : width ≤ 1)
    (hL : 0 ≤ L) (hA : 0 ≤ A) (hB : 0 ≤ B)
    (hN : 0 ≤ N) (hC : 0 ≤ C)
    (hstate : ‖predictor - halfState‖ ≤ A * width ^ 2)
    (hslope : ‖predictorSlope - halfSlope‖ ≤ B * width ^ 2)
    (hhalfSlope : ‖halfSlope‖ ≤ M)
    (hhalfJacobian : ‖jacobian halfState‖ ≤ N)
    (hjacobianLip :
      ‖jacobian predictor - jacobian halfState‖ ≤
        L * ‖predictor - halfState‖)
    (hphysicalHalf :
      physicalSlopeTime (timeStep / 2) =
        jacobian halfState halfSlope)
    (hphysicalCont : Continuous physicalSlopeTime)
    (hphysicalSmooth : ∀ p, ContDiffOn ℝ 2
      (fun τ => physicalSlopeTime τ p) (Icc 0 timeStep))
    (hphysicalCurvature : ∀ p τ,
      |iteratedDerivWithin 2 (fun σ => physicalSlopeTime σ p)
        (Icc 0 timeStep) τ| ≤ C) :
    ‖jacobian predictor predictorSlope -
        oneDimensionalCellAverage physicalSlopeTime 0 timeStep‖ ≤
      (L * A * (M + B) + N * B + C / 8) * width ^ 2 := by
  have hsq : width ^ 2 ≤ 1 := by
    have hwidth : 0 ≤ width := le_trans (le_of_lt htime) hmesh
    nlinarith
  have herrorBound : B * width ^ 2 ≤ B := by
    simpa only [mul_one] using mul_le_mul_of_nonneg_left hsq hB
  have hpredSlope : ‖predictorSlope‖ ≤ M + B := by
    have htri : ‖predictorSlope‖ ≤
        ‖predictorSlope - halfSlope‖ + ‖halfSlope‖ := by
      simpa only [sub_add_cancel] using
        (norm_add_le (predictorSlope - halfSlope) halfSlope)
    linarith
  exact leveque04_richtmyer_vectorFaceDerivative_error_of_midpoint
    jacobian predictor predictorSlope halfState halfSlope
    physicalSlopeTime timeStep width L A B (M + B) N C
    htime hmesh hL hA hN hC hstate hslope hpredSlope
    hhalfJacobian hjacobianLip hphysicalHalf
    hphysicalCont hphysicalSmooth hphysicalCurvature

end NumStability
