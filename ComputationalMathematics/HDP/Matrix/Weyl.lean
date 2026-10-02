import ComputationalMathematics.Analysis.Eigenvalues.CourantFischer
import ComputationalMathematics.Analysis.OperatorNorms.RealMatrix

/-!
# Weyl eigenvalue perturbation inequality
-/

noncomputable section

open scoped RealInnerProductSpace

namespace NumStability.HDP.Matrix

private theorem rayleigh_le_realMatrixOperatorNorm
    {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (x : EuclideanSpace ℝ (Fin n)) (hx : ‖x‖ = 1) :
    NumStability.matrixRayleighForm A x ≤
      NumStability.realMatrixOperatorNorm A := by
  calc
    NumStability.matrixRayleighForm A x =
        inner ℝ x (Matrix.toEuclideanLin A x) := rfl
    _ ≤ |inner ℝ x (Matrix.toEuclideanLin A x)| := le_abs_self _
    _ ≤ ‖x‖ * ‖Matrix.toEuclideanLin A x‖ := abs_real_inner_le_norm _ _
    _ = ‖Matrix.toEuclideanLin A x‖ := by rw [hx, one_mul]
    _ ≤ ‖NumStability.realMatrixContinuousLinearMap A‖ * ‖x‖ := by
      simpa [NumStability.realMatrixContinuousLinearMap] using
        ContinuousLinearMap.le_opNorm
          (NumStability.realMatrixContinuousLinearMap A) x
    _ = NumStability.realMatrixOperatorNorm A := by
      rw [hx, mul_one]
      rfl

private theorem rayleigh_sub
    {n : ℕ} (S T : Matrix (Fin n) (Fin n) ℝ)
    (x : EuclideanSpace ℝ (Fin n)) :
    NumStability.matrixRayleighForm S x =
      NumStability.matrixRayleighForm T x +
        NumStability.matrixRayleighForm (S - T) x := by
  simp [NumStability.matrixRayleighForm, Matrix.toEuclideanLin_apply,
    Matrix.sub_mulVec, inner_sub_right]

/-- One-sided Weyl inequality for decreasingly ordered eigenvalues of real
Hermitian matrices. -/
theorem hermitianOrderedEigenvalue_le_add_operatorNorm_sub
    {n : ℕ} (S T : Matrix (Fin n) (Fin n) ℝ)
    (hS : S.IsHermitian) (hT : T.IsHermitian) (i : Fin n) :
    NumStability.hermitianOrderedEigenvalue hS i ≤
      NumStability.hermitianOrderedEigenvalue hT i +
        NumStability.realMatrixOperatorNorm (S - T) := by
  obtain ⟨E, hErank, hSlower, _hSattain, _hSall⟩ :=
    NumStability.hermitian_courantFischer_maxMin S hS i
  obtain ⟨_F, _hFrank, _hTlower, _hTattain, hTall⟩ :=
    NumStability.hermitian_courantFischer_maxMin T hT i
  obtain ⟨x, hxE, hxnorm, hTx⟩ := hTall E hErank
  have hSx := hSlower x hxE hxnorm
  have hDx := rayleigh_le_realMatrixOperatorNorm (S - T) x hxnorm
  rw [rayleigh_sub S T x] at hSx
  linarith

private theorem realMatrixOperatorNorm_sub_comm
    {n : ℕ} (S T : Matrix (Fin n) (Fin n) ℝ) :
    NumStability.realMatrixOperatorNorm (T - S) =
      NumStability.realMatrixOperatorNorm (S - T) := by
  have hTS : NumStability.realMatrixContinuousLinearMap (T - S) =
      NumStability.realMatrixContinuousLinearMap T -
        NumStability.realMatrixContinuousLinearMap S := by
    ext x i
    simp [NumStability.realMatrixContinuousLinearMap,
      Matrix.toEuclideanLin_apply, Matrix.sub_mulVec]
  have hST : NumStability.realMatrixContinuousLinearMap (S - T) =
      NumStability.realMatrixContinuousLinearMap S -
        NumStability.realMatrixContinuousLinearMap T := by
    ext x i
    simp [NumStability.realMatrixContinuousLinearMap,
      Matrix.toEuclideanLin_apply, Matrix.sub_mulVec]
  rw [NumStability.realMatrixOperatorNorm, NumStability.realMatrixOperatorNorm,
    hTS, hST]
  exact norm_sub_rev _ _

/-- Weyl's inequality: every ordered eigenvalue of two real Hermitian
matrices differs by at most the operator norm of their difference. -/
theorem abs_hermitianOrderedEigenvalue_sub_le_operatorNorm
    {n : ℕ} (S T : Matrix (Fin n) (Fin n) ℝ)
    (hS : S.IsHermitian) (hT : T.IsHermitian) (i : Fin n) :
    |NumStability.hermitianOrderedEigenvalue hS i -
        NumStability.hermitianOrderedEigenvalue hT i| ≤
      NumStability.realMatrixOperatorNorm (S - T) := by
  rw [abs_le]
  constructor
  · have h := hermitianOrderedEigenvalue_le_add_operatorNorm_sub T S hT hS i
    rw [realMatrixOperatorNorm_sub_comm S T] at h
    linarith
  · have h := hermitianOrderedEigenvalue_le_add_operatorNorm_sub S T hS hT i
    linarith

end NumStability.HDP.Matrix
