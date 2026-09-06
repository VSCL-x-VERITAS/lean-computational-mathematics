import ComputationalMathematics.HDP.Scalar.SubExponential

/-! Frozen contract for Lemma 2.7.7. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar

def hdp_02_hlem_h2_d7_d7__contract_type : Prop :=
  ∀ {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} [IsProbabilityMeasure mu] {X Y : Omega -> Real},
    SubGaussian.PsiTwoGauge mu X < (⊤ : ENNReal) ->
      SubGaussian.PsiTwoGauge mu Y < (⊤ : ENNReal) ->
        SubExponential.PsiOneGauge mu (fun omega => X omega * Y omega) < (⊤ : ENNReal) ∧
          SubExponential.PsiOneGauge mu (fun omega => X omega * Y omega) ≤
            SubGaussian.PsiTwoGauge mu X * SubGaussian.PsiTwoGauge mu Y

end NumStability.HDP.Contract
