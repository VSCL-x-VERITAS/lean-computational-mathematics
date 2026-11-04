import ComputationalMathematics.HDP.Scalar.SquareDeviation

/-! Source-facing contract for Equation (4.8). -/

namespace NumStability.HDP.Contract

/-- Equation (4.8), printed page 79: for a nonnegative real `z`, the deviation
of `z²` from one dominates both the linear and squared deviations of `z` from
one. -/
theorem hdp_04_heq_h4_d8 {z : ℝ} (hz : 0 ≤ z) :
    max |z - 1| (|z - 1| ^ 2) ≤ |z ^ 2 - 1| := by
  exact NumStability.HDP.Scalar.SquareDeviation.max_le_abs_sq_sub_one
    hz (abs_nonneg _) le_rfl

end NumStability.HDP.Contract
