/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticInitialWaveStrengthsTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticEigenvectorMatrixNonsingular
import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticWaveStrengths

/-!
# Initial acoustic wave strengths
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.67): the amplitudes of the given initial two-wave
decomposition are the displayed pressure-velocity formulas. -/
theorem acousticInitialWaveStrengths : acousticInitialWaveStrengthsTarget := by
  intro density soundSpeed initialPressure initialVelocity
    leftProfile rightProfile hImpedance hmatrix x
  let R := linearAcousticsEigenvectorMatrix density soundSpeed
  have hfull := acousticEigenvectorMatrixNonsingular density soundSpeed hImpedance
  have hunit : IsUnit R.det := isUnit_iff_ne_zero.mpr hfull.1
  have hinverse : R⁻¹ =
      linearAcousticsEigenvectorMatrixInverse density soundSpeed := hfull.2
  have hstrengths :
      ![leftProfile x, rightProfile x] =
        acousticWaveStrengths density soundSpeed
          (initialPressure x) (initialVelocity x) := by
    calc
      ![leftProfile x, rightProfile x] =
          (R⁻¹).mulVec (R.mulVec ![leftProfile x, rightProfile x]) := by
            rw [Matrix.mulVec_mulVec, Matrix.nonsing_inv_mul R hunit,
              Matrix.one_mulVec]
      _ = (R⁻¹).mulVec ![initialPressure x, initialVelocity x] := by
            rw [hmatrix x]
      _ = acousticWaveStrengths density soundSpeed
            (initialPressure x) (initialVelocity x) := by
            rw [hinverse]
            rfl
  have hformula := acousticWaveStrengthsFormula density soundSpeed
    (initialPressure x) (initialVelocity x) hImpedance
  rw [hformula] at hstrengths
  constructor
  · exact congrFun hstrengths 0
  · exact congrFun hstrengths 1

end NumStability.Leveque02Tracer
