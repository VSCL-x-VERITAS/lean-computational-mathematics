import ComputationalMathematics.Analysis.SingularValues.ApproximateIsometries

/-!
# Vershynin Chapter 4, Equation (4.6)

Source contract for the uniform two-sided Euclidean distortion bound obtained
from right-Gram operator-norm control.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.6): under the approximate-isometry Gram-deviation
hypothesis, every vector is distorted by factors between `1 - δ` and
`1 + δ`. -/
theorem hdp_04_equation_4_6 {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) {δ : ℝ} (hδ : 0 < δ)
    (hGram : NumStability.realMatrixOperatorNorm (A.transpose * A - 1) ≤
      max δ (δ ^ 2)) :
    NumStability.ApproximateIsometryBounds A δ :=
  NumStability.approximateIsometryBounds_of_gramDeviation A hδ.le hGram

end NumStability.HDP.Contract
