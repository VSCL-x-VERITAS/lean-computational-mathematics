import ComputationalMathematics.Source.Vershynin.Chapter03.Section07.Example03.Signature

/-! Example 3.7.3: a vector's tensor power is the array of products of
coordinate tuples, possibly with a different vector on each axis, and its
order-two case is the self outer product. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_example_3_7_3 : hdp_03_example_3_7_3__contract_type := by
  constructor
  · intro k n u i
    exact NumStability.HDP.Tensor.ofFactors_apply u i
  · constructor
    · intro n k u i
      exact NumStability.HDP.Tensor.power_apply u k i
    · intro n u i
      exact NumStability.HDP.Tensor.power_two_apply u i

set_option linter.style.nameCheck false in
theorem hdp_03_example_3_7_3__contract : hdp_03_example_3_7_3__contract_type :=
  hdp_03_example_3_7_3

end NumStability.HDP.Contract
