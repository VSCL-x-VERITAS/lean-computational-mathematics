import ComputationalMathematics.HDP.Graph.MaxCutSemidefinite
import ComputationalMathematics.HDP.Optimization.SemidefiniteRelaxation

/-!
# Gram-matrix form of the maximum-cut relaxation

The unit-vector objective factors through the Gram matrix, and every positive-
semidefinite matrix with unit diagonal is such a Gram matrix.
-/

namespace NumStability.HDP.Graph

open scoped BigOperators

noncomputable section

/-- The maximum-cut relaxation objective on a candidate Gram matrix. -/
def maxCutSemidefiniteMatrixValue {n : ℕ} (A M : Matrix (Fin n) (Fin n) ℝ) : ℝ :=
  (1 / 4 : ℝ) * ∑ i, ∑ j, A i j * (1 - M i j)

theorem maxCutSemidefiniteValue_unitVectorGram {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ)
    (X : NumStability.HDP.Optimization.UnitVectorFamily n) :
    maxCutSemidefiniteMatrixValue A
        (NumStability.HDP.Optimization.unitVectorGram X) =
      maxCutSemidefiniteValue A X := by
  rfl

theorem exists_correlationMatrix_value_eq {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ)
    (X : NumStability.HDP.Optimization.UnitVectorFamily n) :
    ∃ M : Matrix (Fin n) (Fin n) ℝ,
      NumStability.HDP.Optimization.IsCorrelationMatrix M ∧
        maxCutSemidefiniteMatrixValue A M = maxCutSemidefiniteValue A X :=
  ⟨NumStability.HDP.Optimization.unitVectorGram X,
    NumStability.HDP.Optimization.unitVectorGram_isCorrelationMatrix X,
    maxCutSemidefiniteValue_unitVectorGram A X⟩

theorem exists_unitVectorFamily_matrixValue_eq {n : ℕ}
    (A M : Matrix (Fin n) (Fin n) ℝ)
    (hM : NumStability.HDP.Optimization.IsCorrelationMatrix M) :
    ∃ X : NumStability.HDP.Optimization.UnitVectorFamily n,
      maxCutSemidefiniteValue A X = maxCutSemidefiniteMatrixValue A M := by
  obtain ⟨X, hX⟩ :=
    NumStability.HDP.Optimization.exists_unitVectorFamily_gram_eq hM
  refine ⟨X, ?_⟩
  rw [← maxCutSemidefiniteValue_unitVectorGram, hX]

end

end NumStability.HDP.Graph
