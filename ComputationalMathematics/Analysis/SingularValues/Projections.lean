import ComputationalMathematics.Analysis.OperatorNorms.RealMatrix
import ComputationalMathematics.Analysis.SingularValues.Isometries
import Mathlib.LinearAlgebra.UnitaryGroup

/-!
# Rectangular real projections

This module packages the transpose duality between rectangular isometries and
projections, together with the corresponding approximate notion and the
canonical examples obtained by selecting rows or columns of an orthogonal
matrix.
-/

namespace NumStability

noncomputable section

/-- A rectangular matrix is a projection from its column space onto its row
space when its rows are orthonormal. -/
def IsRealMatrixProjection {n m : ℕ}
    (Q : Matrix (Fin n) (Fin m) ℝ) : Prop :=
  Q * Q.transpose = 1

/-- Approximate projection in the right-Gram convention dual to an
approximate isometric embedding. -/
def IsApproximateRealMatrixProjection {n m : ℕ}
    (Q : Matrix (Fin n) (Fin m) ℝ) (δ : ℝ) : Prop :=
  realMatrixOperatorNorm (Q * Q.transpose - 1) ≤ max δ (δ ^ 2)

/-- A rectangular projection is equivalently the transpose of an isometry;
its opposite Gram matrix is the corresponding full-rank orthogonal
projection. -/
theorem matrixProjection_iff_gram_orthogonalProjection_rank {n m : ℕ}
    (Q : Matrix (Fin n) (Fin m) ℝ) :
    IsRealMatrixProjection Q ↔
      IsRealOrthogonalProjectionMatrix (Q.transpose * Q) ∧
        (Q.transpose * Q).rank = n := by
  constructor
  · intro hQ
    simpa [IsRealMatrixProjection] using
      transpose_mul_self_eq_one_implies_projection_rank Q.transpose
        (by simpa [IsRealMatrixProjection] using hQ)
  · intro hP
    have h := projection_rank_implies_transpose_mul_self_eq_one Q.transpose
      (by simpa using hP.1) (by simpa using hP.2)
    simpa [IsRealMatrixProjection] using h

/-- A real rectangular matrix is an isometric embedding exactly when its
transpose is a projection. -/
theorem isRealMatrixIsometry_iff_transpose_isRealMatrixProjection {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    IsRealMatrixIsometry A ↔ IsRealMatrixProjection A.transpose := by
  simpa [IsRealMatrixProjection] using
    (transpose_mul_self_eq_one_iff_isRealMatrixIsometry A).symm

/-- The Gram-deviation definition of an approximate isometry becomes the
approximate-projection definition after transposition. -/
theorem gramDeviation_iff_transpose_approximateProjection {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (δ : ℝ) :
    realMatrixOperatorNorm (A.transpose * A - 1) ≤ max δ (δ ^ 2) ↔
      IsApproximateRealMatrixProjection A.transpose δ := by
  simp [IsApproximateRealMatrixProjection]

/-- Selecting distinct columns of a real orthogonal matrix gives an
isometric embedding. -/
theorem selectedColumns_isRealMatrixIsometry {N k : ℕ}
    (U : Matrix (Fin N) (Fin N) ℝ)
    (hU : U ∈ Matrix.orthogonalGroup (Fin N) ℝ)
    (f : Fin k → Fin N) (hf : Function.Injective f) :
    IsRealMatrixIsometry (U.submatrix id f) := by
  apply (transpose_mul_self_eq_one_iff_isRealMatrixIsometry _).1
  have hGram : U.transpose * U = 1 :=
    (Matrix.mem_orthogonalGroup_iff' (Fin N) ℝ).mp hU
  ext i j
  have hij := congrFun (congrFun hGram (f i)) (f j)
  simpa [Matrix.mul_apply, Matrix.one_apply, hf.eq_iff] using hij

/-- Selecting distinct rows of a real orthogonal matrix gives a rectangular
projection. -/
theorem selectedRows_isRealMatrixProjection {N k : ℕ}
    (U : Matrix (Fin N) (Fin N) ℝ)
    (hU : U ∈ Matrix.orthogonalGroup (Fin N) ℝ)
    (f : Fin k → Fin N) (hf : Function.Injective f) :
    IsRealMatrixProjection (U.submatrix f id) := by
  have hGram : U * U.transpose = 1 :=
    (Matrix.mem_orthogonalGroup_iff (Fin N) ℝ).mp hU
  unfold IsRealMatrixProjection
  ext i j
  have hij := congrFun (congrFun hGram (f i)) (f j)
  simpa [Matrix.mul_apply, Matrix.one_apply, hf.eq_iff] using hij

end

end NumStability
