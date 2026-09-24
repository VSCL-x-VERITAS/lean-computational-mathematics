import ComputationalMathematics.Source.Vershynin.Chapter03.Equation28.Signature

/-! Display (3.28): the canonical tensor inner product is the sum of the
entrywise products over all multi-indices. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_28 : hdp_03_eq_3_28__contract_type := by
  intro k n A B
  exact NumStability.HDP.Tensor.inner_eq_sum A B

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_28__contract : hdp_03_eq_3_28__contract_type :=
  hdp_03_eq_3_28

end NumStability.HDP.Contract
