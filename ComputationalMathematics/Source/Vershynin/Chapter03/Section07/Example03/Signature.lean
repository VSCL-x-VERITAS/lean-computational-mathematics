import ComputationalMathematics.HDP.Tensor.RankOne

/-! Frozen proof-free signature for Example 3.7.3. -/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_example_3_7_3__contract_type : Prop :=
  (∀ (k : ℕ) (n : Fin k → ℕ)
      (u : ∀ j, Fin (n j) → ℝ) (i : ∀ j, Fin (n j)),
    NumStability.HDP.Tensor.ofFactors u i = ∏ j, u j (i j)) ∧
  (∀ (n k : ℕ) (u : Fin n → ℝ) (i : Fin k → Fin n),
    NumStability.HDP.Tensor.power u k i = ∏ j, u (i j)) ∧
  (∀ (n : ℕ) (u : Fin n → ℝ) (i : Fin 2 → Fin n),
    NumStability.HDP.Tensor.power u 2 i =
      NumStability.HDP.Tensor.outer u u (i 0) (i 1))

end NumStability.HDP.Contract
