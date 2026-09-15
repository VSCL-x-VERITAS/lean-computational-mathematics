import ComputationalMathematics.Source.Vershynin.Chapter02.Section06.Exercise06.Signature
import ComputationalMathematics.HDP.Scalar.KhintchineLowMoments

/-! Stable source-facing wrapper for Exercise 2.6.6. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Exercise 2.6.6: Khintchine's inequality for `p = 1`. -/
theorem hdp_02_hex_h2_d6_d6 :
    hdp_02_hex_h2_d6_d6__contract_type :=
  NumStability.HDP.Scalar.KhintchineLowMoments.independentSubGaussianKhintchineLpOne

/-- Mechanical receipt that the checked wrapper inhabits the frozen target. -/
theorem hdp_02_hex_h2_d6_d6__contract :
    hdp_02_hex_h2_d6_d6__contract_type :=
  hdp_02_hex_h2_d6_d6

end NumStability.HDP.Contract
