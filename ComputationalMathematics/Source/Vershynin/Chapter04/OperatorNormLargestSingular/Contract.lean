import ComputationalMathematics.Analysis.SingularValues.ExtremeValues

/-!
# Vershynin, Chapter 4, operator norm and leading singular value

Source-correspondence contract for the identity between the Euclidean operator
norm and the largest singular value.
-/

namespace NumStability.HDP.Contract

/-- Printed page 77: the first coefficient in an ordered real singular-value
decomposition dominates every singular value and equals the Euclidean operator
norm.  Indexing the nonempty column dimension as `n + 1` makes the source's
one-based `s₁(A)` meaningful without adding a premise to the theorem. -/
theorem hdp_04_operator_norm_eq_largest_singular_value {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) :
    ∃ (r : ℕ) (s : Fin (n + 1) → ℝ)
      (u : Fin r → EuclideanSpace ℝ (Fin m))
      (v : Fin r → EuclideanSpace ℝ (Fin (n + 1))),
      NumStability.IsRealMatrixSVD A r s u v ∧
        (∀ i : Fin (n + 1), s i ≤ s (0 : Fin (n + 1))) ∧
        s (0 : Fin (n + 1)) = NumStability.realMatrixOperatorNorm A := by
  obtain ⟨r, s, u, v, h⟩ := NumStability.exists_isRealMatrixSVD A
  refine ⟨r, s, u, v, h, ?_, h.leadingSingularValue_eq_operatorNorm⟩
  intro i
  exact h.singularValues_antitone (Fin.zero_le i)

/-- Every matrix admits the exhaustive coordinate SVD data whose leading
coefficient dominates all coefficients and equals its Euclidean operator norm.
No decomposition is assumed to exist as an additional hypothesis. -/
theorem hdp_04_operator_norm_eq_largest_singular_value_explicit_svd {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) :
    ∃ (r : ℕ) (s : Fin (n + 1) → ℝ)
      (u : Fin r → EuclideanSpace ℝ (Fin m))
      (v : Fin r → EuclideanSpace ℝ (Fin (n + 1))),
      NumStability.RealMatrixSVDExplicitFields A r s u v ∧
        (∀ i : Fin (n + 1), s i ≤ s (0 : Fin (n + 1))) ∧
        s (0 : Fin (n + 1)) = NumStability.realMatrixOperatorNorm A := by
  obtain ⟨r, s, u, v, h, htop, hnorm⟩ :=
    hdp_04_operator_norm_eq_largest_singular_value A
  exact ⟨r, s, u, v, NumStability.isRealMatrixSVD_iff_explicit_fields.mp h,
    htop, hnorm⟩

end NumStability.HDP.Contract
