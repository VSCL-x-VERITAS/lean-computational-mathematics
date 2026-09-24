import ComputationalMathematics.Source.Vershynin.Chapter03.Section04.Exercise10.Signature

/-! Exercise 3.4.10: without coordinate independence, an isotropic
sub-Gaussian vector need not have dimension-free concentration of its norm. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_ex_3_4_10 : hdp_03_ex_3_4_10__contract_type :=
  NumStability.HDP.Vector.IsotropicSubGaussianNonConcentration.exists_isotropicSubGaussian_nonconcentrated

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_4_10__contract : hdp_03_ex_3_4_10__contract_type :=
  hdp_03_ex_3_4_10

end NumStability.HDP.Contract
