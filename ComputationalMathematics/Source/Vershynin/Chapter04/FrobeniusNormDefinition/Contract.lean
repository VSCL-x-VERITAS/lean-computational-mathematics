import ComputationalMathematics.Analysis.MatrixAlgebra

/-!
# Vershynin Chapter 4: Frobenius norm

Thin source contract for the entrywise definition of the Frobenius
(Hilbert--Schmidt) norm of a real rectangular matrix.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Chapter 4, p. 77: the Frobenius norm is the square root of the
sum of the squares of all matrix entries. -/
theorem hdp_04_frobenius_norm_definition {m n : ℕ}
    (A : Fin m → Fin n → ℝ) :
    NumStability.frobNormRect A =
      Real.sqrt (∑ i : Fin m, ∑ j : Fin n, A i j ^ 2) := by
  rfl

end NumStability.HDP.Contract
