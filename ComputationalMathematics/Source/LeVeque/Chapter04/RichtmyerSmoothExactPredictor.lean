/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerAdjacentAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerExactAverageFluxSlope
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerPDEHalfTimeTaylor
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerMidpointPredictorError

/-!
# Actual scalar Richtmyer predictor on exact averages

The three proved smooth-solution premises are assembled into the
quadratic state error of the actual equation-(4.23) predictor.
-/

namespace NumStability

open MeasureTheory

/-- The scalar Richtmyer predictor from exact neighboring spatial
averages is quadratically close to the physical half-time face state. -/
theorem leveque04_richtmyer_smoothExactAverage_predictorError
    (q : ℝ → ℝ → ℝ) (flux physicalSlope timeSlope : ℝ → ℝ)
    (face width timeStep L B K T : ℝ)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hmesh : timeStep ≤ width)
    (hL : 0 ≤ L) (hB : 0 ≤ B) (hK : 0 ≤ K) (hT : 0 ≤ T)
    (hleftInt : IntervalIntegrable (fun x => q x 0) volume
      (face - width) face)
    (hrightInt : IntervalIntegrable (fun x => q x 0) volume
      face (face + width))
    (hunionSmooth : ContDiffOn ℝ 2 (fun x => q x 0)
      (Set.Icc (face - width) (face + width)))
    (hunionBound : ∀ x,
      |iteratedDerivWithin 2 (fun y => q y 0)
        (Set.Icc (face - width) (face + width)) x| ≤ B)
    (hleftSmooth : ContDiffOn ℝ 2 (fun x => q x 0)
      (Set.Icc (face - width) face))
    (hrightSmooth : ContDiffOn ℝ 2 (fun x => q x 0)
      (Set.Icc face (face + width)))
    (hleftBound : ∀ x,
      |iteratedDerivWithin 2 (fun y => q y 0)
        (Set.Icc (face - width) face) x| ≤ B)
    (hrightBound : ∀ x,
      |iteratedDerivWithin 2 (fun y => q y 0)
        (Set.Icc face (face + width)) x| ≤ B)
    (hfluxLip : ∀ u v, |flux u - flux v| ≤ L * |u - v|)
    (hphysicalDeriv : ∀ x,
      HasDerivAt (fun y => flux (q y 0)) (physicalSlope x) x)
    (hphysicalLip : ∀ x y,
      |physicalSlope x - physicalSlope y| ≤ K * |x - y|)
    (htraceDeriv : ∀ τ,
      HasDerivAt (fun σ => q face σ) (timeSlope τ) τ)
    (htraceLip : ∀ τ σ,
      |timeSlope τ - timeSlope σ| ≤ T * |τ - σ|)
    (hpde : timeSlope 0 + physicalSlope face = 0) :
    |leveque04_richtmyerPredictor timeStep width
        (fun state (_ : Fin 1) => flux (state 0))
        (fun _ => oneDimensionalCellAverage (fun x => q x 0)
          (face - width) face)
        (fun _ => oneDimensionalCellAverage (fun x => q x 0)
          face (face + width)) 0 - q face (timeStep / 2)| ≤
      (B / 2 + (L * B / 4 + K / 2) / 2 + T / 4) * width ^ 2 := by
  let profile : ℝ → ℝ := fun x => q x 0
  let left : Fin 1 → ℝ := fun _ =>
    oneDimensionalCellAverage profile (face - width) face
  let right : Fin 1 → ℝ := fun _ =>
    oneDimensionalCellAverage profile face (face + width)
  have hstate := leveque04_richtmyer_adjacentExactAverages_midpointError
    profile face width B hwidth hleftInt hrightInt hunionSmooth hunionBound
  have hflux := leveque04_richtmyer_exactAverageFluxSlope_error
    profile flux physicalSlope face width L B K
    hwidth hL hK hleftSmooth hrightSmooth hleftBound hrightBound
    hfluxLip hphysicalDeriv hphysicalLip
  have htaylor := leveque04_richtmyer_pdeFace_halfTimeTaylor
    q timeSlope face (physicalSlope face) timeStep T
    hT htraceDeriv htraceLip hpde
  have hfluxBound : 0 ≤ L * B / 4 + K / 2 := by positivity
  have h := leveque04_richtmyerScalar_midpointPredictorError
    flux left right (q face 0) (physicalSlope face)
    (q face (timeStep / 2))
    timeStep width (B / 2) (L * B / 4 + K / 2) (T / 4)
    htime hwidth hmesh hfluxBound (by positivity)
    (by
      simpa only [left, right, profile,
        show B * width ^ 2 / 2 = B / 2 * width ^ 2 by ring] using hstate)
    (by simpa only [left, right, profile] using hflux)
    htaylor
  simpa only [left, right, profile] using h

end NumStability
