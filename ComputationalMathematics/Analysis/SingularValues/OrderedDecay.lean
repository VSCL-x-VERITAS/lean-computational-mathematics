import ComputationalMathematics.Analysis.SingularValues.CourantFischer
import ComputationalMathematics.Analysis.SingularValues.Realification
import Mathlib.Analysis.InnerProductSpace.Trace

/-!
# Decay of transparently ordered real singular values

This module proves the one-based Frobenius decay estimate for the explicit
right-Gram singular values used by the real Courant--Fischer API.
-/

namespace NumStability

open scoped BigOperators

noncomputable section

/-- The decreasing real Hermitian eigenvalues sum to the matrix trace. -/
theorem sum_hermitianOrderedEigenvalue_eq_trace {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsHermitian) :
    ∑ i : Fin n, hermitianOrderedEigenvalue hA i = A.trace := by
  let hT : (Matrix.toEuclideanLin A).IsSymmetric :=
    Matrix.isHermitian_iff_isSymmetric.mp hA
  calc
    ∑ i : Fin n, hermitianOrderedEigenvalue hA i =
        LinearMap.trace ℝ (EuclideanSpace ℝ (Fin n))
          (Matrix.toEuclideanLin A) := by
      simpa [hermitianOrderedEigenvalue, hT] using
        (LinearMap.IsSymmetric.trace_eq_sum_eigenvalues
          (finrank_euclideanSpace_fin (𝕜 := ℝ) (n := n)) hT).symm
    _ = A.trace := by
      rw [Matrix.toEuclideanLin_eq_toLin_orthonormal]
      exact Matrix.trace_toLin_eq A
        (EuclideanSpace.basisFun (Fin n) ℝ).toBasis

/-- The trace of the explicit right Gram is the entrywise Frobenius square. -/
theorem trace_rectCourantFischerRightGram_eq_frobNormSqRect {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    (rectCourantFischerRightGram A).trace = frobNormSqRect A := by
  classical
  unfold Matrix.trace Matrix.diag rectCourantFischerRightGram frobNormSqRect
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _hi
  apply Finset.sum_congr rfl
  intro j _hj
  ring

/-- The Frobenius square is the sum of the squared transparently ordered real
singular values. -/
theorem frobNormSqRect_eq_sum_rectCourantFischerSingularValue_sq {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    frobNormSqRect A =
      ∑ i : Fin n, (rectCourantFischerSingularValue A i) ^ 2 := by
  rw [← trace_rectCourantFischerRightGram_eq_frobNormSqRect]
  rw [← sum_hermitianOrderedEigenvalue_eq_trace
    (rectCourantFischerRightGram A)
    (rectCourantFischerRightGram_isHermitian A)]
  apply Finset.sum_congr rfl
  intro i _hi
  exact (rectCourantFischerSingularValue_sq A i).symm

/-- One-based decay of the decreasing real right-Gram singular values:
`σᵢ(A) ≤ ‖A‖_F / √(i+1)` for zero-based Lean indices. -/
theorem rectCourantFischerSingularValue_le_frobenius_div_sqrt_succ
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) (i : Fin n) :
    rectCourantFischerSingularValue A i ≤
      frobNormRect A / Real.sqrt (i.1 + 1 : ℕ) := by
  have hcard_pos : 0 < ((i.1 + 1 : ℕ) : ℝ) := by positivity
  have hsqrt_pos : 0 < Real.sqrt ((i.1 + 1 : ℕ) : ℝ) :=
    Real.sqrt_pos.2 hcard_pos
  apply (le_div_iff₀ hsqrt_pos).2
  apply (sq_le_sq₀
    (mul_nonneg (rectCourantFischerSingularValue_nonneg A i)
      (Real.sqrt_nonneg _))
    (frobNormRect_nonneg A)).1
  rw [mul_pow, Real.sq_sqrt (le_of_lt hcard_pos), frobNormRect_sq,
    frobNormSqRect_eq_sum_rectCourantFischerSingularValue_sq]
  calc
    rectCourantFischerSingularValue A i ^ 2 * ((i.1 + 1 : ℕ) : ℝ) =
        ∑ j ∈ Finset.Iic i, rectCourantFischerSingularValue A i ^ 2 := by
      simp [Fin.card_Iic, nsmul_eq_mul, mul_comm]
    _ ≤ ∑ j ∈ Finset.Iic i,
        rectCourantFischerSingularValue A j ^ 2 := by
      apply Finset.sum_le_sum
      intro j hj
      exact (sq_le_sq₀ (rectCourantFischerSingularValue_nonneg A i)
        (rectCourantFischerSingularValue_nonneg A j)).2
        (rectCourantFischerSingularValue_antitone A
          (Finset.mem_Iic.mp hj))
    _ ≤ ∑ j : Fin n, rectCourantFischerSingularValue A j ^ 2 := by
      exact Finset.sum_le_univ_sum_of_nonneg
        (fun j => sq_nonneg (rectCourantFischerSingularValue A j))

end

end NumStability
