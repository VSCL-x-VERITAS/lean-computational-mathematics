/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticInverseNonzeroTarget
import Mathlib.Tactic

/-!
# LeVeque Chapter 2: AcousticInverseNonzero

Proof of the acoustic eigenvector-matrix inverse under nonzero impedance.
-/

namespace NumStability.Leveque02Tracer

theorem acousticInverseNonzero : acousticInverseNonzeroTarget := by
  intro density soundSpeed hne
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
