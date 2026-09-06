import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Frozen contract signature for Remark 2.5.3

This proof-free source contract records the Chapter 2 remark independently of
its semantic implementation.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

def hdp_02_hrem_h2_d5_d3__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (A : ℝ) (hA : 1 < A),
    ((∃ K : ℝ, 0 < K ∧
        NumStability.HDP.Scalar.SubGaussian.SubGaussianTailBoundWithThreshold μ X K 2) ↔
      ∃ K : ℝ, 0 < K ∧
        NumStability.HDP.Scalar.SubGaussian.SubGaussianTailBoundWithThreshold μ X K A) ∧
    ((∃ K : ℝ, 0 < K ∧
        NumStability.HDP.Scalar.SubGaussian.SubGaussianSquarePointWithThreshold μ X K 2) ↔
      ∃ K : ℝ, 0 < K ∧
        NumStability.HDP.Scalar.SubGaussian.SubGaussianSquarePointWithThreshold μ X K A)

end NumStability.HDP.Contract
