import ComputationalMathematics.Source.Vershynin.Chapter03.Section07.PowerKernelFeature.Signature

/-! Section 3.7: tensor powers provide Hilbert-space feature maps for power
kernels. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_body_3_7_power_kernel_feature :
    hdp_03_body_3_7_power_kernel_feature__contract_type := by
  intro n k
  exact ⟨NumStability.HDP.Tensor.powerFeature k,
    fun _ => rfl,
    NumStability.HDP.Tensor.powerFeature_inner k⟩

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_7_power_kernel_feature__contract :
    hdp_03_body_3_7_power_kernel_feature__contract_type :=
  hdp_03_body_3_7_power_kernel_feature

end NumStability.HDP.Contract
