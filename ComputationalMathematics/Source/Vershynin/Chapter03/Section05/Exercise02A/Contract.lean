import ComputationalMathematics.Source.Vershynin.Chapter03.Section05.Exercise02A.Signature

/-! Exercise 3.5.2(a): the sign-cube and max-coordinate-norm formulations of
the bilinear hypothesis are equivalent. -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Optimization

theorem hdp_03_hex_h3_d5_d2a : hdp_03_hex_h3_d5_d2a__contract_type := by
  intro m n A
  exact signBound_iff_normBound A

set_option linter.style.nameCheck false in
theorem hdp_03_hex_h3_d5_d2a__contract : hdp_03_hex_h3_d5_d2a__contract_type :=
  hdp_03_hex_h3_d5_d2a

end NumStability.HDP.Contract
