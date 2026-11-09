import ComputationalMathematics.Optimization.Convex.Euclidean

/-! Precise examples accompanying the book's qualitative discrete-set discussion. -/

namespace ComputationalMathematics.Optimization.Discrete


theorem binary_not_convex : ¬ Convex ℝ ({0, 1} : Set ℝ) := by
  intro h
  have hzero : (0 : ℝ) ∈ ({0, 1} : Set ℝ) := by simp
  have hone : (1 : ℝ) ∈ ({0, 1} : Set ℝ) := by simp
  have hhalf := h hzero hone (show (0 : ℝ) ≤ 1 / 2 by norm_num)
    (show (0 : ℝ) ≤ 1 / 2 by norm_num)
    (show (1 / 2 : ℝ) + 1 / 2 = 1 by norm_num)
  have hnot : (0 + 1 / 2 : ℝ) ∉ ({0, 1} : Set ℝ) := by norm_num
  apply hnot
  simp [smul_eq_mul] at hhalf

end ComputationalMathematics.Optimization.Discrete
