import ComputationalMathematics.Source.Vershynin.Chapter03.Section05.Exercise03.Signature

/-! Exercise 3.5.3: the symmetric positive-semidefinite or zero-diagonal
quadratic form satisfies the factor-two Grothendieck bound. -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Optimization

universe u

theorem hdp_03_hex_h3_d5_d3 : hdp_03_hex_h3_d5_d3__contract_type.{u} := by
  intro K hGroth n A hA hcase hquad
  exact symmetricQuadratic_grothendieck_bound K hGroth A hA hcase hquad

set_option linter.style.nameCheck false in
theorem hdp_03_hex_h3_d5_d3__contract :
    hdp_03_hex_h3_d5_d3__contract_type.{u} :=
  hdp_03_hex_h3_d5_d3

end NumStability.HDP.Contract
