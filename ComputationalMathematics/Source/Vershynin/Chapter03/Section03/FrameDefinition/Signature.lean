import ComputationalMathematics.HDP.Vector.Frame

/-! Frozen contract signature for Definition 3.3.8. -/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_def_3_3_8__contract_type : Prop :=
  ∀ {N n : ℕ} (u : Fin (N + 1) → Fin (n + 1) → ℝ),
    (NumStability.HDP.Vector.Frame.IsFrame u ↔
      ∃ A B : ℝ, 0 < A ∧ 0 < B ∧ ∀ x : Fin (n + 1) → ℝ,
        A * ∑ j, (x j) ^ 2 ≤ ∑ i, (u i ⬝ᵥ x) ^ 2 ∧
          ∑ i, (u i ⬝ᵥ x) ^ 2 ≤ B * ∑ j, (x j) ^ 2) ∧
    (∀ A : ℝ,
      NumStability.HDP.Vector.Frame.IsTightFrame u A ↔
        0 < A ∧ ∀ x : Fin (n + 1) → ℝ,
          ∑ i, (u i ⬝ᵥ x) ^ 2 = A * ∑ j, (x j) ^ 2)

end NumStability.HDP.Contract
