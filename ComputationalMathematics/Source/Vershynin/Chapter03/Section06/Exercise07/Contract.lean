import ComputationalMathematics.Source.Vershynin.Chapter03.Section06.Exercise07.Signature

/-! Exercise 3.6.7: the Gaussian separation probability is angle divided by
`π`. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_ex_3_6_7 : hdp_03_ex_3_6_7__contract_type := by
  intro n u v hu hv
  exact NumStability.HDP.Graph.gaussianHyperplaneOppositeProbability_eq_angle_div_pi
    u v hu hv

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_6_7__contract : hdp_03_ex_3_6_7__contract_type :=
  hdp_03_ex_3_6_7

end NumStability.HDP.Contract
