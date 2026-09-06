import ComputationalMathematics.Source.Vershynin.Chapter02.Section06.Lemma08.Signature
import ComputationalMathematics.HDP.Scalar.SubGaussianCentering

/-! Stable Chapter 2 contract module for the sub-Gaussian centering lemma. -/

namespace NumStability.HDP.Contract

open MeasureTheory

/-! Exact source-facing Chapter 2 alias for Lemma 2.6.8.  The older
`hdp_02_hlem_h2_d6_d8` declaration remains in `Scalar.SubGaussian` as a
compatibility theorem for callers using an arbitrary property witness. -/
theorem hdp_02_hlem_h2_d6_d8_exact :
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
              NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ X :=
  NumStability.HDP.Scalar.SubGaussian.centeredSubGaussianPsiTwoNorm_uniform

theorem hdp_02_hlem_h2_d6_d8__contract
    : hdp_02_hlem_h2_d6_d8__contract_type := by
  exact hdp_02_hlem_h2_d6_d8_exact

end NumStability.HDP.Contract
