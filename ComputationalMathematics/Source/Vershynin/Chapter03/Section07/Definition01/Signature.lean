import ComputationalMathematics.HDP.Tensor.Finite

/-! Frozen proof-free signature for Definition 3.7.1. -/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_def_3_7_1__contract_type : Prop :=
  ∀ (k : ℕ) (n : Fin k → ℕ)
    (A B : NumStability.HDP.Tensor.FiniteTensor n),
    NumStability.HDP.Tensor.inner A B = ∑ i, A i * B i

end NumStability.HDP.Contract
