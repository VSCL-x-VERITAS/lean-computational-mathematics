import ComputationalMathematics.HDP.Scalar.SubExponential

/-!
# Frozen contract signature for the centered-square estimate in Theorem 3.1.1
-/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_1_square_centering__contract_type : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    ∀ {Ω : Type*} [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      {X : Ω → ℝ},
      Measurable X →
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞ →
          (∫ ω, X ω ^ 2 ∂μ) = 1 →
            NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ
                (fun ω => X ω ^ 2 - 1) ≤
              ENNReal.ofReal C *
                NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ^ 2

end NumStability.HDP.Contract
