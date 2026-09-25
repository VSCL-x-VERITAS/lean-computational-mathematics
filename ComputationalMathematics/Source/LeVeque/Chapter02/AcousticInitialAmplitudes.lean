/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticInitialAmplitudesTarget

/-!
# Acoustic initial wave amplitudes
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.64): the ordered eigenvector columns multiply the two
time-zero profile values to recover the initial acoustic state. -/
theorem acousticInitialAmplitudes : acousticInitialAmplitudesTarget := by
  intro density soundSpeed pressure velocity leftProfile rightProfile hform x
  rw [hform x 0]
  funext i
  fin_cases i <;>
    simp [linearAcousticsEigenvectorMatrix, linearAcousticsLeftEigenvector,
      linearAcousticsRightEigenvector, Matrix.mulVec, dotProduct,
      Fin.sum_univ_two]; ring

end NumStability.Leveque02Tracer
