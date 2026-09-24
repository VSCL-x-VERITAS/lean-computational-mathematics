import ComputationalMathematics.Source.Vershynin.Chapter03.Section07.Exercise05A.Signature

/-! Exercise 3.7.5(a): a direct sum of scaled second and third tensor powers
realizes the kernel `2 ⟪u,v⟫² + 5 ⟪u,v⟫³`. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_ex_3_7_5a : hdp_03_ex_3_7_5a__contract_type := by
  intro n u v
  exact NumStability.HDP.Tensor.quadraticCubicFeature_inner u v

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_7_5a__contract : hdp_03_ex_3_7_5a__contract_type :=
  hdp_03_ex_3_7_5a

end NumStability.HDP.Contract
