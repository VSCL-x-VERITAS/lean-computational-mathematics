import ComputationalMathematics.Source.Vershynin.Chapter03.Equation19.Signature

/-! Display (3.19): the canonical matrix inner product as a trace and entrywise sum. -/

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_19 : hdp_03_eq_3_19__contract_type := by
  intro n A X
  constructor
  · exact (NumStability.HDP.Tensor.trace_transpose_mul_eq_sum A X).symm
  · rfl

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_19__contract : hdp_03_eq_3_19__contract_type :=
  hdp_03_eq_3_19

end NumStability.HDP.Contract
