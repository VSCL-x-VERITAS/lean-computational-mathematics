import ComputationalMathematics.Source.Vershynin.Chapter02.Equation21.Signature

/-! Stable Chapter 2 source contract for Equation (2.21). -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential

/-- Equation (2.21): the `psi_1` gauge is the infimum of its positive finite
scales satisfying the displayed exponential-moment bound. -/
theorem hdp_02_heq_h2_d21_exact :
    ∀ {Omega : Type*} [MeasurableSpace Omega]
      (mu : Measure Omega) (X : Omega -> Real),
      PsiOneGauge mu X = sInf {t : ENNReal | PsiOneAdmissible mu X t} := by
  intro Omega _ mu X
  rfl

theorem hdp_02_heq_h2_d21__contract :
    hdp_02_heq_h2_d21__contract_type :=
  hdp_02_heq_h2_d21_exact

end NumStability.HDP.Contract
