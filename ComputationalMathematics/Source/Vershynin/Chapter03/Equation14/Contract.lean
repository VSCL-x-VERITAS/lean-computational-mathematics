import ComputationalMathematics.Source.Vershynin.Chapter03.Equation14.Signature

/-! Display (3.14): Euclidean inner products realized as correlations of
standard-Gaussian linear marginals. -/

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_14 : hdp_03_eq_3_14__contract_type := by
  intro m n A
  exact NumStability.HDP.Optimization.bipartiteUnitMaximum_gaussian_identity A

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_14__contract : hdp_03_eq_3_14__contract_type :=
  hdp_03_eq_3_14

end NumStability.HDP.Contract
