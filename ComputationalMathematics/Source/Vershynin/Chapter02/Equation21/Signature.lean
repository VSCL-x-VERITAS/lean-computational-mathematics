import ComputationalMathematics.HDP.Scalar.SubExponential

/-! Frozen contract for Equation (2.21). -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential

def hdp_02_heq_h2_d21__contract_type : Prop :=
  ∀ {Omega : Type*} [MeasurableSpace Omega]
    (mu : Measure Omega) (X : Omega -> Real),
    PsiOneGauge mu X = sInf {t : ENNReal | PsiOneAdmissible mu X t}

end NumStability.HDP.Contract
