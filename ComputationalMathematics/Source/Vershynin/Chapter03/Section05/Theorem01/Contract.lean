import ComputationalMathematics.Source.Vershynin.Chapter03.Section05.Theorem01.Signature

/-! Theorem 3.5.1: one absolute constant bounded by `1.783` controls every
finite real bilinear form satisfying the sign test. -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Optimization

universe u

theorem hdp_03_thm_3_5_1 : hdp_03_thm_3_5_1__contract_type.{u} := by
  refine ⟨NumStability.HDP.Tensor.krivineBeta⁻¹,
    NumStability.HDP.Tensor.inv_krivineBeta_lt_1783_div_1000.le, ?_⟩
  intro m n A hsign
  exact NumStability.HDP.Optimization.isGrothendieckConstant_inv_krivineBeta
    A hsign

set_option linter.style.nameCheck false in
theorem hdp_03_thm_3_5_1__contract : hdp_03_thm_3_5_1__contract_type.{u} :=
  hdp_03_thm_3_5_1

end NumStability.HDP.Contract
