import ComputationalMathematics.HDP.Optimization.SemidefiniteRelaxation
import Mathlib.LinearAlgebra.Matrix.Symmetric

/-! Frozen proof-free signature for Exercise 3.5.5. -/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_5_5__contract_type : Prop :=
  ∀ {n : ℕ} [Nonempty (Fin n)] (A : Matrix (Fin n) (Fin n) ℝ), A.IsSymm →
    (∀ X : NumStability.HDP.Optimization.UnitVectorFamily n,
      NumStability.HDP.Optimization.IsCorrelationMatrix
          (NumStability.HDP.Optimization.unitVectorGram X) ∧
        NumStability.HDP.Optimization.semidefiniteQuadraticValue A
            (NumStability.HDP.Optimization.unitVectorGram X) =
          NumStability.HDP.Optimization.vectorQuadraticValue A X) ∧
    (∀ M : Matrix (Fin n) (Fin n) ℝ,
      NumStability.HDP.Optimization.IsCorrelationMatrix M →
        ∃ X : NumStability.HDP.Optimization.UnitVectorFamily n,
          NumStability.HDP.Optimization.unitVectorGram X = M ∧
          NumStability.HDP.Optimization.semidefiniteQuadraticValue A M =
            NumStability.HDP.Optimization.vectorQuadraticValue A X)

end NumStability.HDP.Contract
