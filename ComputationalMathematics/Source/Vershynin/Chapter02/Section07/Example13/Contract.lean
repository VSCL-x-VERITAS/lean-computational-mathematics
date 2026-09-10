import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Example13.Signature

/-! Stable Chapter 2 contract for Example 2.7.13. -/

namespace NumStability.HDP.Contract

open MeasureTheory

theorem hdp_02_hexample_h2_d7_d13_exact :
    hdp_02_hexample_h2_d7_d13__contract_type := by
  intro Ω _ μ _ X hX
  exact ⟨
    NumStability.HDP.Scalar.SubExponential.psiTwoOrliczGauge_eq_psiTwoGauge hX,
    NumStability.HDP.Scalar.SubExponential.psiTwoOrliczMember_iff_psiTwoMember hX⟩

theorem hdp_02_hexample_h2_d7_d13__contract :
    hdp_02_hexample_h2_d7_d13__contract_type := by
  exact hdp_02_hexample_h2_d7_d13_exact

end NumStability.HDP.Contract
