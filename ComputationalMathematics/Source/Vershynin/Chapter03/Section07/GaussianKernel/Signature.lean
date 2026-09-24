import ComputationalMathematics.HDP.Kernel.Gaussian

/-! Frozen proof-free signature for the Section 3.7.1 Gaussian-kernel example. -/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_7_gaussian_kernel__contract_type : Prop :=
  ∀ (n : ℕ) (σ : ℝ), 0 < σ →
    NumStability.HDP.Kernel.IsPositiveSemidefinite
      (fun u v : Fin n → ℝ ↦
        Real.exp (-(∑ i, (u i - v i) ^ 2) / (2 * σ ^ 2)))

end NumStability.HDP.Contract
