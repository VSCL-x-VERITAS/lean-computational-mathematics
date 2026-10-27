/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerExactFaceDerivative

/-!
# Error budget for a Richtmyer face derivative

The chain-rule expression for the actual numerical face flux is
compared with the derivative of the physical time-averaged flux by
separating the predictor state, predictor derivative, and time midpoint
errors. This algebraic bound states the remaining analytic premises.
-/

namespace NumStability

/-- State and derivative errors of a predictor, together with a
physical time-flux derivative midpoint error, control the derivative
defect of the numerical flux at quadratic mesh order. -/
theorem leveque04_richtmyer_faceDerivative_errorBudget
    (flux' : ℝ → ℝ)
    (predictor predictorSlope halfState halfSlope exactSlope : ℝ)
    (width L A B M N C : ℝ)
    (hL : 0 ≤ L) (hA : 0 ≤ A) (hN : 0 ≤ N)
    (hstate : |predictor - halfState| ≤ A * width ^ 2)
    (hslope : |predictorSlope - halfSlope| ≤ B * width ^ 2)
    (hpredSlope : |predictorSlope| ≤ M)
    (hhalfFlux : |flux' halfState| ≤ N)
    (hfluxDerivLip :
      |flux' predictor - flux' halfState| ≤
        L * |predictor - halfState|)
    (hmidpoint :
      |flux' halfState * halfSlope - exactSlope| ≤
        C * width ^ 2) :
    |flux' predictor * predictorSlope - exactSlope| ≤
      (L * A * M + N * B + C) * width ^ 2 := by
  have hflux : |flux' predictor - flux' halfState| ≤
      L * (A * width ^ 2) :=
    hfluxDerivLip.trans (mul_le_mul_of_nonneg_left hstate hL)
  have hfirst :
      |(flux' predictor - flux' halfState) * predictorSlope| ≤
        L * A * M * width ^ 2 := by
    rw [abs_mul]
    calc
      _ ≤ (L * (A * width ^ 2)) * |predictorSlope| :=
        mul_le_mul_of_nonneg_right hflux (abs_nonneg _)
      _ ≤ (L * (A * width ^ 2)) * M :=
        mul_le_mul_of_nonneg_left hpredSlope (by positivity)
      _ = _ := by ring
  have hsecond :
      |flux' halfState * (predictorSlope - halfSlope)| ≤
        N * B * width ^ 2 := by
    rw [abs_mul]
    calc
      _ ≤ N * |predictorSlope - halfSlope| :=
        mul_le_mul_of_nonneg_right hhalfFlux (abs_nonneg _)
      _ ≤ N * (B * width ^ 2) :=
        mul_le_mul_of_nonneg_left hslope hN
      _ = _ := by ring
  have hid : flux' predictor * predictorSlope - exactSlope =
      (flux' predictor - flux' halfState) * predictorSlope +
        flux' halfState * (predictorSlope - halfSlope) +
        (flux' halfState * halfSlope - exactSlope) := by ring
  rw [hid]
  calc
    |(flux' predictor - flux' halfState) * predictorSlope +
        flux' halfState * (predictorSlope - halfSlope) +
        (flux' halfState * halfSlope - exactSlope)| ≤
      |(flux' predictor - flux' halfState) * predictorSlope| +
        |flux' halfState * (predictorSlope - halfSlope)| +
        |flux' halfState * halfSlope - exactSlope| := by
          exact (abs_add_le _ _).trans
            (add_le_add (abs_add_le _ _) (le_refl _))
    _ ≤ L * A * M * width ^ 2 + N * B * width ^ 2 +
          C * width ^ 2 :=
      add_le_add (add_le_add hfirst hsecond) hmidpoint
    _ = (L * A * M + N * B + C) * width ^ 2 := by ring

end NumStability
