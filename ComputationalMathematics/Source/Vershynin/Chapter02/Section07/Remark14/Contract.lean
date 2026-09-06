import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Remark14.Signature

/-! Stable Chapter 2 source contract for Remark 2.7.14. -/

noncomputable section

open MeasureTheory ProbabilityTheory Filter

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubGaussian

/-- Remark 2.7.14: essentially bounded random variables are sub-gaussian, and
sub-gaussian random variables have every finite absolute moment. -/
theorem hdp_02_hrem_h2_d7_d14_exact :
    (∀ {Omega : Type*} [MeasurableSpace Omega]
      {mu : Measure Omega} [IsProbabilityMeasure mu]
      {X : Omega -> Real} {B : Real},
      Measurable X -> 0 < B -> (∀ᵐ omega ∂mu, |X omega| ≤ B) ->
        PsiTwoGauge mu X < (⊤ : ENNReal)) ∧
    (∀ {Omega : Type*} [MeasurableSpace Omega]
      {mu : Measure Omega} [IsProbabilityMeasure mu]
      {X : Omega -> Real},
      Measurable X -> PsiTwoGauge mu X < (⊤ : ENNReal) ->
        ∀ p : Real, 1 ≤ p -> Integrable (fun omega => |X omega| ^ p) mu) := by
  constructor
  · intro Omega _ mu _ X B hX hB hBound
    exact (essentiallyBoundedPsiTwoGauge hX hB hBound).trans_lt ENNReal.ofReal_lt_top
  · intro Omega _ mu _ X hX hFinite p hp
    exact (psiTwoGaugeToLpMomentGrowth hX hFinite).2 p hp |>.1

theorem hdp_02_hrem_h2_d7_d14__contract :
    hdp_02_hrem_h2_d7_d14__contract_type :=
  hdp_02_hrem_h2_d7_d14_exact

end NumStability.HDP.Contract
