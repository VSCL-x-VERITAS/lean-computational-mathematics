import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Stable Chapter 2 forwarding declaration for the standard-normal MGF. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory

namespace NumStability.HDP.Contract

theorem hdp_02_heq_h2_d12 (lam : ℝ) :
    ∫ x, Real.exp (lam * x) ∂(gaussianReal 0 1) =
      Real.exp (lam ^ 2 / 2) :=
  NumStability.HDP.Scalar.SubGaussian.standardNormalMGF lam

end NumStability.HDP.Contract
