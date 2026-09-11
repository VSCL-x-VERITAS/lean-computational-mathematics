import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Exercise10.Signature
import ComputationalMathematics.HDP.Scalar.SubExponentialCentering

/-! Stable Chapter 2 contract module for Exercise 2.7.10. -/

namespace NumStability.HDP.Contract

open MeasureTheory
open scoped ENNReal

theorem hdp_02_hex_h2_d7_d10_exact : hdp_02_hex_h2_d7_d10__contract_type :=
  NumStability.HDP.Scalar.SubExponential.centeredSubExponentialPsiOneNorm_uniform

theorem hdp_02_hex_h2_d7_d10__contract : hdp_02_hex_h2_d7_d10__contract_type := by
  exact hdp_02_hex_h2_d7_d10_exact

end NumStability.HDP.Contract
