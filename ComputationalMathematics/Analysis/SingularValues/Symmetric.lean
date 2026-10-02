import ComputationalMathematics.Analysis.MatrixSpectral
import Mathlib.Analysis.InnerProductSpace.PiL2

/-!
# Singular values of real symmetric matrices

This module packages the real Hermitian eigenbasis as a full signed SVD.  The
right vectors are the eigenbasis vectors, the left vectors differ only by the
sign of the corresponding eigenvalue, and the singular values are the absolute
eigenvalues.
-/

namespace NumStability

open scoped BigOperators

/-- A full signed SVD certificate for a real symmetric square matrix. -/
structure IsSymmetricRealMatrixSVD {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ)
    (eigenvalue singularValue : Fin n → ℝ)
    (leftVector rightVector : Fin n → EuclideanSpace ℝ (Fin n)) : Prop where
  singularValue_eq_abs_eigenvalue : ∀ a,
    singularValue a = |eigenvalue a|
  leftVectors_orthonormal : Orthonormal ℝ leftVector
  rightVectors_orthonormal : Orthonormal ℝ rightVector
  leftVector_eigenvector : ∀ a i,
    (∑ j : Fin n, A i j * leftVector a j) =
      eigenvalue a * leftVector a i
  rightVector_eigenvector : ∀ a i,
    (∑ j : Fin n, A i j * rightVector a j) =
      eigenvalue a * rightVector a i
  reconstruction : ∀ i j,
    A i j = ∑ a : Fin n,
      singularValue a * leftVector a i * rightVector a j

/-- The sign choice used to turn a symmetric spectral decomposition into an
SVD while retaining eigenvectors on both sides. -/
noncomputable def symmetricSVDLeftVector {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian)
    (a : Fin n) : EuclideanSpace ℝ (Fin n) :=
  if hA.eigenvalues a < 0 then -hA.eigenvectorBasis a
  else hA.eigenvectorBasis a

/-- Rows of the real Hermitian eigenvector table are orthonormal as well as
its columns. -/
theorem hermitianEigenvectorBasis_row_orthonormal {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian) (i j : Fin n) :
    (∑ a : Fin n,
      hA.eigenvectorBasis a i * hA.eigenvectorBasis a j) =
        if i = j then 1 else 0 := by
  let U := hA.eigenvectorUnitary
  have h := Unitary.coe_mul_star_self U
  have hij := congr_fun (congr_fun h i) j
  simpa [U, Matrix.mul_apply, Matrix.one_apply,
    Matrix.IsHermitian.eigenvectorUnitary_apply] using hij

/-- Entrywise spectral reconstruction from the real Hermitian eigenbasis. -/
theorem hermitianEigenvectorBasis_reconstruction {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian) (i j : Fin n) :
    A i j = ∑ a : Fin n,
      hA.eigenvalues a * hA.eigenvectorBasis a i *
        hA.eigenvectorBasis a j := by
  calc
    A i j = ∑ k : Fin n, A i k * (if k = j then 1 else 0) := by
      simp
    _ = ∑ k : Fin n, A i k *
        (∑ a : Fin n,
          hA.eigenvectorBasis a k * hA.eigenvectorBasis a j) := by
      apply Finset.sum_congr rfl
      intro k _
      rw [hermitianEigenvectorBasis_row_orthonormal hA k j]
    _ = ∑ k : Fin n, ∑ a : Fin n,
        A i k * (hA.eigenvectorBasis a k *
          hA.eigenvectorBasis a j) := by
      apply Finset.sum_congr rfl
      intro k _
      rw [Finset.mul_sum]
    _ = ∑ a : Fin n, ∑ k : Fin n,
        A i k * (hA.eigenvectorBasis a k *
          hA.eigenvectorBasis a j) := by
      rw [Finset.sum_comm]
    _ = ∑ a : Fin n,
        hA.eigenvalues a * hA.eigenvectorBasis a i *
          hA.eigenvectorBasis a j := by
      apply Finset.sum_congr rfl
      intro a _
      have heig := congrFun (hA.mulVec_eigenvectorBasis a) i
      rw [show
        (∑ k : Fin n,
          A i k * (hA.eigenvectorBasis a k *
            hA.eigenvectorBasis a j)) =
          (∑ k : Fin n, A i k * hA.eigenvectorBasis a k) *
            hA.eigenvectorBasis a j by
        rw [Finset.sum_mul]
        apply Finset.sum_congr rfl
        intro k _
        ring]
      simpa [Matrix.mulVec] using congrArg
        (fun x : ℝ => x * hA.eigenvectorBasis a j) heig

/-- Every finite real symmetric matrix admits a full SVD whose singular values
are the absolute eigenvalues and whose left and right vectors are eigenvectors
of the original matrix. -/
theorem exists_isSymmetricRealMatrixSVD {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsHermitian) :
    ∃ (eigenvalue singularValue : Fin n → ℝ)
      (leftVector rightVector : Fin n → EuclideanSpace ℝ (Fin n)),
      IsSymmetricRealMatrixSVD A eigenvalue singularValue
        leftVector rightVector := by
  let eigenvalue : Fin n → ℝ := hA.eigenvalues
  let singularValue : Fin n → ℝ := fun a => |eigenvalue a|
  let rightVector : Fin n → EuclideanSpace ℝ (Fin n) := hA.eigenvectorBasis
  let leftVector : Fin n → EuclideanSpace ℝ (Fin n) :=
    symmetricSVDLeftVector hA
  refine ⟨eigenvalue, singularValue, leftVector, rightVector, ?_⟩
  refine
    { singularValue_eq_abs_eigenvalue := ?_
      leftVectors_orthonormal := ?_
      rightVectors_orthonormal := ?_
      leftVector_eigenvector := ?_
      rightVector_eigenvector := ?_
      reconstruction := ?_ }
  · intro a
    rfl
  · rw [orthonormal_iff_ite]
    intro a b
    unfold leftVector symmetricSVDLeftVector
    have hq := (orthonormal_iff_ite.mp hA.eigenvectorBasis.orthonormal) a b
    by_cases ha : hA.eigenvalues a < 0 <;>
      by_cases hb : hA.eigenvalues b < 0
    · by_cases hab : a = b
      · subst b
        simpa [ha] using hq
      · have hq0 := hq
        rw [if_neg hab] at hq0
        simp only [ha, hb, hab, if_true, if_false]
        simpa [hq0]
    · have hab : a ≠ b := by
        intro hab
        subst b
        exact hb ha
      have hq0 := hq
      rw [if_neg hab] at hq0
      simp only [ha, hb, hab, if_true, if_false]
      simpa [hq0]
    · have hab : a ≠ b := by
        intro hab
        subst b
        exact ha hb
      have hq0 := hq
      rw [if_neg hab] at hq0
      simp only [ha, hb, hab, if_true, if_false]
      simpa [hq0]
    · by_cases hab : a = b
      · subst b
        simpa [ha] using hq
      · have hq0 := hq
        rw [if_neg hab] at hq0
        simp only [ha, hb, hab, if_true, if_false]
        simpa [hq0]
  · exact hA.eigenvectorBasis.orthonormal
  · intro a i
    have heig := congrFun (hA.mulVec_eigenvectorBasis a) i
    unfold leftVector symmetricSVDLeftVector eigenvalue
    by_cases ha : hA.eigenvalues a < 0
    · simp only [ha, if_true]
      simpa [Matrix.mulVec] using congrArg Neg.neg heig
    · simp only [ha, if_false]
      simpa [Matrix.mulVec] using heig
  · intro a i
    have heig := congrFun (hA.mulVec_eigenvectorBasis a) i
    simpa [rightVector, eigenvalue, Matrix.mulVec] using heig
  · intro i j
    rw [hermitianEigenvectorBasis_reconstruction hA i j]
    apply Finset.sum_congr rfl
    intro a _
    unfold singularValue leftVector rightVector eigenvalue
      symmetricSVDLeftVector
    by_cases ha : hA.eigenvalues a < 0
    · rw [if_pos ha, abs_of_neg ha]
      change
        hA.eigenvalues a * hA.eigenvectorBasis a i *
            hA.eigenvectorBasis a j =
          (-hA.eigenvalues a) * (-hA.eigenvectorBasis a i) *
            hA.eigenvectorBasis a j
      ring
    · rw [if_neg ha, abs_of_nonneg (le_of_not_gt ha)]

end NumStability
