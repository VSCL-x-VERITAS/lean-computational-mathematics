import ComputationalMathematics.Source.Vershynin.Chapter03.Section04.Exercise07.Signature

/-! Exercise 3.4.7: normalized Lebesgue volume on the Euclidean ball of
radius `sqrt n` is sub-Gaussian with a dimension-free vector `psi_2` norm. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_ex_3_4_7 : hdp_03_ex_3_4_7__contract_type :=
  NumStability.HDP.Vector.UniformBall.uniformSqrtDimensionBall_isSubGaussian_psiTwoNorm_le

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_4_7__contract : hdp_03_ex_3_4_7__contract_type :=
  hdp_03_ex_3_4_7

end NumStability.HDP.Contract
