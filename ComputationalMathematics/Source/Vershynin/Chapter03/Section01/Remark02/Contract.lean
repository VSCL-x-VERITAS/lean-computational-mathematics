import ComputationalMathematics.HDP.Vector.NormConcentration
import ComputationalMathematics.Source.Vershynin.Chapter03.Section01.Remark02.Signature

/-! Source-facing contract for Remark 3.1.2. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Remark 3.1.2, printed page 43: the random vector lies outside a shell of
dimension-free width `C K²` around the sphere of radius `√n` with probability
at most `0.01`, while its squared Euclidean norm has mean `n`. -/
theorem hdp_03_hrem_h3_d1_d2 : hdp_03_hrem_h3_d1_d2__contract_type :=
  NumStability.HDP.Vector.NormConcentration.shellProbability_and_squaredNormMean

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Remark 3.1.2 signature. -/
theorem hdp_03_hrem_h3_d1_d2__contract :
    hdp_03_hrem_h3_d1_d2__contract_type :=
  hdp_03_hrem_h3_d1_d2

end NumStability.HDP.Contract
