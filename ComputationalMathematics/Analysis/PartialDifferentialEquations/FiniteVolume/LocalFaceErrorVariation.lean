/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Tactic.Linarith

/-!
# Local variation of a smooth face-flux error

A derivative bound is needed only on the interval between the two faces
whose flux difference enters a conservative residual.
-/

namespace NumStability

/-- A derivative bound on one closed interval controls the endpoint error
difference on that interval. -/
theorem localFaceError_endpoint_bound
    (error error' : ℝ → ℝ) (left right bound : ℝ)
    (horder : left ≤ right)
    (hderiv : ∀ x ∈ Set.Icc left right, HasDerivAt error (error' x) x)
    (hbound : ∀ x ∈ Set.Icc left right, |error' x| ≤ bound) :
    |error right - error left| ≤ bound * (right - left) := by
  have h := (norm_image_sub_le_of_norm_deriv_le_segment'
    (a := left) (b := right) (f := error) (f' := error') (C := bound)
    (fun z hz => (hderiv z hz).hasDerivWithinAt)
    (fun z hz => by
      simpa [Real.norm_eq_abs] using hbound z ⟨hz.1, hz.2.le⟩))
    right ⟨horder, le_refl _⟩
  simpa only [Real.norm_eq_abs] using h

/-- A local derivative bound of quadratic mesh order gives cubic
variation of two neighboring sampled face errors. -/
theorem localFaceError_adjacent_bound
    (error error' : ℝ → ℝ) (face width bound : ℝ)
    (hwidth : 0 < width)
    (hderiv : ∀ x ∈ Set.Icc face (face + width),
      HasDerivAt error (error' x) x)
    (hbound : ∀ x ∈ Set.Icc face (face + width),
      |error' x| ≤ bound * width ^ 2) :
    |error (face + width) - error face| ≤ bound * width ^ 3 := by
  have h := localFaceError_endpoint_bound error error'
    face (face + width) (bound * width ^ 2)
    (by linarith) hderiv hbound
  simpa only [add_sub_cancel_left, pow_succ, mul_assoc] using h

end NumStability
