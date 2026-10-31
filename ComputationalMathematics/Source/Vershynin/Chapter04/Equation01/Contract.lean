import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LowRankApproximation.ColumnSketches.RealSVD

/-!
# Vershynin, Chapter 4, Equation (4.1)

Source-correspondence contract for the rank-length real singular-value
decomposition displayed at the start of Section 4.1.1.
-/

namespace NumStability.HDP.Contract

open scoped BigOperators

/-- Equation (4.1), printed page 75: every real rectangular matrix is a sum
of `rank A` singular-value rank-one terms `s k • (u k) (v k)ᵀ`, stated
entrywise.  The SVD certificate preserves the immediately defined roles of
the coefficients and vector families instead of weakening them to arbitrary
rank-factorization data. -/
theorem hdp_04_heq_h4_d1 {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    ∃ (r : ℕ) (s : Fin n → ℝ)
      (u : Fin r → EuclideanSpace ℝ (Fin m))
      (v : Fin r → EuclideanSpace ℝ (Fin n))
      (h : NumStability.IsRealMatrixSVD A r s u v),
      r = A.rank ∧ ∀ i j,
        A i j = ∑ k : Fin r,
          s (Fin.castLE h.rank_le_width k) * u k i * v k j := by
  obtain ⟨r, s, u, v, h⟩ := NumStability.exists_isRealMatrixSVD A
  exact ⟨r, s, u, v, h, h.rank_eq, h.reconstruction⟩

end NumStability.HDP.Contract
