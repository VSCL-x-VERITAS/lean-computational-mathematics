/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerFaceDerivativeBudget
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerFluxDerivativeMidpoint
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerSmoothExactPredictor
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerExactPredictorGradient

/-!
# Richtmyer numerical face-flux derivative error

The checked value and spatial-gradient errors of the actual
exact-average predictor are transferred through the physical flux
derivative. The remaining physical time average is controlled by the
second-order time midpoint estimate.
-/

namespace NumStability

/-- Quadratic predictor value and gradient errors give a quadratic
defect for the actual Richtmyer numerical face-flux derivative against
the spatial derivative of the time-averaged physical face flux. -/
theorem leveque04_richtmyer_faceDerivative_error_of_predictorData
    (flux' physicalSlopeTime : ℝ → ℝ)
    (predictor predictorSlope halfState halfSlope : ℝ)
    (timeStep width L A B M N C : ℝ)
    (htime : 0 < timeStep) (hmesh : timeStep ≤ width)
    (hL : 0 ≤ L) (hA : 0 ≤ A) (hN : 0 ≤ N)
    (hvalue : |predictor - halfState| ≤ A * width ^ 2)
    (hgradient : |predictorSlope - halfSlope| ≤ B * width ^ 2)
    (hpredSlopeBound : |predictorSlope| ≤ M)
    (hhalfFluxBound : |flux' halfState| ≤ N)
    (hfluxDerivLip :
      |flux' predictor - flux' halfState| ≤
        L * |predictor - halfState|)
    (hphysicalHalf :
      physicalSlopeTime (timeStep / 2) =
        flux' halfState * halfSlope)
    (hphysicalSmooth : ContDiffOn ℝ 2 physicalSlopeTime
      (Set.Icc 0 timeStep))
    (hphysicalCurvature : ∀ τ,
      |iteratedDerivWithin 2 physicalSlopeTime
        (Set.Icc 0 timeStep) τ| ≤ C) :
    |flux' predictor * predictorSlope -
      oneDimensionalCellAverage physicalSlopeTime 0 timeStep| ≤
      (L * A * M + N * B + C / 8) * width ^ 2 := by
  have hmid := leveque04_richtmyer_fluxDerivative_timeMidpointError
    physicalSlopeTime timeStep width C htime hmesh
    hphysicalSmooth hphysicalCurvature
  rw [hphysicalHalf] at hmid
  exact leveque04_richtmyer_faceDerivative_errorBudget
    flux' predictor predictorSlope halfState halfSlope
    (oneDimensionalCellAverage physicalSlopeTime 0 timeStep)
    width L A B M N (C / 8) hL hA hN
    hvalue hgradient hpredSlopeBound hhalfFluxBound hfluxDerivLip hmid

/-- A bound on the physical half-time state gradient also bounds the
numerical predictor gradient when the mesh width is at most one. -/
theorem leveque04_richtmyer_faceDerivative_error_of_halfSlopeBound
    (flux' physicalSlopeTime : ℝ → ℝ)
    (predictor predictorSlope halfState halfSlope : ℝ)
    (timeStep width L A B M N C : ℝ)
    (htime : 0 < timeStep) (hmesh : timeStep ≤ width)
    (hwidthOne : width ≤ 1)
    (hL : 0 ≤ L) (hA : 0 ≤ A) (hB : 0 ≤ B) (hN : 0 ≤ N)
    (hvalue : |predictor - halfState| ≤ A * width ^ 2)
    (hgradient : |predictorSlope - halfSlope| ≤ B * width ^ 2)
    (hhalfSlopeBound : |halfSlope| ≤ M)
    (hhalfFluxBound : |flux' halfState| ≤ N)
    (hfluxDerivLip :
      |flux' predictor - flux' halfState| ≤
        L * |predictor - halfState|)
    (hphysicalHalf :
      physicalSlopeTime (timeStep / 2) =
        flux' halfState * halfSlope)
    (hphysicalSmooth : ContDiffOn ℝ 2 physicalSlopeTime
      (Set.Icc 0 timeStep))
    (hphysicalCurvature : ∀ τ,
      |iteratedDerivWithin 2 physicalSlopeTime
        (Set.Icc 0 timeStep) τ| ≤ C) :
    |flux' predictor * predictorSlope -
      oneDimensionalCellAverage physicalSlopeTime 0 timeStep| ≤
      (L * A * (M + B) + N * B + C / 8) * width ^ 2 := by
  have hsq : width ^ 2 ≤ 1 := by
    nlinarith [sq_nonneg (width - 1)]
  have herrorBound : B * width ^ 2 ≤ B := by
    simpa only [mul_one] using mul_le_mul_of_nonneg_left hsq hB
  have hslopeBound : |predictorSlope| ≤ M + B := by
    have htri : |predictorSlope| ≤
        |predictorSlope - halfSlope| + |halfSlope| := by
      convert abs_add_le (predictorSlope - halfSlope) halfSlope using 1 <;> ring
    linarith
  exact leveque04_richtmyer_faceDerivative_error_of_predictorData
    flux' physicalSlopeTime predictor predictorSlope halfState halfSlope
    timeStep width L A B (M + B) N C
    htime hmesh hL hA hN hvalue hgradient hslopeBound
    hhalfFluxBound hfluxDerivLip hphysicalHalf
    hphysicalSmooth hphysicalCurvature

end NumStability
