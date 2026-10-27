/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Forward Difference

The forward difference quotient of two real point samples. Applications to
derivative approximation use a positive step.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

namespace NumStability.FiniteVolume

/-- The forward difference quotient of two real point samples. Applications to
derivative approximation use a positive step. -/
noncomputable def forwardDifferenceQuotient (u : ℝ → ℝ) (x h : ℝ) : ℝ :=
  (u (x + h) - u x) / h

end NumStability.FiniteVolume
