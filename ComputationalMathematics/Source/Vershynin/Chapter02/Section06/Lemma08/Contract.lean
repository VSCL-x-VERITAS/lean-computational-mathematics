import ComputationalMathematics.Source.Vershynin.Chapter02.Section06.Lemma08.Signature
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Stable Chapter 2 contract module for the sub-Gaussian centering lemma. -/

namespace NumStability.HDP.Contract

theorem hdp_02_hlem_h2_d6_d8__contract
    : hdp_02_hlem_h2_d6_d8__contract_type := by
  intro Ω instΩ μ instμ X i K hK hProp
  exact NumStability.HDP.Contract.hdp_02_hlem_h2_d6_d8 i hK hProp

end NumStability.HDP.Contract
