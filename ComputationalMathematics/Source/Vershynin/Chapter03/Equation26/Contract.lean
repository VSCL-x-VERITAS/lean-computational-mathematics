import ComputationalMathematics.Source.Vershynin.Chapter03.Equation26.Signature

/-! Display (3.26): randomized hyperplane labels after choosing the normal vector. -/

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_26 : hdp_03_eq_3_26__contract_type := by
  intro n X g i
  constructor
  · exact NumStability.HDP.Graph.hyperplaneSign_value (X i) g
  · intro h
    exact NumStability.HDP.Graph.hyperplaneSign_value_eq_real_sign (X i) g h

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_26__contract : hdp_03_eq_3_26__contract_type :=
  hdp_03_eq_3_26

end NumStability.HDP.Contract
