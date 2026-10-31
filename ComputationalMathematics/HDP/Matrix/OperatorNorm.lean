import ComputationalMathematics.Analysis.OperatorNorms.RealMatrix

/-!
# Submultiplicativity of the finite real matrix operator norm
-/

noncomputable section

namespace NumStability.HDP.Matrix

/-- The Euclidean matrix operator norm is submultiplicative. -/
theorem realMatrixOperatorNorm_mul_le {l m n : ℕ}
    (A : Matrix (Fin l) (Fin m) ℝ) (B : Matrix (Fin m) (Fin n) ℝ) :
    ‖NumStability.realMatrixContinuousLinearMap (A * B)‖ ≤
      ‖NumStability.realMatrixContinuousLinearMap A‖ *
        ‖NumStability.realMatrixContinuousLinearMap B‖ := by
  have hcomp : NumStability.realMatrixContinuousLinearMap (A * B) =
      (NumStability.realMatrixContinuousLinearMap A).comp
        (NumStability.realMatrixContinuousLinearMap B) := by
    ext x i
    change ((A * B).mulVec x) i = (A.mulVec (B.mulVec x)) i
    rw [Matrix.mulVec_mulVec]
  rw [hcomp]
  exact ContinuousLinearMap.opNorm_comp_le _ _

/-- The norm of a symmetric sandwich is bounded by the middle factor times
the square of the outer factor's norm. -/
theorem realMatrixOperatorNorm_sandwich_le {n : ℕ}
    (S R : Matrix (Fin n) (Fin n) ℝ) :
    ‖NumStability.realMatrixContinuousLinearMap (S * R * S)‖ ≤
      ‖NumStability.realMatrixContinuousLinearMap R‖ *
        ‖NumStability.realMatrixContinuousLinearMap S‖ ^ 2 := by
  calc
    ‖NumStability.realMatrixContinuousLinearMap (S * R * S)‖ ≤
        ‖NumStability.realMatrixContinuousLinearMap (S * R)‖ *
          ‖NumStability.realMatrixContinuousLinearMap S‖ :=
      realMatrixOperatorNorm_mul_le (S * R) S
    _ ≤ (‖NumStability.realMatrixContinuousLinearMap S‖ *
          ‖NumStability.realMatrixContinuousLinearMap R‖) *
          ‖NumStability.realMatrixContinuousLinearMap S‖ := by
      gcongr
      exact realMatrixOperatorNorm_mul_le S R
    _ = ‖NumStability.realMatrixContinuousLinearMap R‖ *
        ‖NumStability.realMatrixContinuousLinearMap S‖ ^ 2 := by ring

end NumStability.HDP.Matrix
