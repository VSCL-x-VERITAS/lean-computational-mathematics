import ComputationalMathematics.Analysis.SingularValues.Basic
import Mathlib.Data.Fin.Embedding

/-!
# Coordinate embeddings and zero padding

A finite coordinate injection gives an isometric matrix, including when its
source has dimension zero. Rectangular products can consequently be embedded
into square matrices without increasing their Euclidean operator norms.
-/
namespace NumStability
open scoped BigOperators

/-- The coordinate injection associated to an embedding of finite index sets. -/
noncomputable def complexCoordinateEmbedding {m d : ℕ} (e : Fin m ↪ Fin d) :
    CMatrix d m := fun i a => if i = e a then 1 else 0

/-- Coordinate injections have identity left Gram matrix. -/
theorem complexCoordinateEmbedding_adjoint_mul_self {m d : ℕ} (e : Fin m ↪ Fin d) :
    complexMatrixMul (complexMatrixAdjoint (complexCoordinateEmbedding e))
      (complexCoordinateEmbedding e) = (1 : Matrix (Fin m) (Fin m) ℂ) := by
  classical
  ext a b
  simp [complexMatrixMul, complexMatrixAdjoint, complexMatrixTranspose,
    complexConjMatrix, complexCoordinateEmbedding, mul_ite,
    e.injective.eq_iff, Matrix.one_apply, eq_comm]

/-- Left multiplication by an identity matrix in the rectangular carrier. -/
@[simp] theorem complexMatrixMul_one_left {m n : ℕ} (A : CMatrix m n) :
    complexMatrixMul (1 : Matrix (Fin m) (Fin m) ℂ) A = A := by
  ext i j
  simp [complexMatrixMul, Matrix.one_apply]

/-- Right multiplication by an identity matrix in the rectangular carrier. -/
@[simp] theorem complexMatrixMul_one_right {m n : ℕ} (A : CMatrix m n) :
    complexMatrixMul A (1 : Matrix (Fin n) (Fin n) ℂ) = A := by
  ext i j
  simp [complexMatrixMul, Matrix.one_apply]

/-- Euclidean operator norm is submultiplicative for rectangular matrices. -/
theorem complexMatrixOp2_mul_le {m n p : ℕ} (A : CMatrix m n) (B : CMatrix n p) :
    complexMatrixOp2 (complexMatrixMul A B) ≤ complexMatrixOp2 A * complexMatrixOp2 B := by
  rw [complexMatrixOp2_eq_norm_euclideanLin,
    complexMatrixOp2_eq_norm_euclideanLin, complexMatrixOp2_eq_norm_euclideanLin]
  have hmaps :
      (complexMatrixEuclideanLin (complexMatrixMul A B)).toContinuousLinearMap =
        (complexMatrixEuclideanLin A).toContinuousLinearMap.comp
          (complexMatrixEuclideanLin B).toContinuousLinearMap := by
    apply ContinuousLinearMap.ext
    intro x
    exact complexMatrixEuclideanLin_mul A B x
  rw [hmaps]
  exact ContinuousLinearMap.opNorm_comp_le _ _

/-- Identity matrices have operator norm at most one, also in dimension zero. -/
theorem complexMatrixOp2_one_le (n : ℕ) :
    complexMatrixOp2 (1 : Matrix (Fin n) (Fin n) ℂ) ≤ 1 := by
  rw [complexMatrixOp2_eq_norm_euclideanLin]
  have hid : complexMatrixEuclideanLin (1 : Matrix (Fin n) (Fin n) ℂ) =
      (LinearMap.id : EuclideanSpace ℂ (Fin n) →ₗ[ℂ] EuclideanSpace ℂ (Fin n)) := by
    ext x i
    simp [complexMatrixEuclideanLin]
  rw [hid]
  exact ContinuousLinearMap.norm_id_le

/-- A coordinate injection is contractive in Euclidean operator norm. -/
theorem complexCoordinateEmbedding_op2_le_one {m d : ℕ} (e : Fin m ↪ Fin d) :
    complexMatrixOp2 (complexCoordinateEmbedding e) ≤ 1 := by
  have hsq := complexMatrixOp2_adjoint_mul_self_eq_sq (complexCoordinateEmbedding e)
  rw [complexCoordinateEmbedding_adjoint_mul_self] at hsq
  have hid := complexMatrixOp2_one_le m
  nlinarith [complexMatrixOp2_nonneg (complexCoordinateEmbedding e)]

/-- The adjoint coordinate restriction is also contractive. -/
theorem complexCoordinateEmbedding_adjoint_op2_le_one {m d : ℕ} (e : Fin m ↪ Fin d) :
    complexMatrixOp2 (complexMatrixAdjoint (complexCoordinateEmbedding e)) ≤ 1 := by
  rw [complexMatrixOp2_adjoint_eq]
  exact complexCoordinateEmbedding_op2_le_one e

/-- Extend a rectangular matrix by zero along arbitrary row/column injections. -/
noncomputable def complexMatrixZeroPad {m n d f : ℕ}
    (er : Fin m ↪ Fin d) (ec : Fin n ↪ Fin f) (A : CMatrix m n) : CMatrix d f :=
  complexMatrixMul (complexMatrixMul (complexCoordinateEmbedding er) A)
    (complexMatrixAdjoint (complexCoordinateEmbedding ec))

/-- A padded matrix acts on an injected input by injecting its original output. -/
theorem complexMatrixZeroPad_mul_embedding {m n d f : ℕ}
    (er : Fin m ↪ Fin d) (ec : Fin n ↪ Fin f) (A : CMatrix m n) :
    complexMatrixMul (complexMatrixZeroPad er ec A) (complexCoordinateEmbedding ec) =
      complexMatrixMul (complexCoordinateEmbedding er) A := by
  unfold complexMatrixZeroPad
  rw [complexMatrixMul_assoc, complexCoordinateEmbedding_adjoint_mul_self,
    complexMatrixMul_one_right]

/-- Compatible coordinate paddings commute with matrix multiplication. -/
theorem complexMatrixZeroPad_mul {m n p d f g : ℕ}
    (er : Fin m ↪ Fin d) (ec : Fin n ↪ Fin f) (ep : Fin p ↪ Fin g)
    (A : CMatrix m n) (B : CMatrix n p) :
    complexMatrixMul (complexMatrixZeroPad er ec A) (complexMatrixZeroPad ec ep B) =
      complexMatrixZeroPad er ep (complexMatrixMul A B) := by
  have h := complexMatrixZeroPad_mul_embedding er ec A
  unfold complexMatrixZeroPad at h ⊢
  rw [← complexMatrixMul_assoc, ← complexMatrixMul_assoc, h]
  simp only [complexMatrixMul_assoc]

/-- Zero padding does not increase the Euclidean operator norm. -/
theorem complexMatrixZeroPad_op2_le {m n d f : ℕ}
    (er : Fin m ↪ Fin d) (ec : Fin n ↪ Fin f) (A : CMatrix m n) :
    complexMatrixOp2 (complexMatrixZeroPad er ec A) ≤ complexMatrixOp2 A := by
  unfold complexMatrixZeroPad
  have hleft : complexMatrixOp2 (complexMatrixMul (complexCoordinateEmbedding er) A) ≤
      complexMatrixOp2 A :=
    (complexMatrixOp2_mul_le _ _).trans (by
      simpa using mul_le_mul_of_nonneg_right (complexCoordinateEmbedding_op2_le_one er)
        (complexMatrixOp2_nonneg A))
  exact (complexMatrixOp2_mul_le _ _).trans
    ((mul_le_mul_of_nonneg_left (complexCoordinateEmbedding_adjoint_op2_le_one ec)
      (complexMatrixOp2_nonneg _)).trans (by simpa using hleft))

/-- Restricting a padded matrix to the original coordinates recovers it. -/
theorem complexMatrixZeroPad_recover {m n d f : ℕ}
    (er : Fin m ↪ Fin d) (ec : Fin n ↪ Fin f) (A : CMatrix m n) :
    complexMatrixMul
      (complexMatrixMul (complexMatrixAdjoint (complexCoordinateEmbedding er))
        (complexMatrixZeroPad er ec A)) (complexCoordinateEmbedding ec) = A := by
  rw [complexMatrixMul_assoc, complexMatrixZeroPad_mul_embedding,
    ← complexMatrixMul_assoc, complexCoordinateEmbedding_adjoint_mul_self,
    complexMatrixMul_one_left]

/-- Zero padding preserves the Euclidean operator norm exactly. -/
theorem complexMatrixZeroPad_op2_eq {m n d f : ℕ}
    (er : Fin m ↪ Fin d) (ec : Fin n ↪ Fin f) (A : CMatrix m n) :
    complexMatrixOp2 (complexMatrixZeroPad er ec A) = complexMatrixOp2 A := by
  apply le_antisymm (complexMatrixZeroPad_op2_le er ec A)
  let P := complexMatrixZeroPad er ec A
  have hleft : complexMatrixOp2
      (complexMatrixMul (complexMatrixAdjoint (complexCoordinateEmbedding er)) P) ≤
      complexMatrixOp2 P :=
    (complexMatrixOp2_mul_le _ _).trans (by
      simpa using mul_le_mul_of_nonneg_right
        (complexCoordinateEmbedding_adjoint_op2_le_one er) (complexMatrixOp2_nonneg P))
  have hright : complexMatrixOp2
      (complexMatrixMul
        (complexMatrixMul (complexMatrixAdjoint (complexCoordinateEmbedding er)) P)
        (complexCoordinateEmbedding ec)) ≤ complexMatrixOp2 P :=
    (complexMatrixOp2_mul_le _ _).trans
      ((mul_le_mul_of_nonneg_left (complexCoordinateEmbedding_op2_le_one ec)
        (complexMatrixOp2_nonneg _)).trans (by simpa using hleft))
  simpa only [P, complexMatrixZeroPad_recover] using hright

end NumStability
