import ComputationalMathematics.Source.Vershynin.Chapter03.Section06.Theorem05.Signature

/-! Theorem 3.6.5: the `0.878` Gaussian hyperplane-rounding approximation
chain for maximum cut. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_thm_3_6_5 : hdp_03_thm_3_6_5__contract_type := by
  intro n G _ X hX
  exact NumStability.HDP.Graph.goemansWilliamson_approximation_of_optimizer G X hX

set_option linter.style.nameCheck false in
theorem hdp_03_thm_3_6_5__contract : hdp_03_thm_3_6_5__contract_type :=
  hdp_03_thm_3_6_5

end NumStability.HDP.Contract
