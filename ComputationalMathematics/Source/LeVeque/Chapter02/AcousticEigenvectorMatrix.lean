/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticEigenvectorMatrixTarget

/-!
# Ordered acoustic eigenvector matrix
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.63): the explicit matrix has the left-going acoustic
eigenvector as its first column and the right-going eigenvector as its second. -/
theorem acousticEigenvectorMatrix : acousticEigenvectorMatrixTarget := by
  intro density soundSpeed
  constructor
  · funext i
    fin_cases i <;>
      simp [linearAcousticsEigenvectorMatrix, linearAcousticsLeftEigenvector]
  · funext i
    fin_cases i <;>
      simp [linearAcousticsEigenvectorMatrix, linearAcousticsRightEigenvector]

end NumStability.Leveque02Tracer
