import ComputationalMathematics.HDP.Optimization.SemidefiniteProgram

/-! Frozen proof-free signature for Definition 3.5.4. -/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_def_3_5_4__contract_type : Prop :=
  ∀ {n m : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
      (B : Fin m → Matrix (Fin n) (Fin n) ℝ) (b : Fin m → ℝ),
    ∃ P : NumStability.HDP.Optimization.SemidefiniteProgram n m,
      P.objective = A ∧ P.constraint = B ∧ P.target = b ∧
      (∀ X, P.Feasible X ↔
        X.PosSemidef ∧
          ∀ i, NumStability.HDP.Optimization.matrixInner (B i) X = b i) ∧
      (∀ X, P.value X = NumStability.HDP.Optimization.matrixInner A X) ∧
      ∀ X, P.IsMaximizer X ↔
        P.Feasible X ∧
          ∀ Y, P.Feasible Y →
            NumStability.HDP.Optimization.matrixInner A Y ≤
              NumStability.HDP.Optimization.matrixInner A X

end NumStability.HDP.Contract
