/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

set_option autoImplicit false

namespace NumStability.FiniteVolume

/-- The forward difference quotient of two real point samples. Applications to
derivative approximation use a positive step. -/
noncomputable def forwardDifferenceQuotient (u : ℝ → ℝ) (x h : ℝ) : ℝ :=
  (u (x + h) - u x) / h

end NumStability.FiniteVolume
