import ComputationalMathematics.Source.Vershynin.Chapter03.Section04.StandardGaussianSubGaussian.Signature

/-! Section 3.4.1: the standard normal vector is sub-Gaussian with a
dimension-free vector `ψ₂` norm. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_body_3_4_gaussian_subgaussian :
    hdp_03_body_3_4_gaussian_subgaussian__contract_type := by
  refine ⟨2, by norm_num, ?_⟩
  intro n _hn
  exact NumStability.HDP.Vector.Gaussian.standardGaussianVector_isSubGaussian_psiTwoNorm_le_two n

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_4_gaussian_subgaussian__contract :
    hdp_03_body_3_4_gaussian_subgaussian__contract_type :=
  hdp_03_body_3_4_gaussian_subgaussian

end NumStability.HDP.Contract
