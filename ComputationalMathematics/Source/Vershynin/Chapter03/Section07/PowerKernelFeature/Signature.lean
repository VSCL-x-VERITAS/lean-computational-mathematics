import ComputationalMathematics.HDP.Tensor.PowerFeature

/-! Frozen proof-free signature for the Section 3.7 tensor-power feature-map claim. -/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_7_power_kernel_feature__contract_type : Prop :=
  ∀ (n k : ℕ),
    ∃ Φ : (Fin n → ℝ) → NumStability.HDP.Tensor.PowerFeatureSpace n k,
      (∀ u, Φ u = NumStability.HDP.Tensor.powerFeature k u) ∧
        ∀ u v, ⟪Φ u, Φ v⟫_ℝ = (∑ i, u i * v i) ^ k

end NumStability.HDP.Contract
