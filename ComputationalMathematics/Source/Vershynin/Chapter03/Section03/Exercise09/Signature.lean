import ComputationalMathematics.HDP.Vector.Frame

/-! Frozen contract signature for Exercise 3.3.9. -/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_3_9__contract_type : Prop :=
  ∀ {N n : ℕ} (u : Fin N → Fin n → ℝ) (A : ℝ),
    0 < A →
      (NumStability.HDP.Vector.Frame.IsTightFrame u A ↔
        ∑ i, Matrix.vecMulVec (u i) (u i) =
          A • (1 : Matrix (Fin n) (Fin n) ℝ))

end NumStability.HDP.Contract
