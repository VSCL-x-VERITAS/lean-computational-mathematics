/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorMovingExactAverages

/-!
# Spatial derivative of the vector Richtmyer interface flux

The physical flux Jacobian and the derivatives of neighboring vector
states give the derivative of the actual predictor and face flux.
-/

namespace NumStability

open MeasureTheory

theorem leveque04_richtmyerVectorPredictor_hasDerivAt
    {m : ℕ} (flux : (Fin m → ℝ) → Fin m → ℝ)
    (jacobian : (Fin m → ℝ) → (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (left right left' right' : ℝ → Fin m → ℝ)
    (timeStep width x : ℝ)
    (hleft : HasDerivAt left (left' x) x)
    (hright : HasDerivAt right (right' x) x)
    (hfluxLeft : HasFDerivAt flux (jacobian (left x)) (left x))
    (hfluxRight : HasFDerivAt flux (jacobian (right x)) (right x)) :
    HasDerivAt
      (fun y => leveque04_richtmyerPredictor timeStep width flux
        (left y) (right y))
      ((1 / 2 : ℝ) • (left' x + right' x) -
        (timeStep / (2 * width)) •
          (jacobian (right x) (right' x) -
            jacobian (left x) (left' x))) x := by
  have hL := hfluxLeft.comp_hasDerivAt x hleft
  have hR := hfluxRight.comp_hasDerivAt x hright
  have hsum := (hleft.add hright).const_smul (1 / 2 : ℝ)
  have hdiff := (hR.sub hL).const_smul (timeStep / (2 * width))
  simpa only [leveque04_richtmyerPredictor] using hsum.sub hdiff

theorem leveque04_richtmyerVectorFlux_hasDerivAt
    {m : ℕ} (flux : (Fin m → ℝ) → Fin m → ℝ)
    (jacobian : (Fin m → ℝ) → (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (left right left' right' : ℝ → Fin m → ℝ)
    (timeStep width x : ℝ)
    (hleft : HasDerivAt left (left' x) x)
    (hright : HasDerivAt right (right' x) x)
    (hflux : ∀ z, HasFDerivAt flux (jacobian z) z) :
    HasDerivAt
      (fun y => leveque04_richtmyerFlux timeStep width flux
        (left y) (right y))
      (jacobian
        (leveque04_richtmyerPredictor timeStep width flux
          (left x) (right x))
        ((1 / 2 : ℝ) • (left' x + right' x) -
          (timeStep / (2 * width)) •
            (jacobian (right x) (right' x) -
              jacobian (left x) (left' x)))) x := by
  have hp := leveque04_richtmyerVectorPredictor_hasDerivAt
    flux jacobian left right left' right' timeStep width x
    hleft hright (hflux _) (hflux _)
  simpa only [leveque04_richtmyerFlux] using
    (hflux _).comp_hasDerivAt x hp

/-- The actual vector face flux on exact neighboring spatial cell
averages has the Jacobian chain-rule derivative at every face. -/
theorem leveque04_richtmyer_vectorExactAverageFace_hasDerivAt
    {m : ℕ} (profile : ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (jacobian : (Fin m → ℝ) → (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (timeStep width face : ℝ)
    (hprofile : Continuous profile) (hwidth : 0 < width)
    (hflux : ∀ z, HasFDerivAt flux (jacobian z) z) :
    let left := fun x => oneDimensionalCellAverage profile (x - width) x
    let right := fun x => oneDimensionalCellAverage profile x (x + width)
    let leftSlope := fun x => width⁻¹ • (profile x - profile (x - width))
    let rightSlope := fun x => width⁻¹ • (profile (x + width) - profile x)
    HasDerivAt
      (fun x => leveque04_richtmyerFlux timeStep width flux
        (left x) (right x))
      (jacobian
        (leveque04_richtmyerPredictor timeStep width flux
          (left face) (right face))
        ((1 / 2 : ℝ) • (leftSlope face + rightSlope face) -
          (timeStep / (2 * width)) •
            (jacobian (right face) (rightSlope face) -
              jacobian (left face) (leftSlope face)))) face := by
  dsimp only
  exact leveque04_richtmyerVectorFlux_hasDerivAt
    flux jacobian
    (fun x => oneDimensionalCellAverage profile (x - width) x)
    (fun x => oneDimensionalCellAverage profile x (x + width))
    (fun x => width⁻¹ • (profile x - profile (x - width)))
    (fun x => width⁻¹ • (profile (x + width) - profile x))
    timeStep width face
    (leveque04_richtmyer_vectorLeftExactAverage_hasDerivAt
      profile face width hprofile hwidth)
    (leveque04_richtmyer_vectorRightExactAverage_hasDerivAt
      profile face width hprofile hwidth)
    hflux

end NumStability
