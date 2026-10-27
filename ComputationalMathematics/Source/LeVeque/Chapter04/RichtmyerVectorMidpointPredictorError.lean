/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorFaceDerivativeMidpoint

/-!
# Vector Richtmyer half-time predictor error

The vector equation-(4.23) predictor has quadratic half-time state
error when centered old-state averages, the centered physical flux
slope, and the temporal Taylor expansion have their expected errors.
-/

namespace NumStability

theorem leveque04_richtmyerVector_midpointPredictorError
    {m : ℕ} (flux : (Fin m → ℝ) → Fin m → ℝ)
    (left right initialFace fluxSlope halfTimeFace : Fin m → ℝ)
    (timeStep width stateBound fluxBound timeBound : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hmesh : timeStep ≤ width)
    (hfluxBound : 0 ≤ fluxBound)
    (htimeBound : 0 ≤ timeBound)
    (hstate : ‖(1 / 2 : ℝ) • (left + right) - initialFace‖ ≤
      stateBound * width ^ 2)
    (hflux : ‖width⁻¹ • (flux right - flux left) - fluxSlope‖ ≤
      fluxBound * width)
    (htaylor : ‖halfTimeFace -
      (initialFace - (timeStep / 2) • fluxSlope)‖ ≤
        timeBound * timeStep ^ 2) :
    ‖leveque04_richtmyerPredictor timeStep width flux left right -
      halfTimeFace‖ ≤
        (stateBound + fluxBound / 2 + timeBound) * width ^ 2 := by
  let avg := (1 / 2 : ℝ) • (left + right)
  let slopeApprox := width⁻¹ • (flux right - flux left)
  let predictor := leveque04_richtmyerPredictor timeStep width flux left right
  have hcoef : timeStep / (2 * width) = timeStep / 2 * width⁻¹ := by
    field_simp
  have hid : predictor - halfTimeFace =
      (avg - initialFace) -
        (timeStep / 2) • (slopeApprox - fluxSlope) +
        (initialFace - (timeStep / 2) • fluxSlope - halfTimeFace) := by
    dsimp [predictor, avg, slopeApprox, leveque04_richtmyerPredictor]
    rw [hcoef]
    simp only [smul_sub, smul_smul]
    abel
  have hfluxTerm :
      ‖(timeStep / 2) • (slopeApprox - fluxSlope)‖ ≤
        fluxBound / 2 * width ^ 2 := by
    rw [norm_smul, Real.norm_eq_abs,
      abs_of_pos (by positivity : 0 < timeStep / 2)]
    calc
      _ ≤ (timeStep / 2) * (fluxBound * width) :=
        mul_le_mul_of_nonneg_left hflux (by positivity)
      _ ≤ (width / 2) * (fluxBound * width) := by
        gcongr
      _ = fluxBound / 2 * width ^ 2 := by ring
  have htimeTerm :
      ‖initialFace - (timeStep / 2) • fluxSlope - halfTimeFace‖ ≤
        timeBound * width ^ 2 := by
    calc
      _ = ‖halfTimeFace -
          (initialFace - (timeStep / 2) • fluxSlope)‖ := by
            rw [norm_sub_rev]
      _ ≤ timeBound * timeStep ^ 2 := htaylor
      _ ≤ timeBound * width ^ 2 := by
        gcongr
  rw [hid]
  have htriangle :
      ‖(avg - initialFace) -
        (timeStep / 2) • (slopeApprox - fluxSlope)‖ ≤
        ‖avg - initialFace‖ +
          ‖(timeStep / 2) • (slopeApprox - fluxSlope)‖ :=
    norm_sub_le _ _
  calc
    _ ≤ ‖(avg - initialFace) -
          (timeStep / 2) • (slopeApprox - fluxSlope)‖ +
        ‖initialFace - (timeStep / 2) • fluxSlope - halfTimeFace‖ :=
      norm_add_le _ _
    _ ≤ (‖avg - initialFace‖ +
        ‖(timeStep / 2) • (slopeApprox - fluxSlope)‖) +
        ‖initialFace - (timeStep / 2) • fluxSlope - halfTimeFace‖ :=
      add_le_add htriangle (le_refl _)
    _ = ‖avg - initialFace‖ +
        ‖(timeStep / 2) • (slopeApprox - fluxSlope)‖ +
        ‖initialFace - (timeStep / 2) • fluxSlope - halfTimeFace‖ := rfl
    _ ≤ stateBound * width ^ 2 + fluxBound / 2 * width ^ 2 +
          timeBound * width ^ 2 :=
      add_le_add (add_le_add hstate hfluxTerm) htimeTerm
    _ = (stateBound + fluxBound / 2 + timeBound) * width ^ 2 := by ring

end NumStability
