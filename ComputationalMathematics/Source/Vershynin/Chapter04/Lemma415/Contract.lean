import ComputationalMathematics.Analysis.SingularValues.ApproximateIsometries

/-!
# Vershynin Chapter 4, Lemma 4.1.5

Source contract for approximate isometries obtained from right-Gram
operator-norm control.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Lemma 4.1.5: if the right Gram matrix of a real rectangular
matrix is within `max δ δ²` of the identity in operator norm, then every
vector is distorted by factors between `1 - δ` and `1 + δ`, and consequently
the smallest and largest singular values obey the same bounds. -/
theorem hdp_04_lemma_4_1_5 {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) {δ : ℝ} (hδ : 0 < δ)
    (hGram : NumStability.realMatrixOperatorNorm (A.transpose * A - 1) ≤
      max δ (δ ^ 2)) :
    NumStability.ApproximateIsometryBounds A δ ∧
      NumStability.ExtremeSingularValueBounds A δ := by
  have h := NumStability.approximateIsometry_of_gramDeviation A hδ hGram
  exact ⟨h.1, h.2.1⟩

end NumStability.HDP.Contract
