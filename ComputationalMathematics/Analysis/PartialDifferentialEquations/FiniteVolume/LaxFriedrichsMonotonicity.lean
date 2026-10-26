/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

/-!
# Monotonicity of the scalar Lax-Friedrichs stencil

The two-neighbor scalar stencil is monotone under a Lipschitz CFL bound.
-/

namespace NumStability

/-- The scalar nonlinear Lax–Friedrichs two-neighbor stencil is
monotone when the physical flux is Lipschitz and the CFL product is at
most one. -/
theorem leveque04_laxFriedrichs_nonlinearStep_monotone
    (flux : ℝ → ℝ) (ratio L left₁ left₂ right₁ right₂ : ℝ)
    (hratio : 0 ≤ ratio)
    (hcfl : ratio * L ≤ 1)
    (hflux : ∀ x y, |flux x - flux y| ≤ L * |x - y|)
    (hleft : left₁ ≤ left₂) (hright : right₁ ≤ right₂) :
    (left₁ + right₁) / 2 - ratio / 2 * (flux right₁ - flux left₁) ≤
      (left₂ + right₂) / 2 - ratio / 2 * (flux right₂ - flux left₂) := by
  have hleftFlux := hflux left₂ left₁
  have hrightFlux := hflux right₂ right₁
  rw [abs_of_nonneg (sub_nonneg.mpr hleft)] at hleftFlux
  rw [abs_of_nonneg (sub_nonneg.mpr hright)] at hrightFlux
  have hlower := (abs_le.mp hleftFlux).1
  have hupper := (abs_le.mp hrightFlux).2
  have hleftCFL : 0 ≤ (1 - ratio * L) * (left₂ - left₁) :=
    mul_nonneg (sub_nonneg.mpr hcfl) (sub_nonneg.mpr hleft)
  have hrightCFL : 0 ≤ (1 - ratio * L) * (right₂ - right₁) :=
    mul_nonneg (sub_nonneg.mpr hcfl) (sub_nonneg.mpr hright)
  have hscaledLeft := mul_le_mul_of_nonneg_left hlower hratio
  have hscaledRight := mul_le_mul_of_nonneg_left hupper hratio
  nlinarith

end NumStability
