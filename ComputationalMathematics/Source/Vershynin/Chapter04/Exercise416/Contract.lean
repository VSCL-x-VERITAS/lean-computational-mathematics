import ComputationalMathematics.Analysis.SingularValues.ApproximateIsometryConverse

/-!
# Vershynin Chapter 4, Exercise 4.1.6

Source contract for the converse approximate-isometry estimate from extreme
singular-value bounds to right-Gram operator-norm control.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Exercise 4.1.6: if the extreme singular values satisfy (4.7),
then the right Gram matrix differs from the identity by at most
`3 * max δ δ²` in operator norm. -/
theorem hdp_04_exercise_4_1_6 {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) {δ : ℝ} (hδ : 0 < δ)
    (hSingular : NumStability.ExtremeSingularValueBounds A δ) :
    NumStability.realMatrixOperatorNorm (A.transpose * A - 1) ≤
      3 * max δ (δ ^ 2) :=
  NumStability.gramDeviation_le_three_max_of_extremeSingularValueBounds
    A hδ.le hSingular

end NumStability.HDP.Contract
