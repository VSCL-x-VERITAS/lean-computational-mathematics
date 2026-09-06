import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Frozen contract signature for the finite independent sub-Gaussian sum

This file is intentionally proof-free.  The semantic theorem and stable alias
are checked against this exact proposition by the contract wrapper.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Contract

def hdp_02_hprop_h2_d6_d1__contract_type : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      {X : ι → Ω → ℝ},
      (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
      (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
      iIndepFun X μ →
        NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
            (fun ω => ∑ i, X i ω) ∧
          (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
              (fun ω => ∑ i, X i ω)).toReal ^ 2 ≤
            C * ∑ i,
              (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
                (X i)).toReal ^ 2

end NumStability.HDP.Contract
