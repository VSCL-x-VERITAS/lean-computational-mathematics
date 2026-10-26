/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.FirstOrderTaylor

/-!
# Taylor bound with an approximate slope

An approximate derivative incurs an additional first-order slope error
in a one-step Taylor estimate. At a time step proportional to the mesh
width, a slope error proportional to width remains quadratic locally.
-/

namespace NumStability

/-- A Lipschitz derivative and a width-order slope approximation give a
quadratic one-step error at a fixed time-to-width ratio. -/
theorem firstOrderTaylorError_le_of_approximateSlope
    (g g' : ℝ → ℝ) (t targetSlope ratio width K D : ℝ)
    (hratio : 0 ≤ ratio) (hwidth : 0 ≤ width)
    (hK : 0 ≤ K)
    (hg : ∀ τ, HasDerivAt g (g' τ) τ)
    (hLip : ∀ s τ, |g' s - g' τ| ≤ K * |s - τ|)
    (hslope : |g' t - targetSlope| ≤ D * width) :
    |g (t + ratio * width) -
      (g t + targetSlope * (ratio * width))| ≤
      (K * ratio ^ 2 + D * ratio) * width ^ 2 := by
  have htaylor := firstOrderTaylorError_le_of_lipschitzDeriv
    g g' K t (t + ratio * width) hK hg hLip
  have hstep : 0 ≤ ratio * width := mul_nonneg hratio hwidth
  have hslopeScaled := mul_le_mul_of_nonneg_right hslope hstep
  have htri :
      |g (t + ratio * width) -
          (g t + targetSlope * (ratio * width))| ≤
        |g (t + ratio * width) -
          (g t + g' t * ((t + ratio * width) - t))| +
        |g' t - targetSlope| * (ratio * width) := by
    have hid : g (t + ratio * width) -
        (g t + targetSlope * (ratio * width)) =
      (g (t + ratio * width) -
        (g t + g' t * ((t + ratio * width) - t))) +
      (g' t - targetSlope) * (ratio * width) := by ring
    rw [hid]
    simpa only [abs_mul, abs_of_nonneg hstep] using
      (abs_add_le
        (g (t + ratio * width) -
          (g t + g' t * ((t + ratio * width) - t)))
        ((g' t - targetSlope) * (ratio * width)))
  calc
    _ ≤ |g (t + ratio * width) -
          (g t + g' t * ((t + ratio * width) - t))| +
        |g' t - targetSlope| * (ratio * width) := htri
    _ ≤ K * ((t + ratio * width) - t) ^ 2 +
        (D * width) * (ratio * width) :=
      add_le_add htaylor hslopeScaled
    _ = (K * ratio ^ 2 + D * ratio) * width ^ 2 := by ring

end NumStability
