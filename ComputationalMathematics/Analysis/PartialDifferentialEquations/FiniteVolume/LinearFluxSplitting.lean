/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Matrix.Mul
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Abel

/-!
# Linear flux splitting

When a linear flux matrix is the sum of its two directional parts, the
left-state, right-state, and split-state interface formulas coincide.
-/

namespace NumStability.LinearFluxSplitting

variable {m : ℕ}

/-- The linear face flux expressed from the left state and negative
fluctuation equals its right-state expression. -/
theorem left_eq_right
    (coefficient positive negative : Matrix (Fin m) (Fin m) ℝ)
    (hsum : positive + negative = coefficient)
    (left right : Fin m → ℝ) :
    coefficient.mulVec left + negative.mulVec (right - left) =
      coefficient.mulVec right - positive.mulVec (right - left) := by
  have haction : coefficient.mulVec (right - left) =
      positive.mulVec (right - left) +
        negative.mulVec (right - left) := by
    rw [← Matrix.add_mulVec, hsum]
  have hright : coefficient.mulVec right =
      coefficient.mulVec left + coefficient.mulVec (right - left) := by
    rw [Matrix.mulVec_sub]
    abel
  rw [hright, haction]
  abel

/-- Either one-sided interface formula is the sum of the positive
matrix action on the left state and negative action on the right state. -/
theorem left_eq_split
    (coefficient positive negative : Matrix (Fin m) (Fin m) ℝ)
    (hsum : positive + negative = coefficient)
    (left right : Fin m → ℝ) :
    coefficient.mulVec left + negative.mulVec (right - left) =
      positive.mulVec left + negative.mulVec right := by
  have hleft : coefficient.mulVec left =
      positive.mulVec left + negative.mulVec left := by
    rw [← Matrix.add_mulVec, hsum]
  rw [hleft, Matrix.mulVec_sub]
  abel

/-- Equal states recover the physical linear flux. -/
theorem split_consistent
    (coefficient positive negative : Matrix (Fin m) (Fin m) ℝ)
    (hsum : positive + negative = coefficient)
    (state : Fin m → ℝ) :
    positive.mulVec state + negative.mulVec state =
      coefficient.mulVec state := by
  rw [← Matrix.add_mulVec, hsum]

end NumStability.LinearFluxSplitting
