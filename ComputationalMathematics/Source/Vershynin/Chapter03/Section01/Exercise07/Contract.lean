import ComputationalMathematics.HDP.Vector.SmallBall
import ComputationalMathematics.Source.Vershynin.Chapter03.Section01.Exercise07.Signature

/-! Source-facing contract for Exercise 3.1.7. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Exercise 3.1.7, printed page 44. The coordinate density bound by one is
encoded extensionally as domination of each coordinate law by Lebesgue measure. -/
theorem hdp_03_hex_h3_d1_d7 : hdp_03_hex_h3_d1_d7__contract_type :=
  NumStability.HDP.Vector.SmallBall.euclideanNorm_smallBall

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Exercise 3.1.7 signature. -/
theorem hdp_03_hex_h3_d1_d7__contract :
    hdp_03_hex_h3_d1_d7__contract_type :=
  hdp_03_hex_h3_d1_d7

end NumStability.HDP.Contract
