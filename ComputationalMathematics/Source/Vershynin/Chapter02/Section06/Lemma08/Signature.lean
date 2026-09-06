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
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind)
    {K : ℝ} (hK : 0 < K)
    (hProp : NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K),
    ∃ C : ℝ, 1 ≤ C ∧
      Integrable X μ ∧
      ∃ K' : ℝ, 0 < K' ∧ K' ≤ C * K ∧
        NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ
            (fun ω => X ω - ∫ x, X x ∂μ) .squarePoint K' ∧
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun ω => X ω - ∫ x, X x ∂μ) ≤
          ENNReal.ofReal (C * K)

end NumStability.HDP.Contract
