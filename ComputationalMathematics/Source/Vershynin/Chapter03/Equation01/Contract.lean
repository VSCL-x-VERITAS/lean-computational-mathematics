import ComputationalMathematics.HDP.Vector.NormConcentration
import ComputationalMathematics.Source.Vershynin.Chapter03.Equation01.Signature

/-! Source-facing contract for Equation (3.1). -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Equation (3.1), printed page 43: the normalized squared Euclidean norm of
a random vector with independent sub-Gaussian coordinates obeys a Bernstein
tail bound at the fourth power of the maximum coordinate `ψ₂` scale. -/
theorem hdp_03_heq_h3_d1 : hdp_03_heq_h3_d1__contract_type :=
  NumStability.HDP.Vector.NormConcentration.normalizedSquaredEuclideanNorm_tail

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Equation (3.1) signature. -/
theorem hdp_03_heq_h3_d1__contract : hdp_03_heq_h3_d1__contract_type :=
  hdp_03_heq_h3_d1

end NumStability.HDP.Contract
