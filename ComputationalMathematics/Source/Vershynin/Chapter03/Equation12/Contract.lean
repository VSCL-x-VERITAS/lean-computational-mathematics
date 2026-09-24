import ComputationalMathematics.Source.Vershynin.Chapter03.Equation12.Signature

/-! Display (3.12): the bilinear sign bound extends by homogeneity and the
coordinate-cube extreme-point argument to arbitrary real vectors. -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Optimization

theorem hdp_03_eq_3_12 : hdp_03_eq_3_12__contract_type := by
  intro m n A hsign x y
  exact bilinearValue_le_norm_mul_norm_of_sign A hsign x y

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_12__contract : hdp_03_eq_3_12__contract_type :=
  hdp_03_eq_3_12

end NumStability.HDP.Contract
