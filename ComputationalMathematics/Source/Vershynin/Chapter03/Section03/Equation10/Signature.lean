import ComputationalMathematics.HDP.Vector.Frame

/-! Frozen contract signature for Equation (3.10). -/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_10__contract_type : Prop :=
  ∀ {N n : ℕ} (u : Fin (N + 1) → Fin (n + 1) → ℝ) (A : ℝ),
    NumStability.HDP.Vector.Frame.IsTightFrame u A →
      ∀ x : Fin (n + 1) → ℝ,
        ∑ i, (u i ⬝ᵥ x) • u i = A • x

end NumStability.HDP.Contract
