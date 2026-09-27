/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticEigenvectorMatrixNonsingular
import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticWaveStrengths

/-!
# Acoustic wave decomposition in LeVeque Chapter 3

Equation (3.10), printed page 49/raw PDF page 71. The acoustic strengths and
inverse eigenvector matrix are reused from Chapter 2.
-/

namespace NumStability

/-- The pressure-velocity state is the sum of its left- and right-going
acoustic waves, with strengths given by the established inverse matrix. -/
theorem leveque03_acousticWaveDecomposition
    (density soundSpeed pressure velocity : ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed) :
    ![pressure, velocity] =
      (acousticWaveStrengths density soundSpeed pressure velocity 0) •
          linearAcousticsLeftEigenvector density soundSpeed +
        (acousticWaveStrengths density soundSpeed pressure velocity 1) •
          linearAcousticsRightEigenvector density soundSpeed := by
  let R := linearAcousticsEigenvectorMatrix density soundSpeed
  let w := acousticWaveStrengths density soundSpeed pressure velocity
  have hfull := Leveque02Tracer.acousticEigenvectorMatrixNonsingular
    density soundSpeed hZ
  have hunit : IsUnit R.det := isUnit_iff_ne_zero.mpr hfull.1
  have hrec : R.mulVec w = ![pressure, velocity] := by
    change R.mulVec
      ((linearAcousticsEigenvectorMatrixInverse density soundSpeed).mulVec
        ![pressure, velocity]) = _
    rw [← hfull.2, Matrix.mulVec_mulVec, Matrix.mul_nonsing_inv R hunit,
      Matrix.one_mulVec]
  have hsum (v : Fin 2 → ℝ) : R.mulVec v =
      v 0 • linearAcousticsLeftEigenvector density soundSpeed +
        v 1 • linearAcousticsRightEigenvector density soundSpeed := by
    funext j
    fin_cases j
    · simp [R, linearAcousticsEigenvectorMatrix,
        linearAcousticsLeftEigenvector, linearAcousticsRightEigenvector,
        Matrix.mulVec, dotProduct, Fin.sum_univ_two]
      ring
    · simp [R, linearAcousticsEigenvectorMatrix,
        linearAcousticsLeftEigenvector, linearAcousticsRightEigenvector,
        Matrix.mulVec, dotProduct, Fin.sum_univ_two]
  calc
    ![pressure, velocity] = R.mulVec w := hrec.symm
    _ = w 0 • linearAcousticsLeftEigenvector density soundSpeed +
          w 1 • linearAcousticsRightEigenvector density soundSpeed := hsum w

end NumStability
