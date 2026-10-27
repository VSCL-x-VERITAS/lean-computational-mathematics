/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.SecondOrderTaylor

/-!
# Exact cell slope at its midpoint

Each endpoint difference in the spatial derivative of the Richtmyer
predictor is a centered difference around the corresponding cell
midpoint. The library's second-order centered-difference bound applies.
-/

namespace NumStability

/-- The endpoint slope of a cell approximates the smooth profile
derivative at that cell's midpoint to quadratic width order. -/
theorem leveque04_richtmyer_cellSlope_midpointError
    (profile profile' profile'' : ℝ → ℝ)
    (left width K : ℝ)
    (hK : 0 ≤ K) (hwidth : 0 < width)
    (hprofile : ∀ x, HasDerivAt profile (profile' x) x)
    (hprofile' : ∀ x, HasDerivAt profile' (profile'' x) x)
    (hsecondLip : ∀ x y,
      |profile'' x - profile'' y| ≤ K * |x - y|) :
    |(profile (left + width) - profile left) / width -
      profile' (left + width / 2)| ≤ K * width ^ 2 / 4 := by
  have h := centeredDifference_deriv_error_le_of_lipschitzSecondDeriv
    profile profile' profile'' K (left + width / 2) width
    hK hwidth hprofile hprofile' hsecondLip
  have hplus : left + width / 2 + width / 2 = left + width := by ring
  have hminus : left + width / 2 - width / 2 = left := by ring
  simpa only [hplus, hminus] using h

end NumStability
