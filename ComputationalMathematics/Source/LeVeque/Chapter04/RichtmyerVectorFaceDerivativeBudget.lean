/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorFaceDerivative

/-!
# Jacobian error budget for a vector Richtmyer face derivative

This norm estimate separates the predictor state error, predictor
gradient error, and physical midpoint quadrature error. It is valid
for a coupled vector flux with a Lipschitz Jacobian.
-/

namespace NumStability

theorem leveque04_richtmyer_vectorFaceDerivative_errorBudget
    {m : ℕ}
    (jacobian : (Fin m → ℝ) → (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (predictor predictorSlope halfState halfSlope exactSlope : Fin m → ℝ)
    (width L A B M N C : ℝ)
    (hL : 0 ≤ L) (hA : 0 ≤ A) (hN : 0 ≤ N)
    (hstate : ‖predictor - halfState‖ ≤ A * width ^ 2)
    (hslope : ‖predictorSlope - halfSlope‖ ≤ B * width ^ 2)
    (hpredSlope : ‖predictorSlope‖ ≤ M)
    (hhalfJacobian : ‖jacobian halfState‖ ≤ N)
    (hjacobianLip :
      ‖jacobian predictor - jacobian halfState‖ ≤
        L * ‖predictor - halfState‖)
    (hmidpoint :
      ‖jacobian halfState halfSlope - exactSlope‖ ≤
        C * width ^ 2) :
    ‖jacobian predictor predictorSlope - exactSlope‖ ≤
      (L * A * M + N * B + C) * width ^ 2 := by
  have hJ : ‖jacobian predictor - jacobian halfState‖ ≤
      L * (A * width ^ 2) :=
    hjacobianLip.trans (mul_le_mul_of_nonneg_left hstate hL)
  have hfirst :
      ‖(jacobian predictor - jacobian halfState) predictorSlope‖ ≤
        L * A * M * width ^ 2 := by
    calc
      _ ≤ ‖jacobian predictor - jacobian halfState‖ *
          ‖predictorSlope‖ :=
        (jacobian predictor - jacobian halfState).le_opNorm predictorSlope
      _ ≤ (L * (A * width ^ 2)) * ‖predictorSlope‖ :=
        mul_le_mul_of_nonneg_right hJ (norm_nonneg _)
      _ ≤ (L * (A * width ^ 2)) * M :=
        mul_le_mul_of_nonneg_left hpredSlope (by positivity)
      _ = _ := by ring
  have hsecond :
      ‖jacobian halfState (predictorSlope - halfSlope)‖ ≤
        N * B * width ^ 2 := by
    calc
      _ ≤ ‖jacobian halfState‖ * ‖predictorSlope - halfSlope‖ :=
        (jacobian halfState).le_opNorm _
      _ ≤ N * ‖predictorSlope - halfSlope‖ :=
        mul_le_mul_of_nonneg_right hhalfJacobian (norm_nonneg _)
      _ ≤ N * (B * width ^ 2) :=
        mul_le_mul_of_nonneg_left hslope hN
      _ = _ := by ring
  have hid : jacobian predictor predictorSlope - exactSlope =
      (jacobian predictor - jacobian halfState) predictorSlope +
        jacobian halfState (predictorSlope - halfSlope) +
          (jacobian halfState halfSlope - exactSlope) := by
    simp only [ContinuousLinearMap.sub_apply, map_sub]
    abel
  rw [hid]
  calc
    _ ≤ ‖(jacobian predictor - jacobian halfState) predictorSlope‖ +
        ‖jacobian halfState (predictorSlope - halfSlope)‖ +
        ‖jacobian halfState halfSlope - exactSlope‖ := by
          exact (norm_add_le _ _).trans
            (add_le_add (norm_add_le _ _) (le_refl _))
    _ ≤ L * A * M * width ^ 2 + N * B * width ^ 2 +
          C * width ^ 2 :=
      add_le_add (add_le_add hfirst hsecond) hmidpoint
    _ = (L * A * M + N * B + C) * width ^ 2 := by ring

/-- The abstract Jacobian budget applies to the derivative formula for
the actual vector predictor on neighboring exact cell averages. -/
theorem leveque04_richtmyer_vectorExactAverageFaceDerivative_error
    {m : ℕ} (profile : ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (jacobian : (Fin m → ℝ) → (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (halfState halfSlope exactSlope : ℝ → Fin m → ℝ)
    (face timeStep width L A B M N C : ℝ)
    (hL : 0 ≤ L) (hA : 0 ≤ A) (hN : 0 ≤ N)
    (hvalue :
      ‖leveque04_richtmyerPredictor timeStep width flux
          (oneDimensionalCellAverage profile (face - width) face)
          (oneDimensionalCellAverage profile face (face + width)) -
        halfState face‖ ≤ A * width ^ 2)
    (hgradient :
      ‖(1 / 2 : ℝ) •
          (width⁻¹ • (profile face - profile (face - width)) +
            width⁻¹ • (profile (face + width) - profile face)) -
          (timeStep / (2 * width)) •
            (jacobian (oneDimensionalCellAverage profile face (face + width))
                (width⁻¹ • (profile (face + width) - profile face)) -
              jacobian (oneDimensionalCellAverage profile (face - width) face)
                (width⁻¹ • (profile face - profile (face - width)))) -
        halfSlope face‖ ≤ B * width ^ 2)
    (hpredSlope :
      ‖(1 / 2 : ℝ) •
          (width⁻¹ • (profile face - profile (face - width)) +
            width⁻¹ • (profile (face + width) - profile face)) -
          (timeStep / (2 * width)) •
            (jacobian (oneDimensionalCellAverage profile face (face + width))
                (width⁻¹ • (profile (face + width) - profile face)) -
              jacobian (oneDimensionalCellAverage profile (face - width) face)
                (width⁻¹ • (profile face - profile (face - width))))‖ ≤ M)
    (hhalfJacobian : ‖jacobian (halfState face)‖ ≤ N)
    (hjacobianLip :
      ‖jacobian
          (leveque04_richtmyerPredictor timeStep width flux
            (oneDimensionalCellAverage profile (face - width) face)
            (oneDimensionalCellAverage profile face (face + width))) -
        jacobian (halfState face)‖ ≤
        L * ‖leveque04_richtmyerPredictor timeStep width flux
          (oneDimensionalCellAverage profile (face - width) face)
          (oneDimensionalCellAverage profile face (face + width)) -
          halfState face‖)
    (hmidpoint :
      ‖jacobian (halfState face) (halfSlope face) - exactSlope face‖ ≤
        C * width ^ 2) :
    let left := oneDimensionalCellAverage profile (face - width) face
    let right := oneDimensionalCellAverage profile face (face + width)
    let leftSlope := width⁻¹ • (profile face - profile (face - width))
    let rightSlope := width⁻¹ • (profile (face + width) - profile face)
    let predicted := leveque04_richtmyerPredictor timeStep width flux left right
    let predictedSlope := (1 / 2 : ℝ) • (leftSlope + rightSlope) -
      (timeStep / (2 * width)) •
        (jacobian right rightSlope - jacobian left leftSlope)
    ‖jacobian predicted predictedSlope - exactSlope face‖ ≤
      (L * A * M + N * B + C) * width ^ 2 := by
  dsimp only
  exact leveque04_richtmyer_vectorFaceDerivative_errorBudget
    jacobian
    (leveque04_richtmyerPredictor timeStep width flux
      (oneDimensionalCellAverage profile (face - width) face)
      (oneDimensionalCellAverage profile face (face + width)))
    ((1 / 2 : ℝ) •
      (width⁻¹ • (profile face - profile (face - width)) +
        width⁻¹ • (profile (face + width) - profile face)) -
      (timeStep / (2 * width)) •
        (jacobian (oneDimensionalCellAverage profile face (face + width))
            (width⁻¹ • (profile (face + width) - profile face)) -
          jacobian (oneDimensionalCellAverage profile (face - width) face)
            (width⁻¹ • (profile face - profile (face - width)))))
    (halfState face) (halfSlope face) (exactSlope face)
    width L A B M N C hL hA hN
    hvalue hgradient hpredSlope hhalfJacobian hjacobianLip hmidpoint

end NumStability
