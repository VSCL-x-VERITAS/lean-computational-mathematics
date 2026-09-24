import ComputationalMathematics.HDP.Tensor.Specializations

/-! Frozen proof-free signature for Example 3.7.2. -/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_example_3_7_2__contract_type : Prop :=
  Function.Bijective NumStability.HDP.Tensor.scalarTensor ∧
  (∀ n : ℕ, Function.Bijective
    (NumStability.HDP.Tensor.vectorTensor (n := n))) ∧
  ∀ m n : ℕ,
    Function.Bijective
      (NumStability.HDP.Tensor.matrixTensor (m := m) (n := n)) ∧
    ∀ A B : Matrix (Fin m) (Fin n) ℝ,
      NumStability.HDP.Tensor.inner
          (NumStability.HDP.Tensor.matrixTensor A)
          (NumStability.HDP.Tensor.matrixTensor B) =
          Matrix.trace (A.transpose * B) ∧
      Matrix.trace (A.transpose * B) =
        ∑ i, ∑ j, A i j * B i j

end NumStability.HDP.Contract
