/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.FirstOrderTaylorDifference

/-!
# Secant flux slope near a reference state

Dividing the two-face Taylor difference by a positive cell width gives
a first-order error bound for the flux secant slope.
-/

namespace NumStability

/-- The flux secant differs from the derivative at a nearby reference
state times the state secant by a width-order term. -/
theorem fluxSecantTaylorError_le
    (flux flux' : ℝ → ℝ) (K S width base left right : ℝ)
    (hK : 0 ≤ K) (hS : 0 ≤ S) (hwidth : 0 < width)
    (hflux : ∀ y, HasDerivAt flux (flux' y) y)
    (hLip : ∀ y z, |flux' y - flux' z| ≤ K * |y - z|)
    (hleft : |left - base| ≤ S * width)
    (hright : |right - base| ≤ S * width) :
    |(flux right - flux left) / width -
      flux' base * ((right - left) / width)| ≤
      (2 * (K * S ^ 2)) * width := by
  have h := firstOrderTaylorDifference_le_of_distanceScale
    flux flux' K S width base left right
    hK hS hwidth.le hflux hLip hleft hright
  have hdiv := div_le_div_of_nonneg_right h hwidth.le
  have hne : width ≠ 0 := ne_of_gt hwidth
  have heq :
      (flux right - flux left) / width -
        flux' base * ((right - left) / width) =
      ((flux right - flux left) - flux' base * (right - left)) / width := by
    ring
  rw [heq, abs_div, abs_of_pos hwidth]
  have hfactor :
      (2 * (K * S ^ 2) * width ^ 2) / width =
        (2 * (K * S ^ 2)) * width := by
    field_simp
  rw [hfactor] at hdiv
  exact hdiv

end NumStability
