/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerMidpointFaceError

/-!
# Richtmyer half-time predictor error transfer

Three smooth-solution estimates control the actual equation-(4.23)
predictor: the centered old-state average, the centered physical-flux
difference, and the temporal first-order expansion at the face.
-/

namespace NumStability

/-- Quadratic spatial midpoint and flux-slope errors, together with a
quadratic half-time Taylor remainder, imply a quadratic state error for
the actual scalar Richtmyer predictor. -/
theorem leveque04_richtmyerScalar_midpointPredictorError
    (flux : ℝ → ℝ) (left right : Fin 1 → ℝ)
    (initialFace fluxSlope halfTimeFace : ℝ)
    (timeStep width stateBound fluxBound timeBound : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hmesh : timeStep ≤ width)
    (hfluxBound : 0 ≤ fluxBound)
    (htimeBound : 0 ≤ timeBound)
    (hstate : |(left 0 + right 0) / 2 - initialFace| ≤
      stateBound * width ^ 2)
    (hflux : |(flux (right 0) - flux (left 0)) / width - fluxSlope| ≤
      fluxBound * width)
    (htaylor : |halfTimeFace -
      (initialFace - timeStep / 2 * fluxSlope)| ≤
        timeBound * timeStep ^ 2) :
    |leveque04_richtmyerPredictor timeStep width
        (fun state (_ : Fin 1) => flux (state 0)) left right 0 -
      halfTimeFace| ≤
        (stateBound + fluxBound / 2 + timeBound) * width ^ 2 := by
  let avg := (left 0 + right 0) / 2
  let slopeApprox := (flux (right 0) - flux (left 0)) / width
  let predictor := leveque04_richtmyerPredictor timeStep width
    (fun state (_ : Fin 1) => flux (state 0)) left right 0
  have hidentity : predictor - halfTimeFace =
      (avg - initialFace) -
        timeStep / 2 * (slopeApprox - fluxSlope) +
        (initialFace - timeStep / 2 * fluxSlope - halfTimeFace) := by
    dsimp [predictor, avg, slopeApprox]
    rw [leveque04_equation23]
    field_simp [hwidth.ne']
    ring
  have hfluxTerm :
      |timeStep / 2 * (slopeApprox - fluxSlope)| ≤
        fluxBound / 2 * width ^ 2 := by
    rw [abs_mul, abs_of_pos (by positivity : 0 < timeStep / 2)]
    have hfirst : timeStep / 2 * |slopeApprox - fluxSlope| ≤
        timeStep / 2 * (fluxBound * width) :=
      mul_le_mul_of_nonneg_left hflux (by positivity)
    have hsecond : timeStep / 2 * (fluxBound * width) ≤
        fluxBound / 2 * width ^ 2 := by
      have hprod : timeStep * (fluxBound * width) ≤
          width * (fluxBound * width) :=
        mul_le_mul_of_nonneg_right hmesh
          (mul_nonneg hfluxBound hwidth.le)
      nlinarith
    exact hfirst.trans hsecond
  have htimeSq : timeStep ^ 2 ≤ width ^ 2 := by gcongr
  have htimeTerm :
      |initialFace - timeStep / 2 * fluxSlope - halfTimeFace| ≤
        timeBound * width ^ 2 := by
    calc
      _ = |halfTimeFace -
          (initialFace - timeStep / 2 * fluxSlope)| := by
            rw [abs_sub_comm]
      _ ≤ timeBound * timeStep ^ 2 := htaylor
      _ ≤ timeBound * width ^ 2 := by
        exact mul_le_mul_of_nonneg_left htimeSq htimeBound
  rw [hidentity]
  calc
    |(avg - initialFace) - timeStep / 2 * (slopeApprox - fluxSlope) +
        (initialFace - timeStep / 2 * fluxSlope - halfTimeFace)| ≤
      |avg - initialFace| +
        |timeStep / 2 * (slopeApprox - fluxSlope)| +
        |initialFace - timeStep / 2 * fluxSlope - halfTimeFace| := by
          have h1 := abs_add_le
            ((avg - initialFace) - timeStep / 2 * (slopeApprox - fluxSlope))
            (initialFace - timeStep / 2 * fluxSlope - halfTimeFace)
          have h2 :
              |(avg - initialFace) -
                  timeStep / 2 * (slopeApprox - fluxSlope)| ≤
                |avg - initialFace| +
                  |timeStep / 2 * (slopeApprox - fluxSlope)| := by
            simpa only [sub_eq_add_neg, abs_neg] using
              (abs_add_le (avg - initialFace)
                (-(timeStep / 2 * (slopeApprox - fluxSlope))))
          linarith
    _ ≤ stateBound * width ^ 2 +
          fluxBound / 2 * width ^ 2 +
          timeBound * width ^ 2 := by
        exact add_le_add (add_le_add hstate hfluxTerm) htimeTerm
    _ = (stateBound + fluxBound / 2 + timeBound) * width ^ 2 := by ring

/-- The three elementary predictor estimates combine with physical
time-flux midpoint quadrature to bound the actual scalar Richtmyer
numerical flux against the exact time-averaged face flux. -/
theorem leveque04_richtmyerScalar_midpointFaceError_of_predictorData
    (flux trace : ℝ → ℝ) (left right : Fin 1 → ℝ)
    (initialFace fluxSlope : ℝ)
    (timeStep width L stateBound fluxBound timeBound curvatureBound : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hmesh : timeStep ≤ width)
    (hL : 0 ≤ L) (hfluxBound : 0 ≤ fluxBound)
    (htimeBound : 0 ≤ timeBound) (hcurvatureBound : 0 ≤ curvatureBound)
    (hfluxLip : ∀ u v, |flux u - flux v| ≤ L * |u - v|)
    (hstate : |(left 0 + right 0) / 2 - initialFace| ≤
      stateBound * width ^ 2)
    (hflux : |(flux (right 0) - flux (left 0)) / width - fluxSlope| ≤
      fluxBound * width)
    (htaylor : |trace (timeStep / 2) -
      (initialFace - timeStep / 2 * fluxSlope)| ≤
        timeBound * timeStep ^ 2)
    (hsmooth : ContDiffOn ℝ 2
      (fun τ => flux (trace τ)) (Set.Icc 0 timeStep))
    (hcurvature : ∀ τ,
      |iteratedDerivWithin 2 (fun σ => flux (trace σ))
        (Set.Icc 0 timeStep) τ| ≤ curvatureBound) :
    |leveque04_richtmyerFlux timeStep width
        (fun state (_ : Fin 1) => flux (state 0)) left right 0 -
      oneDimensionalCellAverage (fun τ => flux (trace τ)) 0 timeStep| ≤
        (L * (stateBound + fluxBound / 2 + timeBound) +
          curvatureBound / 8) * width ^ 2 := by
  have hpredictor := leveque04_richtmyerScalar_midpointPredictorError
    flux left right initialFace fluxSlope (trace (timeStep / 2))
    timeStep width stateBound fluxBound timeBound
    htime hwidth hmesh hfluxBound htimeBound hstate hflux htaylor
  exact leveque04_richtmyerScalar_midpointFaceError
    flux trace left right timeStep width L
    (stateBound + fluxBound / 2 + timeBound) curvatureBound
    htime hmesh hL hcurvatureBound hfluxLip hpredictor
    hsmooth hcurvature

end NumStability
