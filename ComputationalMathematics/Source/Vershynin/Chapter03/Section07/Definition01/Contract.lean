import ComputationalMathematics.Source.Vershynin.Chapter03.Section07.Definition01.Signature

/-! Definition 3.7.1: finite tensors are multidimensional real arrays with
the canonical entrywise inner product. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_def_3_7_1 : hdp_03_def_3_7_1__contract_type := by
  intro k n A B
  exact NumStability.HDP.Tensor.inner_eq_sum A B

set_option linter.style.nameCheck false in
theorem hdp_03_def_3_7_1__contract : hdp_03_def_3_7_1__contract_type :=
  hdp_03_def_3_7_1

end NumStability.HDP.Contract
