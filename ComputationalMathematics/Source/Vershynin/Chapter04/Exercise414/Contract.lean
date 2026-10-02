import ComputationalMathematics.Analysis.SingularValues.Isometries

/-!
# Vershynin Chapter 4, Exercise 4.1.4

Source contract for the four equivalent characterizations of a rectangular
real isometry.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Exercise 4.1.4: for an `m × N` real matrix with `m ≥ N > 0`,
the right Gram identity, the rank-`N` orthogonal-projection property of the
left Gram matrix, Euclidean norm preservation, and equality of every singular
value to one are equivalent. -/
theorem hdp_04_exercise_4_1_4 {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) (_hmn : n + 1 ≤ m) :
    let gramIdentity : Prop := A.transpose * A = 1
    let rangeProjection : Prop :=
      NumStability.IsRealOrthogonalProjectionMatrix (A * A.transpose) ∧
        (A * A.transpose).rank = n + 1
    let normIsometry : Prop := NumStability.IsRealMatrixIsometry A
    let allSingularValuesOne : Prop :=
      ∀ i : Fin (n + 1),
        NumStability.rectCourantFischerSingularValue A i = 1
    (gramIdentity ↔ rangeProjection) ∧
      (rangeProjection ↔ normIsometry) ∧
      (normIsometry ↔ allSingularValuesOne) :=
  NumStability.realMatrix_isometry_characterizations A

end NumStability.HDP.Contract
