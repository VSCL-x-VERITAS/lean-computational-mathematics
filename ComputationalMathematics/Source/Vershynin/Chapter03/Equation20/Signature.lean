import ComputationalMathematics.HDP.Optimization.SignQuadratic
import Mathlib.LinearAlgebra.Matrix.Symmetric

/-! Frozen proof-free signature for display (3.20). -/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_20__contract_type : Prop :=
  ∀ {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ), A.IsSymm →
    ∃ x : NumStability.HDP.Optimization.SignVector n,
      NumStability.HDP.Optimization.signQuadraticValue A x =
        NumStability.HDP.Optimization.signQuadraticMaximum A ∧
      ∀ y : NumStability.HDP.Optimization.SignVector n,
        NumStability.HDP.Optimization.signQuadraticValue A y ≤
          NumStability.HDP.Optimization.signQuadraticMaximum A

end NumStability.HDP.Contract
