import ComputationalMathematics.HDP.Tensor.PowerSeries

/-! Frozen proof-free signature for display (3.29). -/

noncomputable section

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_29__contract_type : Prop :=
  ∀ (f : ℝ → ℝ) (a : ℕ → ℝ),
    (∀ k, 0 ≤ a k) →
    NumStability.HDP.Tensor.GloballyConvergentPowerSeries f a →
    ∀ x : ℝ, f x = ∑' k : ℕ, a k * x ^ k

end NumStability.HDP.Contract
