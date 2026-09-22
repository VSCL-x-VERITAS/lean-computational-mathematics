/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticEigenvectorMatrixInverseTarget

/-!
# Inverse of the acoustic eigenvector matrix
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.66): the inverse of the acoustic eigenvector matrix. -/
theorem acousticEigenvectorMatrixInverse : acousticEigenvectorMatrixInverseTarget := by
  intro density soundSpeed hImpedance
  have hne : acousticImpedance density soundSpeed ≠ 0 := ne_of_gt hImpedance
  have hproduct : density * soundSpeed ≠ 0 := by
    simpa [acousticImpedance] using hne
  have hdensity : density ≠ 0 := (mul_ne_zero_iff.mp hproduct).1
  have hsoundSpeed : soundSpeed ≠ 0 := (mul_ne_zero_iff.mp hproduct).2
  apply Matrix.inv_eq_left_inv
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [linearAcousticsEigenvectorMatrixInverse,
      linearAcousticsEigenvectorMatrix, acousticImpedance,
      Matrix.mul_apply, Fin.sum_univ_two] <;>
    field_simp <;> ring

end NumStability.Leveque02Tracer
