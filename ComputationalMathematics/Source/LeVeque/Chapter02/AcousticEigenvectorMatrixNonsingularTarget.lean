/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticEigenvectorMatrixInverseTarget

/-!
# Nonsingular acoustic eigenvector matrix and its inverse
-/

namespace NumStability.Leveque02Tracer

/-- The full claim surrounding equation (2.66): positive impedance makes the
acoustic eigenvector matrix nonsingular, with the displayed inverse. -/
def acousticEigenvectorMatrixNonsingularTarget : Prop :=
  ∀ (density soundSpeed : ℝ),
    0 < acousticImpedance density soundSpeed →
      (linearAcousticsEigenvectorMatrix density soundSpeed).det ≠ 0 ∧
        (linearAcousticsEigenvectorMatrix density soundSpeed)⁻¹ =
          linearAcousticsEigenvectorMatrixInverse density soundSpeed

end NumStability.Leveque02Tracer
