import ComputationalMathematics.HDP.Scalar.SubExponentialPropertyThreeGauge

/-! Frozen contract for Definition 2.7.5. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential

def hdp_02_hdef_h2_d7_d5__contract_type : Prop :=
  ∀ {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} [IsProbabilityMeasure mu] {X : Omega -> Real},
    (PsiOnePropertyThreeGauge mu X < (⊤ : ENNReal) ↔
      ∃ i : SubExponentialPropertyKind, ∃ K : Real,
        0 < K ∧ SubExponentialProperty mu X i K) ∧
      PsiOnePropertyThreeGauge mu X =
        sInf {t : ENNReal | PsiOnePropertyThreeAdmissible mu X t}

end NumStability.HDP.Contract
