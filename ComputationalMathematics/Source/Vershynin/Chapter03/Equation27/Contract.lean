import ComputationalMathematics.Source.Vershynin.Chapter03.Equation27.Signature

/-! Display (3.27): the explicit numerical arccos bound used by randomized
hyperplane rounding. -/

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_27 : hdp_03_eq_3_27__contract_type := by
  intro t ht
  constructor
  · rw [Real.arccos_eq_pi_div_two_sub_arcsin]
    field_simp [Real.pi_ne_zero]
  · norm_num
    exact NumStability.HDP.Graph.goemansWilliamson_arccos_bound ht

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_27__contract : hdp_03_eq_3_27__contract_type :=
  hdp_03_eq_3_27

end NumStability.HDP.Contract
