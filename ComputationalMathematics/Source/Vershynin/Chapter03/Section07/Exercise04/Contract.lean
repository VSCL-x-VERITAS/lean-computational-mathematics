import ComputationalMathematics.Source.Vershynin.Chapter03.Section07.Exercise04.Signature

/-! Exercise 3.7.4: the inner product of two rank-one tensor powers is
the corresponding vector inner product raised to that power. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_ex_3_7_4 : hdp_03_ex_3_7_4__contract_type := by
  intro n u v k
  exact NumStability.HDP.Tensor.inner_power_power u v k

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_7_4__contract : hdp_03_ex_3_7_4__contract_type :=
  hdp_03_ex_3_7_4

end NumStability.HDP.Contract
