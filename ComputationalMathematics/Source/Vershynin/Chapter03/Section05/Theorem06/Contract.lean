import ComputationalMathematics.Source.Vershynin.Chapter03.Section05.Theorem06.Signature

/-! Theorem 3.5.6: the sign optimum of a symmetric positive-semidefinite
quadratic form is within factor `2 * K` of its unit-vector relaxation. -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Optimization

theorem hdp_03_thm_3_5_6 : hdp_03_thm_3_5_6__contract_type := by
  intro K hGroth n _ A _hSymm hA
  exact grothendieck_relaxation_guarantee K hGroth A hA

set_option linter.style.nameCheck false in
theorem hdp_03_thm_3_5_6__contract : hdp_03_thm_3_5_6__contract_type :=
  hdp_03_thm_3_5_6

end NumStability.HDP.Contract
