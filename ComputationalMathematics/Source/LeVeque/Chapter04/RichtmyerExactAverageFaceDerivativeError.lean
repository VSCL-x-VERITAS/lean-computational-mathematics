/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerFaceDerivativeError
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerExactFaceDerivative
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerPhysicalFluxAverageDerivative

/-!
# Derivative error of the exact-average Richtmyer face flux

The generic face-derivative budget is stated here for the actual scalar
equation-(4.23) predictor on two moving exact cell averages. This is the
quantity needed by the neighboring-face variation estimate.
-/

namespace NumStability

open MeasureTheory
open Set

/-- The derivative of the actual scalar Richtmyer face flux on exact
neighboring averages differs quadratically from the time-averaged
physical face-flux derivative, given the checked predictor value and
gradient estimates. -/
theorem leveque04_richtmyer_exactAverageFaceDerivative_error
    (profile flux flux' : ℝ → ℝ)
    (halfState halfSlope : ℝ → ℝ)
    (physicalSlopeTime : ℝ → ℝ → ℝ)
    (face timeStep width L A B M N C : ℝ)
    (htime : 0 < timeStep) (hmesh : timeStep ≤ width)
    (hwidthOne : width ≤ 1)
    (hL : 0 ≤ L) (hA : 0 ≤ A) (hB : 0 ≤ B) (hN : 0 ≤ N)
    (hvalue :
      |leveque04_richtmyerPredictor timeStep width
          (fun state (_ : Fin 1) => flux (state 0))
          (fun _ => oneDimensionalCellAverage profile (face - width) face)
          (fun _ => oneDimensionalCellAverage profile face (face + width)) 0 -
        halfState face| ≤ A * width ^ 2)
    (hgradient :
      |((profile face - profile (face - width)) / width +
          (profile (face + width) - profile face) / width) / 2 -
        timeStep / 2 *
          ((flux' (oneDimensionalCellAverage profile face (face + width)) *
              ((profile (face + width) - profile face) / width) -
            flux' (oneDimensionalCellAverage profile (face - width) face) *
              ((profile face - profile (face - width)) / width)) / width) -
        halfSlope face| ≤ B * width ^ 2)
    (hhalfSlopeBound : |halfSlope face| ≤ M)
    (hhalfFluxBound : |flux' (halfState face)| ≤ N)
    (hfluxDerivLip :
      |flux' (leveque04_richtmyerPredictor timeStep width
          (fun state (_ : Fin 1) => flux (state 0))
          (fun _ => oneDimensionalCellAverage profile (face - width) face)
          (fun _ => oneDimensionalCellAverage profile face (face + width)) 0) -
        flux' (halfState face)| ≤
        L * |leveque04_richtmyerPredictor timeStep width
          (fun state (_ : Fin 1) => flux (state 0))
          (fun _ => oneDimensionalCellAverage profile (face - width) face)
          (fun _ => oneDimensionalCellAverage profile face (face + width)) 0 -
        halfState face|)
    (hphysicalHalf :
      physicalSlopeTime face (timeStep / 2) =
        flux' (halfState face) * halfSlope face)
    (hphysicalSmooth : ContDiffOn ℝ 2 (physicalSlopeTime face)
      (Set.Icc 0 timeStep))
    (hphysicalCurvature : ∀ τ,
      |iteratedDerivWithin 2 (physicalSlopeTime face)
        (Set.Icc 0 timeStep) τ| ≤ C) :
    |flux' (leveque04_richtmyerPredictor timeStep width
        (fun state (_ : Fin 1) => flux (state 0))
        (fun _ => oneDimensionalCellAverage profile (face - width) face)
        (fun _ => oneDimensionalCellAverage profile face (face + width)) 0) *
      (((profile face - profile (face - width)) / width +
          (profile (face + width) - profile face) / width) / 2 -
        timeStep / 2 *
          ((flux' (oneDimensionalCellAverage profile face (face + width)) *
              ((profile (face + width) - profile face) / width) -
            flux' (oneDimensionalCellAverage profile (face - width) face) *
              ((profile face - profile (face - width)) / width)) / width)) -
      oneDimensionalCellAverage (physicalSlopeTime face) 0 timeStep| ≤
      (L * A * (M + B) + N * B + C / 8) * width ^ 2 := by
  exact leveque04_richtmyer_faceDerivative_error_of_halfSlopeBound
    flux' (physicalSlopeTime face)
    (leveque04_richtmyerPredictor timeStep width
      (fun state (_ : Fin 1) => flux (state 0))
      (fun _ => oneDimensionalCellAverage profile (face - width) face)
      (fun _ => oneDimensionalCellAverage profile face (face + width)) 0)
    (((profile face - profile (face - width)) / width +
      (profile (face + width) - profile face) / width) / 2 -
      timeStep / 2 *
        ((flux' (oneDimensionalCellAverage profile face (face + width)) *
            ((profile (face + width) - profile face) / width) -
          flux' (oneDimensionalCellAverage profile (face - width) face) *
            ((profile face - profile (face - width)) / width)) / width))
    (halfState face) (halfSlope face)
    timeStep width L A B M N C
    htime hmesh hwidthOne hL hA hB hN
    hvalue hgradient hhalfSlopeBound hhalfFluxBound hfluxDerivLip
    hphysicalHalf hphysicalSmooth hphysicalCurvature

/-- The derivative of the actual numerical face-flux error is the
checked predictor derivative expression minus the spatial derivative
of the physical time-averaged face flux. -/
theorem leveque04_richtmyer_exactAverageFaceError_hasDerivAt
    (q : ℝ → ℝ → ℝ) (profile flux flux' : ℝ → ℝ)
    (physicalSlope : ℝ → ℝ → ℝ)
    (left right face timeStep width : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hface : face ∈ Ioo left right)
    (hprofile : Continuous profile)
    (hflux : ∀ z, HasDerivAt flux (flux' z) z)
    (hfluxCont : ContinuousOn
      (Function.uncurry (fun x τ => flux (q x τ)))
      (Icc left right ×ˢ Icc 0 timeStep))
    (hslopeCont : ContinuousOn
      (Function.uncurry physicalSlope)
      (Icc left right ×ˢ Icc 0 timeStep))
    (hspatial : ∀ x ∈ Ioo left right, ∀ τ ∈ Icc 0 timeStep,
      HasDerivAt (fun y => flux (q y τ)) (physicalSlope x τ) x) :
    HasDerivAt
      (fun x =>
        leveque04_richtmyerFlux timeStep width
          (fun state (_ : Fin 1) => flux (state 0))
          (fun _ => oneDimensionalCellAverage profile (x - width) x)
          (fun _ => oneDimensionalCellAverage profile x (x + width)) 0 -
        oneDimensionalCellAverage (fun τ => flux (q x τ)) 0 timeStep)
      (flux' (leveque04_richtmyerPredictor timeStep width
          (fun state (_ : Fin 1) => flux (state 0))
          (fun _ => oneDimensionalCellAverage profile (face - width) face)
          (fun _ => oneDimensionalCellAverage profile face (face + width)) 0) *
        (((profile face - profile (face - width)) / width +
            (profile (face + width) - profile face) / width) / 2 -
          timeStep / (2 * width) *
            (flux' (oneDimensionalCellAverage profile face (face + width)) *
                ((profile (face + width) - profile face) / width) -
              flux' (oneDimensionalCellAverage profile (face - width) face) *
                ((profile face - profile (face - width)) / width))) -
        oneDimensionalCellAverage (fun τ => physicalSlope face τ)
          0 timeStep) face := by
  have hnum := leveque04_richtmyer_exactAverageFaceFlux_hasDerivAt
    profile flux flux' face timeStep width hprofile hwidth hflux
  have hphysical := leveque04_richtmyer_physicalFluxTimeAverage_hasDerivAt
    q flux physicalSlope left right face timeStep
    htime hface hfluxCont hslopeCont hspatial
  dsimp only at hnum
  exact hnum.sub hphysical

end NumStability
