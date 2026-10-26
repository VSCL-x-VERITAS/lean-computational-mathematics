/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerCellSlopeMidpoint
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerFaceDerivativeBudget
import ComputationalMathematics.Source.LeVeque.Chapter04.MidpointError

/-!
# Cell flux-slope midpoint error in the Richtmyer derivative

The spatial derivative of the physical flux evaluated on a moving
exact cell average differs quadratically from the physical flux
derivative evaluated at the cell midpoint.
-/

namespace NumStability

/-- A flux derivative times an exact cell-average endpoint slope is a
second-order approximation to the physical flux spatial derivative at
the cell midpoint. -/
theorem leveque04_richtmyer_cellFluxSlope_midpointError
    (profile profile' profile'' flux' : ℝ → ℝ)
    (left width L B K M N : ℝ)
    (hwidth : 0 < width)
    (hL : 0 ≤ L) (hB : 0 ≤ B) (hK : 0 ≤ K) (hN : 0 ≤ N)
    (hsmooth : ContDiffOn ℝ 2 profile (Set.Icc left (left + width)))
    (hcurvature : ∀ x,
      |iteratedDerivWithin 2 profile (Set.Icc left (left + width)) x| ≤ B)
    (hprofile : ∀ x, HasDerivAt profile (profile' x) x)
    (hprofile' : ∀ x, HasDerivAt profile' (profile'' x) x)
    (hsecondLip : ∀ x y,
      |profile'' x - profile'' y| ≤ K * |x - y|)
    (hfluxDerivLip : ∀ u v,
      |flux' u - flux' v| ≤ L * |u - v|)
    (hslopeBound : |(profile (left + width) - profile left) / width| ≤ M)
    (hfluxBound : |flux' (profile (left + width / 2))| ≤ N) :
    |flux' (oneDimensionalCellAverage profile left (left + width)) *
        ((profile (left + width) - profile left) / width) -
      flux' (profile (left + width / 2)) *
        profile' (left + width / 2)| ≤
      (L * B * M / 8 + N * K / 4) * width ^ 2 := by
  have hmid := leveque04_midpointError_secondOrder
    profile left (left + width) B (by linarith) hsmooth hcurvature
  have hstate :
      |oneDimensionalCellAverage profile left (left + width) -
        profile (left + width / 2)| ≤ (B / 8) * width ^ 2 := by
    have hcenter : (left + (left + width)) / 2 = left + width / 2 := by ring
    rw [hcenter] at hmid
    convert hmid using 1 <;> ring
  have hslope := leveque04_richtmyer_cellSlope_midpointError
    profile profile' profile'' left width K
    hK hwidth hprofile hprofile' hsecondLip
  have h := leveque04_richtmyer_faceDerivative_errorBudget
    flux'
    (oneDimensionalCellAverage profile left (left + width))
    ((profile (left + width) - profile left) / width)
    (profile (left + width / 2)) (profile' (left + width / 2))
    (flux' (profile (left + width / 2)) * profile' (left + width / 2))
    width L (B / 8) (K / 4) M N 0
    hL (by positivity) hN hstate
    (by convert hslope using 1 <;> ring)
    hslopeBound hfluxBound (hfluxDerivLip _ _) (by simp)
  convert h using 1 <;> ring

end NumStability
