import ComputationalMathematics.Source.Vershynin.Chapter02.Section06.Exercise05.Signature
import ComputationalMathematics.HDP.Scalar.Khintchine

/-! Stable source-facing wrapper for Exercise 2.6.5. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Exercise 2.6.5: Khintchine's inequality for `p ≥ 2`. -/
theorem hdp_02_hex_h2_d6_d5 :
    hdp_02_hex_h2_d6_d5__contract_type :=
  NumStability.HDP.Scalar.Khintchine.independentSubGaussianKhintchine

/-- Mechanical receipt that the checked wrapper inhabits the frozen target. -/
theorem hdp_02_hex_h2_d6_d5__contract :
    hdp_02_hex_h2_d6_d5__contract_type :=
  hdp_02_hex_h2_d6_d5

end NumStability.HDP.Contract
