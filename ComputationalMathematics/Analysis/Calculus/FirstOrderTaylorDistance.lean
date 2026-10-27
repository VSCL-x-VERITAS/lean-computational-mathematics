/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.FirstOrderTaylor

/-!
# Taylor bounds from a distance scale

A Lipschitz derivative yields a quadratic Taylor remainder when the
evaluation point lies within a prescribed multiple of a mesh width.
-/

namespace NumStability

/-- A linear distance bound converts a first-order Taylor remainder
into a quadratic mesh-width estimate. -/
theorem firstOrderTaylorError_le_of_distanceScale
    (f f' : ℝ → ℝ) (K S width center x : ℝ)
    (hK : 0 ≤ K) (hS : 0 ≤ S) (hwidth : 0 ≤ width)
    (hf : ∀ y, HasDerivAt f (f' y) y)
    (hLip : ∀ y z, |f' y - f' z| ≤ K * |y - z|)
    (hdist : |x - center| ≤ S * width) :
    |f x - (f center + f' center * (x - center))| ≤
      (K * S ^ 2) * width ^ 2 := by
  have htaylor := firstOrderTaylorError_le_of_lipschitzDeriv
    f f' K center x hK hf hLip
  have hscale : 0 ≤ S * width := mul_nonneg hS hwidth
  have hsq : (x - center) ^ 2 ≤ (S * width) ^ 2 := by
    apply (sq_le_sq).mpr
    simpa only [abs_of_nonneg hscale] using hdist
  have hmul := mul_le_mul_of_nonneg_left hsq hK
  calc
    _ ≤ K * (x - center) ^ 2 := htaylor
    _ ≤ K * (S * width) ^ 2 := hmul
    _ = (K * S ^ 2) * width ^ 2 := by ring

end NumStability
