import ComputationalMathematics.Source.Vershynin.Chapter03.Section07.MooreAronszajn.Signature

/-! Section 3.7.1: positive-semidefinite kernels admit the canonical RKHS
construction, unique up to isometry under the dense-span assumption. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_body_3_7_moore_aronszajn :
    hdp_03_body_3_7_moore_aronszajn__contract_type := by
  intro X K
  constructor
  · exact
      NumStability.HDP.Kernel.isPositiveSemidefinite_iff_exists_hilbert_reproducingKernel K
  · intro H₁ H₂ normH₁ innerH₁ completeH₁ normH₂ innerH₂ completeH₂ Φ₁ Φ₂ h₁ h₂
    letI : NormedAddCommGroup H₁ := normH₁
    letI : InnerProductSpace ℝ H₁ := innerH₁
    letI : CompleteSpace H₁ := completeH₁
    letI : NormedAddCommGroup H₂ := normH₂
    letI : InnerProductSpace ℝ H₂ := innerH₂
    letI : CompleteSpace H₂ := completeH₂
    exact NumStability.HDP.Kernel.reproducingKernelPresentation_unique h₁ h₂

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_7_moore_aronszajn__contract :
    hdp_03_body_3_7_moore_aronszajn__contract_type :=
  hdp_03_body_3_7_moore_aronszajn

end NumStability.HDP.Contract
