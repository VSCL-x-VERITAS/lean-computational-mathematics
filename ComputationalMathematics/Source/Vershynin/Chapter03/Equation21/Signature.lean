import ComputationalMathematics.HDP.Optimization.VectorQuadratic
import Mathlib.LinearAlgebra.Matrix.Symmetric

/-! Frozen proof-free signature for display (3.21). -/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_21__contract_type : Prop :=
  ∀ {n : ℕ} [Nonempty (Fin n)] (A : Matrix (Fin n) (Fin n) ℝ), A.IsSymm →
    ∃ X : NumStability.HDP.Optimization.UnitVectorFamily n,
      NumStability.HDP.Optimization.vectorQuadraticValue A X =
        NumStability.HDP.Optimization.vectorQuadraticMaximum A ∧
      ∀ Y : NumStability.HDP.Optimization.UnitVectorFamily n,
        NumStability.HDP.Optimization.vectorQuadraticValue A Y ≤
          NumStability.HDP.Optimization.vectorQuadraticMaximum A

end NumStability.HDP.Contract
