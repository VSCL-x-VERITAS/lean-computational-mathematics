/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerPredictorGradientError

/-!
# Exact-average Richtmyer predictor gradient

The spatial derivative of the equation-(4.23) scalar predictor on exact
neighboring cell averages is compared directly with the physical state
gradient at half time.
-/

namespace NumStability

/-- The actual exact-average scalar Richtmyer predictor gradient has
quadratic error against the physical half-time spatial gradient. -/
theorem leveque04_richtmyer_exactAveragePredictorGradient_error
    (profile profile' profile'' flux' physicalSecond : ℝ → ℝ)
    (traceSlope traceTimeSlope : ℝ → ℝ)
    (face width timeStep L B K M N G T : ℝ)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hmesh : timeStep ≤ width)
    (hL : 0 ≤ L) (hB : 0 ≤ B) (hK : 0 ≤ K)
    (hM : 0 ≤ M) (hN : 0 ≤ N) (hG : 0 ≤ G) (hT : 0 ≤ T)
    (hleftSmooth : ContDiffOn ℝ 2 profile
      (Set.Icc (face - width) face))
    (hrightSmooth : ContDiffOn ℝ 2 profile
      (Set.Icc face (face + width)))
    (hleftCurvature : ∀ x,
      |iteratedDerivWithin 2 profile
        (Set.Icc (face - width) face) x| ≤ B)
    (hrightCurvature : ∀ x,
      |iteratedDerivWithin 2 profile
        (Set.Icc face (face + width)) x| ≤ B)
    (hprofile : ∀ x, HasDerivAt profile (profile' x) x)
    (hprofile' : ∀ x, HasDerivAt profile' (profile'' x) x)
    (hsecondLip : ∀ x y,
      |profile'' x - profile'' y| ≤ K * |x - y|)
    (hfluxDerivLip : ∀ u v,
      |flux' u - flux' v| ≤ L * |u - v|)
    (hleftSlopeBound :
      |(profile face - profile (face - width)) / width| ≤ M)
    (hrightSlopeBound :
      |(profile (face + width) - profile face) / width| ≤ M)
    (hleftFluxBound : |flux' (profile (face - width / 2))| ≤ N)
    (hrightFluxBound : |flux' (profile (face + width / 2))| ≤ N)
    (hphysicalDeriv : ∀ x,
      HasDerivAt (fun y => flux' (profile y) * profile' y)
        (physicalSecond x) x)
    (hphysicalLip : ∀ x y,
      |physicalSecond x - physicalSecond y| ≤ G * |x - y|)
    (htraceDeriv : ∀ τ,
      HasDerivAt traceSlope (traceTimeSlope τ) τ)
    (htraceLip : ∀ τ σ,
      |traceTimeSlope τ - traceTimeSlope σ| ≤ T * |τ - σ|)
    (hinitial : traceSlope 0 = profile' face)
    (hpde : traceTimeSlope 0 + physicalSecond face = 0) :
    |((profile face - profile (face - width)) / width +
        (profile (face + width) - profile face) / width) / 2 -
      timeStep / 2 *
        ((flux' (oneDimensionalCellAverage profile face (face + width)) *
            ((profile (face + width) - profile face) / width) -
          flux' (oneDimensionalCellAverage profile (face - width) face) *
            ((profile face - profile (face - width)) / width)) / width) -
      traceSlope (timeStep / 2)| ≤
      (K + (L * B * M / 4 + N * K / 2 + G / 2) / 2 + T / 4) *
        width ^ 2 := by
  let centeredSlope :=
    ((profile face - profile (face - width)) / width +
      (profile (face + width) - profile face) / width) / 2
  let fluxGradient :=
    (flux' (oneDimensionalCellAverage profile face (face + width)) *
        ((profile (face + width) - profile face) / width) -
      flux' (oneDimensionalCellAverage profile (face - width) face) *
        ((profile face - profile (face - width)) / width)) / width
  let F := L * B * M / 4 + N * K / 2 + G / 2
  have hstate := leveque04_richtmyer_exactAverageMeanSlope_error
    profile profile' profile'' face width K
    hK hwidth hprofile hprofile' hsecondLip
  have hflux := leveque04_richtmyer_exactAverageFluxGradient_error
    profile profile' profile'' flux' physicalSecond
    face width L B K M N G hwidth hL hB hK hN hG
    hleftSmooth hrightSmooth hleftCurvature hrightCurvature
    hprofile hprofile' hsecondLip hfluxDerivLip
    hleftSlopeBound hrightSlopeBound hleftFluxBound hrightFluxBound
    hphysicalDeriv hphysicalLip
  have hF : 0 ≤ F := by dsimp [F]; positivity
  have hresult := leveque04_richtmyer_predictorGradient_error
    centeredSlope fluxGradient (profile' face) (physicalSecond face)
    traceSlope traceTimeSlope timeStep width K F T
    htime hwidth hmesh hF hT
    (by simpa only [centeredSlope] using hstate)
    (by simpa only [fluxGradient, F] using hflux)
    htraceDeriv htraceLip hinitial.symm hpde
  simpa only [centeredSlope, fluxGradient, F] using hresult

end NumStability
