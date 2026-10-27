/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.FirstOrderTaylorDistance

/-!
# Difference of Taylor remainders at two nearby points

The constant part of a first-order Taylor expansion cancels in a
two-face flux difference, leaving the sum of two quadratic errors.
-/

namespace NumStability

/-- A smooth scalar function's two-point difference differs from its
linearization at a common base by at most two quadratic remainders. -/
theorem firstOrderTaylorDifference_le_of_distanceScale
    (f f' : ℝ → ℝ) (K S width base left right : ℝ)
    (hK : 0 ≤ K) (hS : 0 ≤ S) (hwidth : 0 ≤ width)
    (hf : ∀ y, HasDerivAt f (f' y) y)
    (hLip : ∀ y z, |f' y - f' z| ≤ K * |y - z|)
    (hleft : |left - base| ≤ S * width)
    (hright : |right - base| ≤ S * width) :
    |(f right - f left) - f' base * (right - left)| ≤
      2 * (K * S ^ 2) * width ^ 2 := by
  have hl := firstOrderTaylorError_le_of_distanceScale
    f f' K S width base left hK hS hwidth hf hLip hleft
  have hr := firstOrderTaylorError_le_of_distanceScale
    f f' K S width base right hK hS hwidth hf hLip hright
  calc
    |(f right - f left) - f' base * (right - left)| =
      |(f right - (f base + f' base * (right - base))) +
        -(f left - (f base + f' base * (left - base)))| := by
      congr 1; ring
    _ ≤ |f right - (f base + f' base * (right - base))| +
        |f left - (f base + f' base * (left - base))| := by
      simpa only [abs_neg] using
        (abs_add_le
          (f right - (f base + f' base * (right - base)))
          (-(f left - (f base + f' base * (left - base)))))
    _ ≤ 2 * (K * S ^ 2) * width ^ 2 := by linarith

end NumStability
