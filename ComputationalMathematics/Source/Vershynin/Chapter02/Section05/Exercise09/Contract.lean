import ComputationalMathematics.Source.Vershynin.Chapter02.Section05.Exercise09.Signature
import ComputationalMathematics.HDP.Scalar.NonSubGaussian

/-! Stable Chapter 2 source-facing wrapper for Exercise 2.5.9. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_02_hex_h2_d5_d9 : hdp_02_hex_h2_d5_d9__contract_type := by
  unfold hdp_02_hex_h2_d5_d9__contract_type
  exact ⟨NumStability.HDP.Scalar.SubGaussian.poissonPsiTwoGauge_eq_top,
    NumStability.HDP.Scalar.SubGaussian.exponentialPsiTwoGauge_eq_top_of_pos,
    NumStability.HDP.Scalar.SubGaussian.paretoPsiTwoGauge_eq_top,
    NumStability.HDP.Scalar.SubGaussian.cauchyLocationScalePsiTwoGauge_eq_top⟩

end NumStability.HDP.Contract
