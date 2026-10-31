import ComputationalMathematics.Analysis.MatrixAlgebra
import Mathlib.Analysis.InnerProductSpace.PiL2

/-!
# Inverting a square real singular-value decomposition

This module proves the algebraic inverse formula for a square real SVD whose
singular values are nonzero. Singular-vector families are represented as
orthonormal bases, so completeness is part of their type rather than a separate
matrix hypothesis.
-/

namespace NumStability

open scoped BigOperators RealInnerProductSpace

noncomputable section

/-- The square matrix whose columns are an orthonormal basis. -/
def orthonormalBasisMatrix {n : ℕ}
    (b : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n))) :
    Matrix (Fin n) (Fin n) ℝ :=
  fun i k => b k i

/-- A square real SVD written in the source's rank-one-sum form. -/
def IsSquareRealSVD {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (s : Fin n → ℝ)
    (u v : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n))) : Prop :=
  ∀ i j, A i j = ∑ k : Fin n, s k * u k i * v k j

/-- The source's reciprocal-singular-value rank-one sum. -/
def inverseSVDFormula {n : ℕ} (s : Fin n → ℝ)
    (u v : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n))) :
    Matrix (Fin n) (Fin n) ℝ :=
  fun i j => ∑ k : Fin n, (s k)⁻¹ * v k i * u k j

theorem orthonormalBasisMatrix_transpose_mul_self {n : ℕ}
    (b : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n))) :
    (orthonormalBasisMatrix b).transpose * orthonormalBasisMatrix b = 1 := by
  ext i j
  have h := b.inner_eq_ite i j
  rw [PiLp.inner_apply] at h
  simp_rw [real_inner_eq_re_inner, RCLike.inner_apply] at h
  simpa [orthonormalBasisMatrix, Matrix.mul_apply, mul_comm] using h

theorem orthonormalBasisMatrix_mul_transpose {n : ℕ}
    (b : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n))) :
    orthonormalBasisMatrix b * (orthonormalBasisMatrix b).transpose = 1 :=
  mul_eq_one_comm.mp (orthonormalBasisMatrix_transpose_mul_self b)

theorem diagonal_mul_reciprocal {n : ℕ} (s : Fin n → ℝ)
    (hs : ∀ i, s i ≠ 0) :
    Matrix.diagonal s * Matrix.diagonal (fun i => (s i)⁻¹) = 1 := by
  rw [Matrix.diagonal_mul_diagonal]
  ext i j
  by_cases hij : i = j
  · subst j
    simp [hs i]
  · simp [hij]

theorem isSquareRealSVD_eq_matrix_mul {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} {s : Fin n → ℝ}
    {u v : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n))}
    (hsvd : IsSquareRealSVD A s u v) :
    A = orthonormalBasisMatrix u * Matrix.diagonal s *
      (orthonormalBasisMatrix v).transpose := by
  ext i j
  rw [hsvd i j]
  rw [Matrix.mul_apply]
  simp_rw [Matrix.mul_diagonal]
  simp only [orthonormalBasisMatrix, Matrix.transpose_apply]
  apply Finset.sum_congr rfl
  intro k _
  ring

theorem inverseSVDFormula_eq_matrix_mul {n : ℕ} (s : Fin n → ℝ)
    (u v : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n))) :
    inverseSVDFormula s u v =
      orthonormalBasisMatrix v * Matrix.diagonal (fun i => (s i)⁻¹) *
        (orthonormalBasisMatrix u).transpose := by
  ext i j
  unfold inverseSVDFormula
  rw [Matrix.mul_apply]
  simp_rw [Matrix.mul_diagonal]
  simp only [orthonormalBasisMatrix, Matrix.transpose_apply]
  apply Finset.sum_congr rfl
  intro k _
  ring

/-- The reciprocal-singular-value formula is a right inverse of a square SVD
with no zero singular values. -/
theorem inverseSVDFormula_isRightInverse {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (s : Fin n → ℝ)
    (u v : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (hs : ∀ i, s i ≠ 0) (hsvd : IsSquareRealSVD A s u v) :
    A * inverseSVDFormula s u v = 1 := by
  rw [isSquareRealSVD_eq_matrix_mul hsvd,
    inverseSVDFormula_eq_matrix_mul]
  calc
    (orthonormalBasisMatrix u * Matrix.diagonal s *
        (orthonormalBasisMatrix v).transpose) *
        (orthonormalBasisMatrix v *
          Matrix.diagonal (fun i => (s i)⁻¹) *
          (orthonormalBasisMatrix u).transpose) =
        orthonormalBasisMatrix u * Matrix.diagonal s *
          ((orthonormalBasisMatrix v).transpose *
            orthonormalBasisMatrix v) *
          Matrix.diagonal (fun i => (s i)⁻¹) *
          (orthonormalBasisMatrix u).transpose := by
      simp only [Matrix.mul_assoc]
    _ = orthonormalBasisMatrix u * Matrix.diagonal s *
          Matrix.diagonal (fun i => (s i)⁻¹) *
          (orthonormalBasisMatrix u).transpose := by
      rw [orthonormalBasisMatrix_transpose_mul_self]
      simp
    _ = orthonormalBasisMatrix u *
          (Matrix.diagonal s * Matrix.diagonal (fun i => (s i)⁻¹)) *
          (orthonormalBasisMatrix u).transpose := by
      simp only [Matrix.mul_assoc]
    _ = orthonormalBasisMatrix u *
          (orthonormalBasisMatrix u).transpose := by
      rw [diagonal_mul_reciprocal s hs]
      simp
    _ = 1 := orthonormalBasisMatrix_mul_transpose u

/-- Inverting a square real SVD swaps the left and right singular bases and
reciprocates every singular value. -/
theorem nonsingInv_eq_inverseSVDFormula {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (s : Fin n → ℝ)
    (u v : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (hs : ∀ i, s i ≠ 0) (hsvd : IsSquareRealSVD A s u v) :
    nonsingInv n A = inverseSVDFormula s u v := by
  apply nonsingInv_eq_of_isRightInverse
  intro i j
  have h := congrArg (fun M : Matrix (Fin n) (Fin n) ℝ => M i j)
    (inverseSVDFormula_isRightInverse A s u v hs hsvd)
  simpa [Matrix.mul_apply] using h

end

end NumStability
