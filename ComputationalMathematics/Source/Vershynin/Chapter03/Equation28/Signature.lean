import ComputationalMathematics.HDP.Tensor.Finite

/-! Frozen proof-free signature for display (3.28). -/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_28__contract_type : Prop :=
  ∀ (k : ℕ) (n : Fin k → ℕ)
    (A B : NumStability.HDP.Tensor.FiniteTensor n),
    NumStability.HDP.Tensor.inner A B = ∑ i, A i * B i

end NumStability.HDP.Contract
