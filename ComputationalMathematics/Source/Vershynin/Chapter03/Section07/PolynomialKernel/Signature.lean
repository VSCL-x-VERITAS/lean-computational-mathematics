import ComputationalMathematics.HDP.Kernel.Polynomial

/-! Frozen proof-free signature for the Section 3.7.1 polynomial-kernel
example. -/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_7_polynomial_kernel__contract_type : Prop :=
  ∀ (n : ℕ) (r : ℝ), 0 < r → ∀ (k : ℕ),
    NumStability.HDP.Kernel.IsPositiveSemidefinite
      (fun u v : Fin n → ℝ ↦ ((∑ i, u i * v i) + r) ^ k)

end NumStability.HDP.Contract
