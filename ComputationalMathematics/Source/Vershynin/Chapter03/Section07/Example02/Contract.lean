import ComputationalMathematics.Source.Vershynin.Chapter03.Section07.Example02.Signature

/-! Example 3.7.2: scalars, vectors, and matrices are tensors; for matrices,
the tensor inner product is both `tr(Aᵀ B)` and the entrywise double sum. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_example_3_7_2 : hdp_03_example_3_7_2__contract_type := by
  refine ⟨NumStability.HDP.Tensor.scalarTensor_bijective, ?_, ?_⟩
  · exact fun _ => NumStability.HDP.Tensor.vectorTensor_bijective
  · intro m n
    refine ⟨NumStability.HDP.Tensor.matrixTensor_bijective, ?_⟩
    intro A B
    exact ⟨NumStability.HDP.Tensor.inner_matrixTensor_eq_trace A B,
      NumStability.HDP.Tensor.trace_transpose_mul_eq_sum A B⟩

set_option linter.style.nameCheck false in
theorem hdp_03_example_3_7_2__contract : hdp_03_example_3_7_2__contract_type :=
  hdp_03_example_3_7_2

end NumStability.HDP.Contract
