import ComputationalMathematics.Source.Vershynin.Chapter03.Equation11.Signature

/-! Equation (3.11): the lower half-radius event for a standard Gaussian
vector has probability at most `2 exp (-c n)`. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_11 : hdp_03_eq_3_11__contract_type :=
  NumStability.HDP.Vector.Gaussian.standardGaussianEuclideanNorm_lowerHalf_tail

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_11__contract : hdp_03_eq_3_11__contract_type :=
  hdp_03_eq_3_11

end NumStability.HDP.Contract
