import ComputationalMathematics.HDP.Scalar.SquareDeviation
import ComputationalMathematics.Source.Vershynin.Chapter03.Equation02.Signature

/-! Source-facing contract for Equation (3.2). -/

namespace NumStability.HDP.Contract

/-- Equation (3.2), printed page 43: squaring a nonnegative scalar preserves at
least the larger of the linear and quadratic deviation scales from one. -/
theorem hdp_03_heq_h3_d2 {z δ : ℝ} (hz : 0 ≤ z) (hδ : 0 ≤ δ)
    (h : δ ≤ |z - 1|) : max δ (δ ^ 2) ≤ |z ^ 2 - 1| :=
  NumStability.HDP.Scalar.SquareDeviation.max_le_abs_sq_sub_one hz hδ h

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Equation (3.2) signature. -/
theorem hdp_03_heq_h3_d2__contract : hdp_03_heq_h3_d2__contract_type := by
  intro z δ hz hδ h
  exact hdp_03_heq_h3_d2 hz hδ h

end NumStability.HDP.Contract
