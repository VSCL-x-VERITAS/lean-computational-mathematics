import ComputationalMathematics.HDP.Tensor.PolynomialFeature

/-! Frozen proof-free signature for Exercise 3.7.5(a). -/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_7_5a__contract_type : Prop :=
  ∀ (n : ℕ) (u v : Fin n → ℝ),
    ⟪NumStability.HDP.Tensor.quadraticCubicFeature u,
      NumStability.HDP.Tensor.quadraticCubicFeature v⟫_ℝ =
      2 * (∑ i, u i * v i) ^ 2 +
        5 * (∑ i, u i * v i) ^ 3

end NumStability.HDP.Contract
