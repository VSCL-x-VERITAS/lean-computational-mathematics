import ComputationalMathematics.HDP.Scalar.SubExponential

/-! Frozen contract for Lemma 2.7.6. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar

def hdp_02_hlem_h2_d7_d6__contract_type : Prop :=
  ∀ {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} [IsProbabilityMeasure mu] {X : Omega -> Real},
    Measurable X ->
      (SubExponential.PsiOneGauge mu (fun omega => X omega ^ 2) < (⊤ : ENNReal) ↔
          SubGaussian.PsiTwoGauge mu X < (⊤ : ENNReal)) ∧
        SubExponential.PsiOneGauge mu (fun omega => X omega ^ 2) =
          SubGaussian.PsiTwoGauge mu X ^ 2

end NumStability.HDP.Contract
