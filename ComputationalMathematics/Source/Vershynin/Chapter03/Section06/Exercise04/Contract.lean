import ComputationalMathematics.Source.Vershynin.Chapter03.Section06.Exercise04.Signature

/-! Exercise 3.6.4: repeated random cuts give a Las Vegas approximation. -/

namespace NumStability.HDP.Contract

theorem hdp_03_ex_3_6_4 : hdp_03_ex_3_6_4__contract_type := by
  intro V _ _ G _ ε hε
  refine ⟨fun n x ↦
      NumStability.HDP.Graph.repeatedUniformCutOutputPMF_nonneg G ε n x, ?_,
    fun n x hx ↦
      NumStability.HDP.Graph.repeatedUniformCutOutputPMF_ne_zero_implies_approximation
        G ε n x hx, ?_⟩
  · rw [NumStability.HDP.Graph.tsum_sum_repeatedUniformCutOutputPMF,
      NumStability.HDP.Graph.geometricTotalProbability_uniformBoolEdge_eq_one G hε]
  · rw [NumStability.HDP.Graph.tsum_weighted_repeatedUniformCutOutputPMF]
    exact NumStability.HDP.Graph.geometricExpectedAttempts_uniformBoolEdge_le G hε

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_6_4__contract : hdp_03_ex_3_6_4__contract_type :=
  hdp_03_ex_3_6_4

end NumStability.HDP.Contract
