/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.SecondOrderTaylor

/-!
# Centered state slope in the Richtmyer predictor derivative

Differentiating the mean of the two neighboring exact cell averages
produces a centered secant over two cells. The existing second-order
centered-difference estimate controls its error at the shared face.
-/

namespace NumStability

/-- The mean of the left and right exact-average spatial derivatives
approximates the profile derivative at their shared face quadratically. -/
theorem leveque04_richtmyer_exactAverageMeanSlope_error
    (profile profile' profile'' : ℝ → ℝ)
    (face width K : ℝ)
    (hK : 0 ≤ K) (hwidth : 0 < width)
    (hprofile : ∀ x, HasDerivAt profile (profile' x) x)
    (hprofile' : ∀ x, HasDerivAt profile' (profile'' x) x)
    (hsecondLip : ∀ x y,
      |profile'' x - profile'' y| ≤ K * |x - y|) :
    |((profile face - profile (face - width)) / width +
        (profile (face + width) - profile face) / width) / 2 -
      profile' face| ≤ K * width ^ 2 := by
  have h := centeredDifference_deriv_error_le_of_lipschitzSecondDeriv
    profile profile' profile'' K face (2 * width)
    hK (by linarith) hprofile hprofile' hsecondLip
  have hplus : face + 2 * width / 2 = face + width := by ring
  have hminus : face - 2 * width / 2 = face - width := by ring
  rw [hplus, hminus] at h
  have hid :
      ((profile face - profile (face - width)) / width +
        (profile (face + width) - profile face) / width) / 2 =
      (profile (face + width) - profile (face - width)) /
        (2 * width) := by
    field_simp [hwidth.ne']
    ring
  rw [hid]
  convert h using 1 <;> ring

end NumStability
