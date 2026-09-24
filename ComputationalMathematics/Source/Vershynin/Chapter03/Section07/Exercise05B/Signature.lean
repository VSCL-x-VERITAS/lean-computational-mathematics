import ComputationalMathematics.HDP.Tensor.PolynomialFeature

/-! Frozen proof-free signature for Exercise 3.7.5(b). -/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_7_5b__contract_type : Prop :=
  ∀ (n d : ℕ) (a : Fin (d + 1) → ℝ),
    (∀ k, 0 ≤ a k) →
    ∀ (u v : Fin n → ℝ),
      ⟪NumStability.HDP.Tensor.polynomialFeature a u,
        NumStability.HDP.Tensor.polynomialFeature a v⟫_ℝ =
        ∑ k, a k * (∑ i, u i * v i) ^ k.1

end NumStability.HDP.Contract
