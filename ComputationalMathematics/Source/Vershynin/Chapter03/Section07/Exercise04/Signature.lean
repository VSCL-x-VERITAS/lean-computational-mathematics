import ComputationalMathematics.HDP.Tensor.Finite

/-! Frozen proof-free signature for Exercise 3.7.4. -/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_7_4__contract_type : Prop :=
  ∀ (n : ℕ) (u v : Fin n → ℝ) (k : ℕ),
    NumStability.HDP.Tensor.inner
        (NumStability.HDP.Tensor.power u k)
        (NumStability.HDP.Tensor.power v k) =
      (∑ i, u i * v i) ^ k

end NumStability.HDP.Contract
