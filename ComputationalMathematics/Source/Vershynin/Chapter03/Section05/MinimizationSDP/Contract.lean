import ComputationalMathematics.Source.Vershynin.Chapter03.Section05.MinimizationSDP.Signature

/-! Section 3.5.1: minimization is maximization of the negated objective. -/

namespace NumStability.HDP.Contract

theorem hdp_03_body_3_5_minimization_sdp :
    hdp_03_body_3_5_minimization_sdp__contract_type := by
  intro n m P
  exact ⟨P.negateObjective_feasible_iff,
    P.negateObjective_value,
    P.isMaximizer_negateObjective_iff_isMinimizer⟩

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_5_minimization_sdp__contract :
    hdp_03_body_3_5_minimization_sdp__contract_type :=
  hdp_03_body_3_5_minimization_sdp

end NumStability.HDP.Contract
