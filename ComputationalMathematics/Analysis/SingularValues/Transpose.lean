import ComputationalMathematics.Analysis.SingularValues.EckartYoung
import ComputationalMathematics.Analysis.SingularValues.RealSVDTranspose
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LowRankApproximation.ColumnSketches.RealSVD
import Mathlib.Analysis.Matrix.Spectrum
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic

/-!
# Transpose and the common Gram spectrum

Transpose transport retains the singular families of an existing SVD. Canonical
uniqueness then identifies the ordered singular values at every index present
in both actual dimensions, including the zero tail after the rank.
-/

namespace NumStability

private theorem hermitianEigenvalues_complexification {n : ℕ}
    {G : Matrix (Fin n) (Fin n) ℝ} (hG : G.IsHermitian)
    (hC : (G.map Complex.ofReal).IsHermitian) :
    hC.eigenvalues₀ = hG.eigenvalues₀ := by
  apply List.ofFn_inj.mp
  rw [← hC.sort_roots_charpoly_eq_eigenvalues₀,
    ← hG.sort_roots_charpoly_eq_eigenvalues₀]
  rw [show (G.map Complex.ofReal).charpoly = G.charpoly.map Complex.ofRealHom from
      Matrix.charpoly_map G Complex.ofRealHom,
    hG.splits_charpoly.roots_map Complex.ofRealHom]
  simp [Multiset.map_map]

private theorem rectRightGram_complexification_toEuclideanLin {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    Matrix.toEuclideanLin (Matrix.map (rectRightGram A) Complex.ofReal) =
      complexMatrixGramLin (realRectToCMatrix A) := by
  apply (LinearMap.toMatrix (complexEuclideanBasisFin n)
    (complexEuclideanBasisFin n)).injective
  rw [Matrix.toEuclideanLin_eq_toLin_orthonormal,
    LinearMap.toMatrix_toLin, complexMatrixGramLin_toMatrix]
  ext i j
  simp [rectRightGram, Matrix.mul_apply, realRectToCMatrix, complexCMatrixAsMatrix,
    Complex.ofReal_sum]

/-- The actual ordered eigenvalues of the real right Gram coincide with the
canonical complexified Gram eigenvalues, with no change of indexing. -/
theorem rectSingularValueSq_eq_complexMatrixGramEigenvalues {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (i : Fin n) :
    rectSingularValueSq A i = complexMatrixGramEigenvalues (realRectToCMatrix A) i := by
  let hG := (rectRightGram_matrix_posSemidef A).1
  have hC : (Matrix.map (rectRightGram A) Complex.ofReal).IsHermitian :=
    hG.map Complex.ofReal (by intro x; simp)
  have he := congrFun (hermitianEigenvalues_complexification hG hC) (finCardIndex n i)
  rw [rectSingularValueSq, ← he]
  unfold Matrix.IsHermitian.eigenvalues₀ complexMatrixGramEigenvalues
  simp only [rectRightGram_complexification_toEuclideanLin, finCardIndex]
  congr 1 <;> try simp
  exact (Fin.heq_ext_iff (Fintype.card_fin n)).mpr rfl

/-- The real right-Gram square-root sequence is the canonical singular-value
sequence used by uniqueness of SVD certificates. -/
theorem rectSingularValue_eq_canonical {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (i : Fin n) :
    rectSingularValue A i = complexMatrixSingularValue (realRectToCMatrix A) i := by
  unfold rectSingularValue complexMatrixSingularValue
  rw [rectSingularValueSq_eq_complexMatrixGramEigenvalues]

/-- Every supplied ordered real SVD has exactly the actual ordered real
right-Gram singular-value sequence, including its zero tail. -/
theorem IsRealMatrixSVD.singularValue_eq_rectSingularValue {m n r : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ} {s : Fin n → ℝ}
    {u : Fin r → EuclideanSpace ℝ (Fin m)}
    {v : Fin r → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A r s u v) (i : Fin n) : s i = rectSingularValue A i :=
  (h.singularValue_eq_canonical i).trans (rectSingularValue_eq_canonical A i).symm

/-- The canonical singular values of a real rectangular matrix and its
transpose agree at every index present in both dimensions. -/
theorem realRectToCMatrix_singularValue_transpose {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (i : ℕ) (him : i < m) (hin : i < n) :
    complexMatrixSingularValue (realRectToCMatrix A.transpose) ⟨i, him⟩ =
      complexMatrixSingularValue (realRectToCMatrix A) ⟨i, hin⟩ := by
  obtain ⟨r, s, u, v, h⟩ := exists_isRealMatrixSVDWithGramEigenrelations A
  rw [← h.toIsRealMatrixSVD.transpose.singularValue_eq_canonical,
    ← h.toIsRealMatrixSVD.singularValue_eq_canonical]
  exact realSVDTransposeSingularValues_eq s ⟨i, him⟩ hin

/-- The ordered eigenvalue lists of the two actual Gram operators agree at
every common index. The left list has length `m`; the right list has length
`n`. Neither list is extended beyond its dimension. -/
theorem realRectToCMatrix_gramEigenvalues_transpose {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (i : ℕ) (him : i < m) (hin : i < n) :
    complexMatrixGramEigenvalues (realRectToCMatrix A.transpose) ⟨i, him⟩ =
      complexMatrixGramEigenvalues (realRectToCMatrix A) ⟨i, hin⟩ := by
  rw [← complexMatrixSingularValue_sq, ← complexMatrixSingularValue_sq,
    realRectToCMatrix_singularValue_transpose A i him hin]

/-- At every common actual spectral index the singular value is the square
root of both the `m`-dimensional left-Gram eigenvalue and the `n`-dimensional
right-Gram eigenvalue, including zero eigenvalues. -/
theorem realRectToCMatrix_singularValue_eq_sqrt_both_gramEigenvalues {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (i : ℕ) (him : i < m) (hin : i < n) :
    complexMatrixSingularValue (realRectToCMatrix A) ⟨i, hin⟩ =
        Real.sqrt (complexMatrixGramEigenvalues (realRectToCMatrix A.transpose) ⟨i, him⟩) ∧
      complexMatrixSingularValue (realRectToCMatrix A) ⟨i, hin⟩ =
        Real.sqrt (complexMatrixGramEigenvalues (realRectToCMatrix A) ⟨i, hin⟩) := by
  constructor
  · exact (realRectToCMatrix_singularValue_transpose A i him hin).symm
  · rfl

/-- The two real Gram singular-value sequences agree at every common actual
index, including indices at or beyond the rank. -/
theorem rectSingularValue_transpose {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (i : ℕ) (him : i < m) (hin : i < n) :
    rectSingularValue A.transpose ⟨i, him⟩ = rectSingularValue A ⟨i, hin⟩ := by
  rw [rectSingularValue_eq_canonical, rectSingularValue_eq_canonical]
  exact realRectToCMatrix_singularValue_transpose A i him hin

/-- The actual real left-Gram and right-Gram ordered eigenvalues agree on the
common prefix. The left Gram has `m` eigenvalues and the right Gram has `n`. -/
theorem rectSingularValueSq_transpose {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (i : ℕ) (him : i < m) (hin : i < n) :
    rectSingularValueSq A.transpose ⟨i, him⟩ = rectSingularValueSq A ⟨i, hin⟩ := by
  rw [← rectSingularValue_sq_eq, ← rectSingularValue_sq_eq,
    rectSingularValue_transpose A i him hin]

/-- The right Gram of the transpose is exactly the actual left Gram `AAᵀ`. -/
theorem rectRightGram_transpose_eq_mul_transpose {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    (rectRightGram A.transpose : Matrix (Fin m) (Fin m) ℝ) = A * A.transpose := by
  rw [rectRightGram_eq_transpose_mul_self, Matrix.transpose_transpose]

/-- Square roots of both actual real Gram eigenvalue lists compute the same
singular value at each common index. These lists retain their separate actual
dimensions, and the statement includes zero eigenvalues after the rank. -/
theorem rectSingularValue_eq_sqrt_both_gramEigenvalues {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (i : Fin (min m n)) :
    rectSingularValue A (Fin.castLE (Nat.min_le_right m n) i) =
        Real.sqrt ((rectRightGram_matrix_posSemidef A.transpose).1.eigenvalues₀
          (finCardIndex m (Fin.castLE (Nat.min_le_left m n) i))) ∧
      rectSingularValue A (Fin.castLE (Nat.min_le_right m n) i) =
        Real.sqrt ((rectRightGram_matrix_posSemidef A).1.eigenvalues₀
          (finCardIndex n (Fin.castLE (Nat.min_le_right m n) i))) := by
  constructor
  · exact (rectSingularValue_transpose A i.val
      (i.isLt.trans_le (Nat.min_le_left m n))
      (i.isLt.trans_le (Nat.min_le_right m n))).symm
  · rfl

end NumStability
