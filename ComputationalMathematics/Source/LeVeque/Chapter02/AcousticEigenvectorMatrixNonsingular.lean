/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticEigenvectorMatrixNonsingularTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticEigenvectorMatrixInverse

/-!
# Nonsingular acoustic eigenvector matrix and its inverse
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.66) and its preceding nonsingularity condition. The inverse
formula is reused; the determinant calculation supplies the explicit condition. -/
theorem acousticEigenvectorMatrixNonsingular :
    acousticEigenvectorMatrixNonsingularTarget := by
  intro density soundSpeed hImpedance
  constructor
  · have hdet :
        (linearAcousticsEigenvectorMatrix density soundSpeed).det =
          -2 * acousticImpedance density soundSpeed := by
      simp [linearAcousticsEigenvectorMatrix, acousticImpedance,
        Matrix.det_fin_two_of]
      ring
    rw [hdet]
    exact mul_ne_zero (by norm_num) (ne_of_gt hImpedance)
  · exact acousticEigenvectorMatrixInverse density soundSpeed hImpedance

end NumStability.Leveque02Tracer
