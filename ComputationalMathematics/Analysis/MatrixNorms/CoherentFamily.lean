import ComputationalMathematics.Analysis.MatrixNorms.SquareContraction
import ComputationalMathematics.Analysis.MatrixNorms.ZeroPadding

/-! # Dimension-coherent unitarily invariant norm families

The source-facing fields are fixed-shape norm laws and exact invariance under
isometric embeddings. Rectangular operator-ideal inequalities are derived from
this coherence and the square-contraction midpoint theorem.
-/
namespace NumStability

structure ComplexMatrixUnitaryInvariantNormFamily where
  fixed : (m n : ℕ) → ComplexMatrixFixedUnitaryInvariantNorm m n
  left_isometry : ∀ {m n p : ℕ} (E : CMatrix p m) (A : CMatrix m n),
    complexMatrixMul (complexMatrixAdjoint E) E = (1 : Matrix (Fin m) (Fin m) ℂ) →
    (fixed p n).norm (complexMatrixMul E A) = (fixed m n).norm A
  right_isometry : ∀ {m n p : ℕ} (A : CMatrix m n) (E : CMatrix p n),
    complexMatrixMul (complexMatrixAdjoint E) E = (1 : Matrix (Fin n) (Fin n) ℂ) →
    (fixed m p).norm (complexMatrixMul A (complexMatrixAdjoint E)) = (fixed m n).norm A

namespace ComplexMatrixUnitaryInvariantNormFamily

/-- Rectangular left product bound, derived from square contractions and
isometric coherence; it is not a field of the norm-family interface. -/
theorem left_mul_le (N : ComplexMatrixUnitaryInvariantNormFamily)
    {m n p : ℕ} (L : CMatrix p m) (A : CMatrix m n) :
    (N.fixed p n).norm (complexMatrixMul L A) ≤
      complexMatrixOp2 L * (N.fixed m n).norm A := by
  let e : Fin m ↪ Fin (m + p) := Fin.castAddEmb p
  let f : Fin p ↪ Fin (m + p) := Fin.natAddEmb m
  let E := complexCoordinateEmbedding e
  let F := complexCoordinateEmbedding f
  let M := complexMatrixZeroPad f e L
  have hE : complexMatrixMul (complexMatrixAdjoint E) E =
      (1 : Matrix (Fin m) (Fin m) ℂ) := complexCoordinateEmbedding_adjoint_mul_self e
  have hF : complexMatrixMul (complexMatrixAdjoint F) F =
      (1 : Matrix (Fin p) (Fin p) ℂ) := complexCoordinateEmbedding_adjoint_mul_self f
  have hinter : complexMatrixMul M (complexMatrixMul E A) =
      complexMatrixMul F (complexMatrixMul L A) := by
    rw [← complexMatrixMul_assoc, complexMatrixZeroPad_mul_embedding, complexMatrixMul_assoc]
  calc
    (N.fixed p n).norm (complexMatrixMul L A)
        = (N.fixed (m + p) n).norm (complexMatrixMul F (complexMatrixMul L A)) :=
          (N.left_isometry F _ hF).symm
    _ = (N.fixed (m + p) n).norm (complexMatrixMul M (complexMatrixMul E A)) := by rw [hinter]
    _ ≤ complexMatrixOp2 M * (N.fixed (m + p) n).norm (complexMatrixMul E A) :=
      (N.fixed (m + p) n).toOperatorIdealNormOfSVD.left_mul_le M _
    _ ≤ complexMatrixOp2 L * (N.fixed m n).norm A := by
      rw [N.left_isometry E A hE]
      exact mul_le_mul_of_nonneg_right (complexMatrixZeroPad_op2_le f e L)
        ((N.fixed m n).norm_nonneg A)

/-- Rectangular right product bound, derived from square contractions and
isometric coherence. -/
theorem right_mul_le (N : ComplexMatrixUnitaryInvariantNormFamily)
    {m n p : ℕ} (A : CMatrix m n) (R : CMatrix n p) :
    (N.fixed m p).norm (complexMatrixMul A R) ≤
      (N.fixed m n).norm A * complexMatrixOp2 R := by
  let e : Fin n ↪ Fin (n + p) := Fin.castAddEmb p
  let f : Fin p ↪ Fin (n + p) := Fin.natAddEmb n
  let E := complexCoordinateEmbedding e
  let F := complexCoordinateEmbedding f
  let M := complexMatrixZeroPad e f R
  have hE : complexMatrixMul (complexMatrixAdjoint E) E =
      (1 : Matrix (Fin n) (Fin n) ℂ) := complexCoordinateEmbedding_adjoint_mul_self e
  have hF : complexMatrixMul (complexMatrixAdjoint F) F =
      (1 : Matrix (Fin p) (Fin p) ℂ) := complexCoordinateEmbedding_adjoint_mul_self f
  have hinter : complexMatrixMul (complexMatrixMul A (complexMatrixAdjoint E)) M =
      complexMatrixMul (complexMatrixMul A R) (complexMatrixAdjoint F) := by
    dsimp [M, complexMatrixZeroPad]
    simp only [complexMatrixMul_assoc]
    rw [← complexMatrixMul_assoc (complexMatrixAdjoint E) E,
      hE, complexMatrixMul_one_left]
  calc
    (N.fixed m p).norm (complexMatrixMul A R)
        = (N.fixed m (n + p)).norm
            (complexMatrixMul (complexMatrixMul A R) (complexMatrixAdjoint F)) :=
          (N.right_isometry _ F hF).symm
    _ = (N.fixed m (n + p)).norm
        (complexMatrixMul (complexMatrixMul A (complexMatrixAdjoint E)) M) := by rw [hinter]
    _ ≤ (N.fixed m (n + p)).norm (complexMatrixMul A (complexMatrixAdjoint E)) *
        complexMatrixOp2 M :=
      (N.fixed m (n + p)).toOperatorIdealNormOfSVD.right_mul_le _ M
    _ ≤ (N.fixed m n).norm A * complexMatrixOp2 R := by
      rw [N.right_isometry A E hE]
      exact mul_le_mul_of_nonneg_left (complexMatrixZeroPad_op2_le e f R)
        ((N.fixed m n).norm_nonneg A)

/-- Compatibility with the preexisting product-bound API is a theorem of a
bare coherent unitarily invariant family. -/
noncomputable def ideal (N : ComplexMatrixUnitaryInvariantNormFamily) :
    ComplexMatrixOperatorIdealNormFamily where
  norm := fun {m n} A => (N.fixed m n).norm A
  norm_nonneg := fun A => (N.fixed _ _).norm_nonneg A
  left_mul_le := N.left_mul_le
  right_mul_le := N.right_mul_le

theorem compatible (N : ComplexMatrixUnitaryInvariantNormFamily)
    {m n : ℕ} (A : CMatrix m n) : N.ideal.norm A = (N.fixed m n).norm A := rfl

noncomputable def realNorm (N : ComplexMatrixUnitaryInvariantNormFamily)
    {m n : ℕ} (A : Fin m → Fin n → ℝ) : ℝ := N.ideal.norm (realRectToCMatrix A)

theorem realNorm_nonneg (N : ComplexMatrixUnitaryInvariantNormFamily)
    {m n : ℕ} (A : Fin m → Fin n → ℝ) : 0 ≤ N.realNorm A :=
  N.ideal.norm_nonneg _

theorem realNorm_neg (N : ComplexMatrixUnitaryInvariantNormFamily)
    {m n : ℕ} (A : Fin m → Fin n → ℝ) : N.realNorm (-A) = N.realNorm A := by
  have hcast : realRectToCMatrix (-A) = (-1 : ℂ) • realRectToCMatrix A := by
    ext i j
    simp [realRectToCMatrix]
  unfold realNorm
  rw [hcast, N.compatible, N.compatible, (N.fixed m n).smul]
  simp

theorem realNorm_add_le (N : ComplexMatrixUnitaryInvariantNormFamily)
    {m n : ℕ} (A B : Fin m → Fin n → ℝ) :
    N.realNorm (A + B) ≤ N.realNorm A + N.realNorm B := by
  have hcast : realRectToCMatrix (A + B) = realRectToCMatrix A + realRectToCMatrix B := by
    ext i j
    simp [realRectToCMatrix]
  unfold realNorm
  rw [hcast, N.compatible, N.compatible, N.compatible]
  exact (N.fixed m n).add_le _ _

theorem realNorm_sub_le (N : ComplexMatrixUnitaryInvariantNormFamily)
    {m n : ℕ} (A B : Fin m → Fin n → ℝ) :
    N.realNorm (A - B) ≤ N.realNorm A + N.realNorm B := by
  simpa [sub_eq_add_neg, N.realNorm_neg] using N.realNorm_add_le A (-B)

theorem realNorm_mul_left_contraction (N : ComplexMatrixUnitaryInvariantNormFamily)
    {m n p : ℕ} (L : Fin p → Fin m → ℝ) (A : Fin m → Fin n → ℝ)
    (hL : complexMatrixOp2 (realRectToCMatrix L) ≤ 1) :
    N.realNorm (rectMatMul L A) ≤ N.realNorm A := by
  unfold realNorm
  rw [realRectToCMatrix_rectMatMul]
  exact (N.ideal.left_mul_le _ _).trans
    (by simpa using mul_le_mul_of_nonneg_right hL (N.ideal.norm_nonneg _))

theorem realNorm_mul_right_contraction (N : ComplexMatrixUnitaryInvariantNormFamily)
    {m n p : ℕ} (A : Fin m → Fin n → ℝ) (R : Fin n → Fin p → ℝ)
    (hR : complexMatrixOp2 (realRectToCMatrix R) ≤ 1) :
    N.realNorm (rectMatMul A R) ≤ N.realNorm A := by
  unfold realNorm
  rw [realRectToCMatrix_rectMatMul]
  exact (N.ideal.right_mul_le _ _).trans
    (by simpa using mul_le_mul_of_nonneg_left hR (N.ideal.norm_nonneg _))

end ComplexMatrixUnitaryInvariantNormFamily
end NumStability
