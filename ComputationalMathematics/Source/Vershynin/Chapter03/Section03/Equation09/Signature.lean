import ComputationalMathematics.HDP.Vector.Frame

/-! Frozen contract signature for Equation (3.9). -/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_9__contract_type : Prop :=
  ∀ {N n : ℕ} (u : Fin (N + 1) → Fin (n + 1) → ℝ) (A : ℝ),
    NumStability.HDP.Vector.Frame.IsTightFrame u A →
      ∑ i, Matrix.vecMulVec (u i) (u i) =
        A • (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ)

end NumStability.HDP.Contract
