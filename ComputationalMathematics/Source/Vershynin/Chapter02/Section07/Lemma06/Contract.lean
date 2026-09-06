import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Lemma06.Signature

/-! Stable Chapter 2 source contract for Lemma 2.7.6. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar

/-- Lemma 2.7.6: squaring identifies sub-gaussian variables with
sub-exponential variables and squares the corresponding Orlicz gauge. -/
theorem hdp_02_hlem_h2_d7_d6_exact :
    ∀ {Omega : Type*} [MeasurableSpace Omega]
      {mu : Measure Omega} [IsProbabilityMeasure mu] {X : Omega -> Real},
      Measurable X ->
        (SubExponential.PsiOneGauge mu (fun omega => X omega ^ 2) < (⊤ : ENNReal) ↔
            SubGaussian.PsiTwoGauge mu X < (⊤ : ENNReal)) ∧
          SubExponential.PsiOneGauge mu (fun omega => X omega ^ 2) =
            SubGaussian.PsiTwoGauge mu X ^ 2 := by
  intro Omega _ mu _ X hX
  exact hdp_02_hlem_h2_d7_d6 hX

theorem hdp_02_hlem_h2_d7_d6__contract :
    hdp_02_hlem_h2_d7_d6__contract_type :=
  hdp_02_hlem_h2_d7_d6_exact

end NumStability.HDP.Contract
