/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerExactAverageFluxGradient
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerPredictorDerivativeState
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerPDEHalfTimeTaylor

/-!
# Spatial gradient of the Richtmyer half-time predictor

The centered exact-average state slope and flux-gradient quotient in
the derivative of equation (4.23) approximate the spatial derivative
of the physical half-time state under a differentiated conservation PDE.
-/

namespace NumStability

/-- The exact-average scalar Richtmyer predictor gradient is
quadratically close to the physical half-time state gradient, given
the checked spatial estimates and a smooth differentiated PDE trace. -/
theorem leveque04_richtmyer_predictorGradient_error
    (centeredSlope fluxGradient initialSlope physicalSecond : ℝ)
    (halfSlope timeSlope : ℝ → ℝ)
    (timeStep width S F T : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hmesh : timeStep ≤ width)
    (hF : 0 ≤ F) (hT : 0 ≤ T)
    (hstate : |centeredSlope - initialSlope| ≤ S * width ^ 2)
    (hflux : |fluxGradient - physicalSecond| ≤ F * width)
    (htraceDeriv : ∀ τ,
      HasDerivAt halfSlope (timeSlope τ) τ)
    (htraceLip : ∀ τ σ,
      |timeSlope τ - timeSlope σ| ≤ T * |τ - σ|)
    (hinitial : initialSlope = halfSlope 0)
    (hpde : timeSlope 0 + physicalSecond = 0) :
    |(centeredSlope - timeStep / 2 * fluxGradient) -
      halfSlope (timeStep / 2)| ≤
        (S + F / 2 + T / 4) * width ^ 2 := by
  have htaylor := leveque04_richtmyer_pdeFace_halfTimeTaylor
    (fun _ τ => halfSlope τ) timeSlope 0 physicalSecond timeStep T
    hT htraceDeriv htraceLip hpde
  have htaylor' :
      |halfSlope (timeStep / 2) -
        (halfSlope 0 - timeStep / 2 * physicalSecond)| ≤
          (T / 4) * timeStep ^ 2 := by
    simpa only using htaylor
  rw [← hinitial] at htaylor'
  have hfluxTerm :
      |timeStep / 2 * (fluxGradient - physicalSecond)| ≤
        (F / 2) * width ^ 2 := by
    rw [abs_mul, abs_of_pos (by positivity : 0 < timeStep / 2)]
    have hfirst : timeStep / 2 * |fluxGradient - physicalSecond| ≤
        timeStep / 2 * (F * width) :=
      mul_le_mul_of_nonneg_left hflux (by positivity)
    have hsecond : timeStep / 2 * (F * width) ≤
        F / 2 * width ^ 2 := by
      have hprod : timeStep * (F * width) ≤
          width * (F * width) :=
        mul_le_mul_of_nonneg_right hmesh
          (mul_nonneg hF hwidth.le)
      nlinarith
    exact hfirst.trans hsecond
  have htimeSq : timeStep ^ 2 ≤ width ^ 2 := by gcongr
  have htimeTerm :
      |initialSlope - timeStep / 2 * physicalSecond -
        halfSlope (timeStep / 2)| ≤
          (T / 4) * width ^ 2 := by
    calc
      _ = |halfSlope (timeStep / 2) -
          (initialSlope - timeStep / 2 * physicalSecond)| := by
            rw [abs_sub_comm]
      _ ≤ (T / 4) * timeStep ^ 2 := htaylor'
      _ ≤ (T / 4) * width ^ 2 :=
        mul_le_mul_of_nonneg_left htimeSq (by positivity)
  have hid : (centeredSlope - timeStep / 2 * fluxGradient) -
      halfSlope (timeStep / 2) =
      (centeredSlope - initialSlope) -
        timeStep / 2 * (fluxGradient - physicalSecond) +
        (initialSlope - timeStep / 2 * physicalSecond -
          halfSlope (timeStep / 2)) := by ring
  rw [hid]
  calc
    |(centeredSlope - initialSlope) -
        timeStep / 2 * (fluxGradient - physicalSecond) +
        (initialSlope - timeStep / 2 * physicalSecond -
          halfSlope (timeStep / 2))| ≤
      |centeredSlope - initialSlope| +
        |timeStep / 2 * (fluxGradient - physicalSecond)| +
        |initialSlope - timeStep / 2 * physicalSecond -
          halfSlope (timeStep / 2)| := by
        have h1 := abs_add_le
          ((centeredSlope - initialSlope) -
            timeStep / 2 * (fluxGradient - physicalSecond))
          (initialSlope - timeStep / 2 * physicalSecond -
            halfSlope (timeStep / 2))
        have h2 :
            |(centeredSlope - initialSlope) -
                timeStep / 2 * (fluxGradient - physicalSecond)| ≤
              |centeredSlope - initialSlope| +
                |timeStep / 2 * (fluxGradient - physicalSecond)| := by
          simpa only [sub_eq_add_neg, abs_neg] using
            (abs_add_le (centeredSlope - initialSlope)
              (-(timeStep / 2 * (fluxGradient - physicalSecond))))
        linarith
    _ ≤ S * width ^ 2 + F / 2 * width ^ 2 +
          T / 4 * width ^ 2 :=
      add_le_add (add_le_add hstate hfluxTerm) htimeTerm
    _ = (S + F / 2 + T / 4) * width ^ 2 := by ring

end NumStability
