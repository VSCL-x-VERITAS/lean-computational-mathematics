import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Frozen contract signature for the sub-Gaussian centering lemma

This file is intentionally proof-free.  The semantic theorem and stable alias
are checked against this exact proposition by the contract wrapper.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

def hdp_02_hlem_h2_d6_d8__contract_type : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    ∀ {Ω : Type*} [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      {X : Ω → ℝ},
      NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ X →
        NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
            (fun ω => X ω - ∫ x, X x ∂μ) ∧
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
            (fun ω => X ω - ∫ x, X x ∂μ) ≤
          ENNReal.ofReal C *
            NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ X

end NumStability.HDP.Contract
