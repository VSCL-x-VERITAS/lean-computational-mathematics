/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Abs
import Mathlib.Tactic

/-!
# The right derivative of absolute value

The right derivative includes the value +1 at the origin.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability

noncomputable section

theorem hasDerivWithinAt_abs_right (x : ℝ) :
    HasDerivWithinAt (abs : ℝ → ℝ) (if x < 0 then -1 else 1) (Ioi x) x := by
  by_cases hx : x < 0
  · simpa only [if_pos hx] using (hasDerivAt_abs_neg hx).hasDerivWithinAt
  by_cases hpos : 0 < x
  · simpa only [if_neg hx] using (hasDerivAt_abs_pos hpos).hasDerivWithinAt
  have hz : x = 0 := by linarith
  subst x
  simp only [lt_self_iff_false, if_false]
  apply (hasDerivAt_id (0 : ℝ)).hasDerivWithinAt.congr
  · intro y hy
    exact abs_of_pos hy
  · exact abs_zero


end

end NumStability
