import ComputationalMathematics.Source.Vershynin.Chapter03.Section06.Proposition03.Signature

/-! Proposition 3.6.3: the uniform random cut is a one-half approximation. -/

namespace NumStability.HDP.Contract

theorem hdp_03_prop_3_6_3 : hdp_03_prop_3_6_3__contract_type := by
  intro V _ _ G _
  exact ⟨NumStability.HDP.Graph.uniformBoolCutExpectation_eq_half_edges G,
    NumStability.HDP.Graph.half_maxCut_le_uniformBoolCutExpectation G⟩

set_option linter.style.nameCheck false in
theorem hdp_03_prop_3_6_3__contract : hdp_03_prop_3_6_3__contract_type :=
  hdp_03_prop_3_6_3

end NumStability.HDP.Contract
