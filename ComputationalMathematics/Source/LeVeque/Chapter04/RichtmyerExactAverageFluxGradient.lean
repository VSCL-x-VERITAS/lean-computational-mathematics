/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.CenteredSecant
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerCellFluxSlopeMidpoint

/-!
# Flux gradient in the Richtmyer predictor derivative

The two flux-derivative times exact-average slope factors at neighboring
cells approximate the physical spatial flux gradient at their midpoints.
Their difference quotient therefore approximates the physical second
spatial derivative at the shared face to first order.
-/

namespace NumStability

/-- The flux-gradient term in the spatial derivative of the exact-average
Richtmyer predictor has a first-order approximation error. -/
theorem leveque04_richtmyer_exactAverageFluxGradient_error
    (profile profile' profile'' flux' physicalSecond : ℝ → ℝ)
    (face width L B K M N G : ℝ)
    (hwidth : 0 < width)
    (hL : 0 ≤ L) (hB : 0 ≤ B) (hK : 0 ≤ K)
    (hN : 0 ≤ N) (hG : 0 ≤ G)
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
      |physicalSecond x - physicalSecond y| ≤ G * |x - y|) :
    |(flux' (oneDimensionalCellAverage profile face (face + width)) *
          ((profile (face + width) - profile face) / width) -
        flux' (oneDimensionalCellAverage profile (face - width) face) *
          ((profile face - profile (face - width)) / width)) / width -
      physicalSecond face| ≤
      (L * B * M / 4 + N * K / 2 + G / 2) * width := by
  let physicalGradient : ℝ → ℝ := fun x =>
    flux' (profile x) * profile' x
  let leftValue :=
    flux' (oneDimensionalCellAverage profile (face - width) face) *
      ((profile face - profile (face - width)) / width)
  let rightValue :=
    flux' (oneDimensionalCellAverage profile face (face + width)) *
      ((profile (face + width) - profile face) / width)
  let E := L * B * M / 8 + N * K / 4
  have hleft := leveque04_richtmyer_cellFluxSlope_midpointError
    profile profile' profile'' flux' (face - width) width L B K M N
    hwidth hL hB hK hN
    (by simpa only [sub_add_cancel] using hleftSmooth)
    (by simpa only [sub_add_cancel] using hleftCurvature)
    hprofile hprofile' hsecondLip hfluxDerivLip
    (by simpa only [sub_add_cancel] using hleftSlopeBound)
    (by
      simpa only [show face - width + width / 2 =
        face - width / 2 by ring] using hleftFluxBound)
  have hright := leveque04_richtmyer_cellFluxSlope_midpointError
    profile profile' profile'' flux' face width L B K M N
    hwidth hL hB hK hN hrightSmooth hrightCurvature
    hprofile hprofile' hsecondLip hfluxDerivLip
    hrightSlopeBound hrightFluxBound
  have hleft' : |leftValue - physicalGradient (face - width / 2)| ≤
      E * width ^ 2 := by
    simpa only [leftValue, physicalGradient, E,
      show face - width + width = face by ring,
      show face - width + width / 2 = face - width / 2 by ring]
      using hleft
  have hright' : |rightValue - physicalGradient (face + width / 2)| ≤
      E * width ^ 2 := by
    simpa only [rightValue, physicalGradient, E] using hright
  have hsecant := centeredSecant_deriv_error_le_of_lipschitzDeriv
    physicalGradient physicalSecond G face width
    hG hwidth hphysicalDeriv hphysicalLip
  have h := centeredSecant_error_of_endpointErrors
    physicalGradient physicalSecond leftValue rightValue
    face width G E hwidth hleft' hright' hsecant
  convert h using 1 <;> ring

end NumStability
