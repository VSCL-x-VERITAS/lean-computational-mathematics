import ComputationalMathematics.Source.Vershynin.Chapter02.Section06.Theorem03.Signature
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Stable Chapter 2 forwarding module for Theorem 2.6.3. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_02_hthm_h2_d6_d3__contract
    : hdp_02_hthm_h2_d6_d3__contract_type := by
  intro ι Ω instFintype instMeasurableSpace μ instProbability X K hK hX hIndep a hEnergy t ht
  exact NumStability.HDP.Contract.hdp_02_hthm_h2_d6_d3
    hK hX hIndep hEnergy ht

end NumStability.HDP.Contract
