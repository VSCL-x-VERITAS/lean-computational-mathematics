import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Frozen contract signature for Definition 2.5.6. -/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_02_hdef_h2_d5_d6__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (_hX : Measurable X),
    (∀ i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
      i ≠ .linearMGF →
        (NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ X ↔
          ∃ K : ℝ, 0 < K ∧
            NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K)) ∧
      (NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ X →
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ X < (⊤ : ENNReal) ∧
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ X =
            sInf {t : ℝ≥0∞ |
              NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ X t})

end NumStability.HDP.Contract
