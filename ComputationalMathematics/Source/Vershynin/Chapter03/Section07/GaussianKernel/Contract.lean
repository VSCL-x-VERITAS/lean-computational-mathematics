import ComputationalMathematics.Source.Vershynin.Chapter03.Section07.GaussianKernel.Signature

/-! Section 3.7.1: the Gaussian radial-basis kernel is positive semidefinite. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_body_3_7_gaussian_kernel :
    hdp_03_body_3_7_gaussian_kernel__contract_type := by
  intro n σ hσ
  exact NumStability.HDP.Kernel.gaussianKernel_isPositiveSemidefinite σ hσ

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_7_gaussian_kernel__contract :
    hdp_03_body_3_7_gaussian_kernel__contract_type :=
  hdp_03_body_3_7_gaussian_kernel

end NumStability.HDP.Contract
