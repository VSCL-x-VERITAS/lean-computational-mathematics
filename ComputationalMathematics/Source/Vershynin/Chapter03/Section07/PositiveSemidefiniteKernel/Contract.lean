import ComputationalMathematics.Source.Vershynin.Chapter03.Section07.PositiveSemidefiniteKernel.Signature

/-! Section 3.7.1: a positive-semidefinite kernel is one whose finite Gram
matrices are positive semidefinite. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_body_3_7_psd_kernel_def :
    hdp_03_body_3_7_psd_kernel_def__contract_type := by
  intro X K
  exact NumStability.HDP.Kernel.isPositiveSemidefinite_iff K

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_7_psd_kernel_def__contract :
    hdp_03_body_3_7_psd_kernel_def__contract_type :=
  hdp_03_body_3_7_psd_kernel_def

end NumStability.HDP.Contract
