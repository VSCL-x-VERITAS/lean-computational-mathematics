import ComputationalMathematics.Analysis.SingularValues.ApproximateIsometries

/-!
# Converse bounds for approximate isometries

This module converts bounds on the extreme singular values into a uniform
approximate-isometry estimate and a bound on the right-Gram deviation.
-/

namespace NumStability

open scoped RealInnerProductSpace

noncomputable section

/-- If a nonnegative number lies between `1 - δ` and `1 + δ`, its squared
deviation from one is at most `3 * max δ δ²`. -/
theorem abs_sq_sub_one_le_three_max_of_bounds {z δ : ℝ}
    (hz : 0 ≤ z) (hδ : 0 ≤ δ) (hlower : 1 - δ ≤ z)
    (hupper : z ≤ 1 + δ) :
    |z ^ 2 - 1| ≤ 3 * max δ (δ ^ 2) := by
  have habs : |z - 1| ≤ δ := abs_le.mpr ⟨by linarith, by linarith⟩
  have hzplus : |z + 1| ≤ 2 + δ := by
    rw [abs_of_nonneg (by linarith)]
    linarith
  have hfactor : |z ^ 2 - 1| ≤ δ * (2 + δ) := by
    rw [show z ^ 2 - 1 = (z - 1) * (z + 1) by ring, abs_mul]
    exact mul_le_mul habs hzplus (abs_nonneg _) hδ
  by_cases hδone : δ ≤ 1
  · have hδsq : δ ^ 2 ≤ δ := by nlinarith
    rw [max_eq_left hδsq]
    nlinarith
  · have honeδ : 1 ≤ δ := le_of_lt (lt_of_not_ge hδone)
    have hδle : δ ≤ δ ^ 2 := by nlinarith
    rw [max_eq_right hδle]
    nlinarith

/-- Bounds on the extreme singular values imply the corresponding uniform
two-sided bounds on every vector. -/
theorem approximateIsometryBounds_of_extremeSingularValueBounds {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) {δ : ℝ}
    (h : ExtremeSingularValueBounds A δ) :
    ApproximateIsometryBounds A δ := by
  intro x
  obtain ⟨hminx, hmaxx⟩ :=
    (rectCourantFischer_extremeSingularValues_areOptimalBounds A).1 x
  constructor
  · exact (mul_le_mul_of_nonneg_right h.1 (norm_nonneg x)).trans hminx
  · exact hmaxx.trans
      (mul_le_mul_of_nonneg_right h.2.2 (norm_nonneg x))

/-- Converse approximate-isometry estimate: extreme singular values within
`δ` of one bound the right-Gram deviation by `3 * max δ δ²`. -/
theorem gramDeviation_le_three_max_of_extremeSingularValueBounds {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) {δ : ℝ} (hδ : 0 ≤ δ)
    (h : ExtremeSingularValueBounds A δ) :
    realMatrixOperatorNorm (A.transpose * A - 1) ≤
      3 * max δ (δ ^ 2) := by
  let H : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ := A.transpose * A - 1
  have hH : H.IsHermitian := by
    simp [H, Matrix.IsHermitian]
  obtain ⟨_, ⟨x, hx, hattain, _⟩⟩ :=
    symmetricRealMatrixOperatorNorm_quadratic_characterization
      (Nat.succ_pos n) H hH
  rw [← hattain]
  have hApprox := approximateIsometryBounds_of_extremeSingularValueBounds A h
  have hbounds := hApprox x
  have hlower : 1 - δ ≤ ‖Matrix.toEuclideanLin A x‖ := by
    simpa [hx] using hbounds.1
  have hupper : ‖Matrix.toEuclideanLin A x‖ ≤ 1 + δ := by
    simpa [hx] using hbounds.2
  simpa [H, realMatrixQuadraticForm_transpose_mul_self_sub_one, hx] using
    abs_sq_sub_one_le_three_max_of_bounds
      (norm_nonneg (Matrix.toEuclideanLin A x)) hδ hlower hupper

end

end NumStability
