import ComputationalMathematics.Source.Vershynin.Chapter02.Section06.Exercise07.Signature
import ComputationalMathematics.HDP.Scalar.KhintchinePositiveMoments

/-! Stable source-facing wrapper for Exercise 2.6.7. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Exercise 2.6.7: a Khintchine inequality for every `0 < p < 2`. -/
theorem hdp_02_hex_h2_d6_d7 :
    hdp_02_hex_h2_d6_d7__contract_type :=
  NumStability.HDP.Scalar.KhintchinePositiveMoments.independentSubGaussianKhintchinePosLtTwo

/-- Mechanical receipt that the checked wrapper inhabits the frozen target. -/
theorem hdp_02_hex_h2_d6_d7__contract :
    hdp_02_hex_h2_d6_d7__contract_type :=
  hdp_02_hex_h2_d6_d7

end NumStability.HDP.Contract
