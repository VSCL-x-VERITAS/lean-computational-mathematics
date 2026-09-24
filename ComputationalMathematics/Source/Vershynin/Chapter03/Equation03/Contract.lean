import ComputationalMathematics.HDP.Vector.NormConcentration
import ComputationalMathematics.Source.Vershynin.Chapter03.Equation03.Signature

/-! Source-facing contract for Equation (3.3). -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Equation (3.3), printed page 43: the Euclidean norm deviates from the
square root of the dimension with a sub-Gaussian tail at coordinate scale
`K²`. -/
theorem hdp_03_heq_h3_d3 : hdp_03_heq_h3_d3__contract_type :=
  NumStability.HDP.Vector.NormConcentration.euclideanNormDeviation_tail

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Equation (3.3) signature. -/
theorem hdp_03_heq_h3_d3__contract : hdp_03_heq_h3_d3__contract_type :=
  hdp_03_heq_h3_d3

end NumStability.HDP.Contract
