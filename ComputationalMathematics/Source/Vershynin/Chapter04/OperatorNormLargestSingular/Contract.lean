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

/-- Printed pages 76–77: the leading coefficient of the explicit ordered SVD
equals the literal Euclidean coordinate supremum and attains that maximum on
the unit sphere. The column dimension is nonempty; the row dimension and rank
may be zero. -/
theorem hdp_04_operator_norm_eq_largest_singular_value_coordinate_max {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) :
    ∃ (r : ℕ) (s : Fin (n + 1) → ℝ)
      (u : Fin r → EuclideanSpace ℝ (Fin m))
      (v : Fin r → EuclideanSpace ℝ (Fin (n + 1))),
      NumStability.RealMatrixSVDExplicitFields A r s u v ∧
        (∀ i : Fin (n + 1), s i ≤ s (0 : Fin (n + 1))) ∧
        s (0 : Fin (n + 1)) =
          sSup {q : ℝ | ∃ x : Fin (n + 1) → ℝ, (∑ j, x j ^ 2) = 1 ∧
            q = Real.sqrt (∑ a, (∑ b, A a b * x b) ^ 2)} ∧
        ∃ x : Fin (n + 1) → ℝ,
          (∑ j, x j ^ 2) = 1 ∧
          Real.sqrt (∑ a, (∑ b, A a b * x b) ^ 2) = s (0 : Fin (n + 1)) ∧
          ∀ y : Fin (n + 1) → ℝ, (∑ j, y j ^ 2) = 1 →
            Real.sqrt (∑ a, (∑ b, A a b * y b) ^ 2) ≤ s (0 : Fin (n + 1)) := by
  obtain ⟨r, s, u, v, hSVD, htop, hnorm⟩ :=
    hdp_04_operator_norm_eq_largest_singular_value_explicit_svd A
  refine ⟨r, s, u, v, hSVD, htop,
    hnorm.trans (NumStability.realMatrixOperatorNorm_eq_coordinate_sSup A), ?_⟩
  obtain ⟨_, ⟨x, hx, hAx, hmax⟩, _⟩ :=
    NumStability.realMatrixOperatorNorm_characterization (Nat.succ_pos n) A
  have haction (z : EuclideanSpace ℝ (Fin (n + 1))) :
      ‖Matrix.toEuclideanLin A z‖ =
        Real.sqrt (∑ a, (∑ b, A a b * z b) ^ 2) := by
    rw [EuclideanSpace.norm_eq]
    simp only [Real.norm_eq_abs, sq_abs]
    rfl
  have hxSq : (∑ j, x j ^ 2) = 1 := by
    simpa only [hx, one_pow, Real.norm_eq_abs, sq_abs] using
      (EuclideanSpace.norm_sq_eq x).symm
  refine ⟨fun j ↦ x j, hxSq, (haction x).symm.trans (hAx.trans hnorm.symm), ?_⟩
  intro y hy
  have hunit : ‖(WithLp.toLp 2 y : EuclideanSpace ℝ (Fin (n + 1)))‖ = 1 := by
    rw [EuclideanSpace.norm_eq]
    simp only [Real.norm_eq_abs, sq_abs, hy, Real.sqrt_one]
  simpa only [haction, ← hnorm] using hmax (WithLp.toLp 2 y) hunit

end NumStability.HDP.Contract
