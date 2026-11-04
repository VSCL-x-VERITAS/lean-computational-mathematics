/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.AbsolutelyContinuousFun

/-!
# Integrating an almost-everywhere derivative bound

The Lipschitz hypothesis supplies absolute continuity and the fundamental
theorem of calculus. An independently supplied physical derivative bound can
therefore replace the analytic Lipschitz constant in the displacement estimate.
-/

noncomputable section
open Set MeasureTheory Filter
open scoped Interval NNReal

namespace NumStability

theorem lipschitz_abs_sub_le_of_ae_deriv_le (f : ℝ → ℝ) {C : ℝ≥0}
    (hf : LipschitzWith C f) (a b bound : ℝ) (hab : a ≤ b)
    (hderiv : ∀ᵐ t : ℝ, t ∈ Ioc a b → |deriv f t| ≤ bound) :
    |f b - f a| ≤ bound * (b - a) := by
  have hac := hf.lipschitzOnWith (s := uIcc a b) |>.absolutelyContinuousOnInterval
  have hnorm : ∀ᵐ t : ℝ, t ∈ Ι a b → ‖deriv f t‖ ≤ bound := by
    simpa only [uIoc_of_le hab, Real.norm_eq_abs] using hderiv
  have hi := intervalIntegral.norm_integral_le_of_norm_le_const_ae hnorm
  rw [hac.integral_deriv_eq_sub, Real.norm_eq_abs, abs_of_nonneg (sub_nonneg.mpr hab)] at hi
  exact hi

end NumStability
