import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Deviation of a nonnegative square from one

An elementary lower bound that converts a deviation of a nonnegative real
number from one into a deviation of its square.
-/

namespace NumStability.HDP.Scalar.SquareDeviation

/-- If a nonnegative real `z` is at least `δ` away from one, then its square is
at least both `δ` and `δ²` away from one. -/
theorem max_le_abs_sq_sub_one {z δ : ℝ} (hz : 0 ≤ z) (hδ : 0 ≤ δ)
    (h : δ ≤ |z - 1|) : max δ (δ ^ 2) ≤ |z ^ 2 - 1| := by
  have hz1 : 0 ≤ z + 1 := by
    linarith
  have habs_le : |z - 1| ≤ z + 1 := by
    rw [abs_le]
    constructor
    · linarith
    · linarith
  have hfactor : |z ^ 2 - 1| = |z - 1| * (z + 1) := by
    calc
      |z ^ 2 - 1| = |(z - 1) * (z + 1)| := by
        congr 1
        ring
      _ = |z - 1| * |z + 1| := abs_mul _ _
      _ = |z - 1| * (z + 1) := by rw [abs_of_nonneg hz1]
  rw [hfactor]
  apply max_le
  · nlinarith [abs_nonneg (z - 1)]
  · nlinarith [abs_nonneg (z - 1)]

end NumStability.HDP.Scalar.SquareDeviation
