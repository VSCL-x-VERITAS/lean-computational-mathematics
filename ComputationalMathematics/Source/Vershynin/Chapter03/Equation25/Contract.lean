import ComputationalMathematics.Source.Vershynin.Chapter03.Equation25.Signature

/-! Display (3.25): the attained unit-vector semidefinite relaxation of maximum cut. -/

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_25 : hdp_03_eq_3_25__contract_type := by
  intro n G _
  obtain ⟨X, hX⟩ :=
    NumStability.HDP.Graph.exists_maxCutSemidefiniteValue_eq_optimalValue
      (G.adjMatrix ℝ)
  exact ⟨X, hX,
    NumStability.HDP.Graph.maxCutSemidefiniteValue_le_optimalValue (G.adjMatrix ℝ)⟩

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_25__contract : hdp_03_eq_3_25__contract_type :=
  hdp_03_eq_3_25

end NumStability.HDP.Contract
