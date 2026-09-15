import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Example12.Signature

/-! Stable Chapter 2 contract for Example 2.7.12. -/

namespace NumStability.HDP.Contract

theorem hdp_02_hexample_h2_d7_d12_exact :
    hdp_02_hexample_h2_d7_d12__contract_type := by
  intro Ω _ μ _ p hp X hX
  exact
    (NumStability.HDP.Scalar.SubExponential.canonicalPowerOrliczCoincidence μ p hp).2 X hX

theorem hdp_02_hexample_h2_d7_d12__contract :
    hdp_02_hexample_h2_d7_d12__contract_type := by
  exact hdp_02_hexample_h2_d7_d12_exact

end NumStability.HDP.Contract
