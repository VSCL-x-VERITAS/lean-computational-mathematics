import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Equation07.Signature

/-! Source-facing contract for Equation (3.7). -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Equation (3.7), printed page 52: the Euclidean norm of a standard Gaussian
vector has a dimension-independent sub-Gaussian tail around sqrt(n). -/
theorem hdp_03_eq_3_7 : hdp_03_eq_3_7__contract_type :=
  NumStability.HDP.Vector.Gaussian.standardGaussianEuclideanNormDeviation_tail

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_7__contract : hdp_03_eq_3_7__contract_type :=
  hdp_03_eq_3_7

end NumStability.HDP.Contract
