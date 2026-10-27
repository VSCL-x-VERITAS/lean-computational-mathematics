/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.CenteredSecant
import ComputationalMathematics.Source.LeVeque.Chapter04.MidpointError

/-!
# Flux slope of neighboring exact averages

For a smooth scalar profile, the physical flux difference of adjacent
exact cell averages approximates the physical flux derivative at their
shared face. This supplies the second spatial premise of the Richtmyer
half-time predictor error estimate.
-/

namespace NumStability

/-- The centered physical-flux quotient of neighboring exact cell
averages has a first-order slope error at their shared face. -/
theorem leveque04_richtmyer_exactAverageFluxSlope_error
    (profile flux physicalSlope : ℝ → ℝ)
    (face width L B K : ℝ)
    (hwidth : 0 < width) (hL : 0 ≤ L) (hK : 0 ≤ K)
    (hleftSmooth : ContDiffOn ℝ 2 profile
      (Set.Icc (face - width) face))
    (hrightSmooth : ContDiffOn ℝ 2 profile
      (Set.Icc face (face + width)))
    (hleftBound : ∀ x,
      |iteratedDerivWithin 2 profile
        (Set.Icc (face - width) face) x| ≤ B)
    (hrightBound : ∀ x,
      |iteratedDerivWithin 2 profile
        (Set.Icc face (face + width)) x| ≤ B)
    (hfluxLip : ∀ u v, |flux u - flux v| ≤ L * |u - v|)
    (hphysicalDeriv : ∀ x,
      HasDerivAt (fun y => flux (profile y)) (physicalSlope x) x)
    (hphysicalLip : ∀ x y,
      |physicalSlope x - physicalSlope y| ≤ K * |x - y|) :
    |(flux (oneDimensionalCellAverage profile face (face + width)) -
        flux (oneDimensionalCellAverage profile (face - width) face)) /
        width - physicalSlope face| ≤
      (L * B / 4 + K / 2) * width := by
  let physicalFlux : ℝ → ℝ := fun x => flux (profile x)
  let leftValue := flux (oneDimensionalCellAverage profile (face - width) face)
  let rightValue := flux (oneDimensionalCellAverage profile face (face + width))
  have hleftMid := leveque04_midpointError_secondOrder
    profile (face - width) face B (by linarith)
    hleftSmooth hleftBound
  have hrightMid := leveque04_midpointError_secondOrder
    profile face (face + width) B (by linarith)
    hrightSmooth hrightBound
  have hleftState :
      |oneDimensionalCellAverage profile (face - width) face -
        profile (face - width / 2)| ≤ B * width ^ 2 / 8 := by
    have hmidpoint : (face - width + face) / 2 = face - width / 2 := by ring
    rw [hmidpoint] at hleftMid
    convert hleftMid using 1 <;> ring
  have hrightState :
      |oneDimensionalCellAverage profile face (face + width) -
        profile (face + width / 2)| ≤ B * width ^ 2 / 8 := by
    have hmidpoint : (face + (face + width)) / 2 = face + width / 2 := by ring
    rw [hmidpoint] at hrightMid
    convert hrightMid using 1 <;> ring
  have hleftFlux :
      |leftValue - physicalFlux (face - width / 2)| ≤
        (L * B / 8) * width ^ 2 := by
    calc
      _ ≤ L * |oneDimensionalCellAverage profile (face - width) face -
          profile (face - width / 2)| :=
            hfluxLip _ _
      _ ≤ L * (B * width ^ 2 / 8) :=
            mul_le_mul_of_nonneg_left hleftState hL
      _ = _ := by ring
  have hrightFlux :
      |rightValue - physicalFlux (face + width / 2)| ≤
        (L * B / 8) * width ^ 2 := by
    calc
      _ ≤ L * |oneDimensionalCellAverage profile face (face + width) -
          profile (face + width / 2)| :=
            hfluxLip _ _
      _ ≤ L * (B * width ^ 2 / 8) :=
            mul_le_mul_of_nonneg_left hrightState hL
      _ = _ := by ring
  have hsecant := centeredSecant_deriv_error_le_of_lipschitzDeriv
    physicalFlux physicalSlope K face width hK hwidth hphysicalDeriv hphysicalLip
  have h := centeredSecant_error_of_endpointErrors
    physicalFlux physicalSlope leftValue rightValue face width K
    (L * B / 8) hwidth hleftFlux hrightFlux hsecant
  convert h using 1 <;> ring

end NumStability
