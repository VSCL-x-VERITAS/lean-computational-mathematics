import ComputationalMathematics.Source.Vershynin.Chapter03.Section04.FiniteSupportSubGaussian.Signature

/-! Section 3.4.2: every finite-support random-vector distribution is
sub-Gaussian. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_body_3_4_finite_support_subgaussian :
    hdp_03_body_3_4_finite_support_subgaussian__contract_type := by
  intro Ω _ n μ _ X hMeas hRange
  exact NumStability.HDP.Vector.SubGaussian.finiteSupport_vectorSubGaussian
    hMeas hRange

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_4_finite_support_subgaussian__contract :
    hdp_03_body_3_4_finite_support_subgaussian__contract_type :=
  hdp_03_body_3_4_finite_support_subgaussian

end NumStability.HDP.Contract
