import ComputationalMathematics.Source.Vershynin.Chapter03.Section04.BernoulliSubGaussian.Signature

/-! Section 3.4.1: the multivariate symmetric Bernoulli distribution is
sub-Gaussian with a dimension-free vector `ψ₂` norm. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_body_3_4_bernoulli_subgaussian :
    hdp_03_body_3_4_bernoulli_subgaussian__contract_type :=
  NumStability.HDP.Vector.Bernoulli.discreteCube_isSubGaussian_psiTwoNorm_le

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_4_bernoulli_subgaussian__contract :
    hdp_03_body_3_4_bernoulli_subgaussian__contract_type :=
  hdp_03_body_3_4_bernoulli_subgaussian

end NumStability.HDP.Contract
