import ComputationalMathematics.Source.Vershynin.Chapter03.Equation24.Signature

/-! Display (3.24): maximum cut as maximization over sign labelings. -/

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_24 : hdp_03_eq_3_24__contract_type := by
  intro n G _
  exact ⟨NumStability.HDP.Graph.exists_signCutValue_eq_maxCut G,
    NumStability.HDP.Graph.signCutValue_le_maxCut G⟩

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_24__contract : hdp_03_eq_3_24__contract_type :=
  hdp_03_eq_3_24

end NumStability.HDP.Contract
