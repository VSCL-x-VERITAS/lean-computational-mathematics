/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# LeVeque Chapter 2: AcousticInverseNonzeroTarget

Target for the acoustic eigenvector-matrix inverse under nonzero impedance.
-/

namespace NumStability.Leveque02Tracer

/-- Acoustic eigenvector-matrix inverse under nonzero impedance. -/
def acousticInverseNonzeroTarget : Prop :=
  ∀ (density soundSpeed : ℝ),
    acousticImpedance density soundSpeed ≠ 0 →
      (linearAcousticsEigenvectorMatrix density soundSpeed)⁻¹ =
        linearAcousticsEigenvectorMatrixInverse density soundSpeed

end NumStability.Leveque02Tracer
