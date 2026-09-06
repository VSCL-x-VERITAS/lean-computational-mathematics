import ComputationalMathematics.Source.Vershynin.Chapter02.Section06.Exercise09.Signature
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Stable Chapter 2 source contract for Exercise 2.6.9. -/

noncomputable section

namespace NumStability.HDP.Contract

/-! Exercise 2.6.9: an explicit asymmetric two-point law for which centering
strictly increases the exact finite-law `ψ₂` gauge. -/
theorem hdp_02_hex_h2_d6_d9_exact : hdp_02_hex_h2_d6_d9__contract_type :=
  hdp_02_hex_h2_d6_d9

theorem hdp_02_hex_h2_d6_d9__contract : hdp_02_hex_h2_d6_d9__contract_type := by
  exact hdp_02_hex_h2_d6_d9_exact

end NumStability.HDP.Contract
