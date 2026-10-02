import ComputationalMathematics.Analysis.OperatorNorms.RealComplexification

/-!
# Vershynin Chapter 4, Equation (4.4)

Thin source contracts for the sharp rank-sensitive comparison between the
operator and Frobenius norms of a real rectangular matrix.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Chapter 4, Equation (4.4): for a real rectangular matrix,
the operator norm is bounded by the Frobenius norm, which is at most
`sqrt(rank A)` times the operator norm. -/
theorem hdp_04_equation_4_4_inequalities {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    NumStability.realMatrixOperatorNorm A ≤ NumStability.frobNormRect A ∧
      NumStability.frobNormRect A ≤
        Real.sqrt (NumStability.realRectMatrixRank A : ℝ) *
          NumStability.realMatrixOperatorNorm A :=
  ⟨NumStability.realMatrixOperatorNorm_le_frobNormRect A,
    NumStability.frobNormRect_le_sqrt_rank_mul_realMatrixOperatorNorm A⟩

/-- Vershynin's assertion immediately before Equation (4.4) that the displayed
relation is best possible, represented as optimality of its two coefficients. -/
theorem hdp_04_equation_4_4_best_possible :
    NumStability.RealOperatorFrobeniusRelationIsBestPossible :=
  NumStability.realOperatorFrobeniusRelation_isBestPossible

/-- Full source contract for Vershynin, Chapter 4, Equation (4.4), combining
the real-matrix inequalities with the accompanying best-possible assertion. -/
theorem hdp_04_equation_4_4 {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    (NumStability.realMatrixOperatorNorm A ≤ NumStability.frobNormRect A ∧
      NumStability.frobNormRect A ≤
        Real.sqrt (NumStability.realRectMatrixRank A : ℝ) *
          NumStability.realMatrixOperatorNorm A) ∧
      NumStability.RealOperatorFrobeniusRelationIsBestPossible :=
  ⟨hdp_04_equation_4_4_inequalities A,
    hdp_04_equation_4_4_best_possible⟩

end NumStability.HDP.Contract
