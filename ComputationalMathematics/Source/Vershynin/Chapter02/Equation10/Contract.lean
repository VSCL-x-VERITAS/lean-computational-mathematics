import ComputationalMathematics.HDP.Scalar.GaussianTails

/-!
# Contract: HDP equation (2.10)

The standard-normal two-sided Gaussian tail bound from the opening of
Section 2.5.
-/

noncomputable section

open NumStability.HDP.Scalar.LimitTheorems

namespace NumStability.HDP.Contract

/-- Equation (2.10): for a standard normal variable and every nonnegative
threshold, `P{|X| ≥ t} ≤ 2 exp(-t²/2)`. -/
theorem hdp_02_heq_h2_d10 (t : ℝ) (ht : 0 ≤ t) :
    standardNormalLaw.real {x : ℝ | |x| ≥ t} ≤
      2 * Real.exp (-(t ^ 2) / 2) :=
  NumStability.HDP.Scalar.GaussianTails.standardNormal_twoSidedTail_le t ht

end NumStability.HDP.Contract
