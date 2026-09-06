import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Lemma07.Signature

/-! Stable Chapter 2 source contract for Lemma 2.7.7. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar

/-- Lemma 2.7.7: the product of two sub-gaussian random variables is
sub-exponential, with the displayed product bound on the gauges. -/
theorem hdp_02_hlem_h2_d7_d7_exact :
    ∀ {Omega : Type*} [MeasurableSpace Omega]
      {mu : Measure Omega} [IsProbabilityMeasure mu] {X Y : Omega -> Real},
      SubGaussian.PsiTwoGauge mu X < (⊤ : ENNReal) ->
        SubGaussian.PsiTwoGauge mu Y < (⊤ : ENNReal) ->
          SubExponential.PsiOneGauge mu (fun omega => X omega * Y omega) < (⊤ : ENNReal) ∧
            SubExponential.PsiOneGauge mu (fun omega => X omega * Y omega) ≤
              SubGaussian.PsiTwoGauge mu X * SubGaussian.PsiTwoGauge mu Y := by
  intro Omega _ mu _ X Y hX hY
  exact hdp_02_hlem_h2_d7_d7 hX hY

theorem hdp_02_hlem_h2_d7_d7__contract :
    hdp_02_hlem_h2_d7_d7__contract_type :=
  hdp_02_hlem_h2_d7_d7_exact

end NumStability.HDP.Contract
