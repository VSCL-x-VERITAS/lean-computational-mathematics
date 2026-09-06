import ComputationalMathematics.Source.Vershynin.Chapter02.Section06.Proposition01.Signature
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Stable Chapter 2 contract module for the finite independent
    sub-Gaussian sum proposition. -/

namespace NumStability.HDP.Contract

theorem hdp_02_hprop_h2_d6_d1__contract
    : hdp_02_hprop_h2_d6_d1__contract_type := by
  intro ι Ω instι instΩ μ instμ X K hX hIndep hEnergy
  exact NumStability.HDP.Contract.hdp_02_hprop_h2_d6_d1
    hX hIndep hEnergy

end NumStability.HDP.Contract
