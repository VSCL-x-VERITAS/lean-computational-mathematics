import ComputationalMathematics.Source.Vershynin.Chapter04.Lemma415.Contract

/-!
# Vershynin Chapter 4, Equation (4.7)

Source contract for the extreme-singular-value consequence of the
approximate-isometry Gram-deviation bound.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.7): under the approximate-isometry Gram-deviation
hypothesis, the smallest and largest singular values lie between `1 - δ` and
`1 + δ`. -/
theorem hdp_04_equation_4_7 {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) {δ : ℝ} (hδ : 0 < δ)
    (hGram : NumStability.realMatrixOperatorNorm (A.transpose * A - 1) ≤
      max δ (δ ^ 2)) :
    NumStability.ExtremeSingularValueBounds A δ :=
  (hdp_04_lemma_4_1_5 A hδ hGram).2

end NumStability.HDP.Contract
