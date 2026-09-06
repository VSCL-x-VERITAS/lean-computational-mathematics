import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Frozen contract for Remark 2.7.14. -/

noncomputable section

open MeasureTheory ProbabilityTheory Filter

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubGaussian

def hdp_02_hrem_h2_d7_d14__contract_type : Prop :=
  (∀ {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} [IsProbabilityMeasure mu]
    {X : Omega -> Real} {B : Real},
    Measurable X -> 0 < B -> (∀ᵐ omega ∂mu, |X omega| ≤ B) ->
      PsiTwoGauge mu X < (⊤ : ENNReal)) ∧
  (∀ {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} [IsProbabilityMeasure mu]
    {X : Omega -> Real},
    Measurable X -> PsiTwoGauge mu X < (⊤ : ENNReal) ->
      ∀ p : Real, 1 ≤ p -> Integrable (fun omega => |X omega| ^ p) mu)

end NumStability.HDP.Contract
