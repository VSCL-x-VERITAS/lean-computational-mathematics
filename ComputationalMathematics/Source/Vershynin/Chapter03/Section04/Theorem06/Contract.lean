import ComputationalMathematics.Source.Vershynin.Chapter03.Section04.Theorem06.Signature

/-! Theorem 3.4.6: the uniform law on the sphere of radius `sqrt n` is
sub-Gaussian with a dimension-free vector `psi_2` norm. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_thm_3_4_6 : hdp_03_thm_3_4_6__contract_type :=
  NumStability.HDP.Vector.Spherical.sphericalVector_isSubGaussian_psiTwoNorm_le

set_option linter.style.nameCheck false in
theorem hdp_03_thm_3_4_6__contract : hdp_03_thm_3_4_6__contract_type :=
  hdp_03_thm_3_4_6

end NumStability.HDP.Contract
