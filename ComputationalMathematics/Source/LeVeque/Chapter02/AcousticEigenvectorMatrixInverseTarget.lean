/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# Inverse of the acoustic eigenvector matrix
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.66): for positive acoustic impedance, the displayed matrix is
the inverse of the acoustic eigenvector matrix. -/
def acousticEigenvectorMatrixInverseTarget : Prop :=
  ∀ (density soundSpeed : ℝ),
    0 < acousticImpedance density soundSpeed →
      (linearAcousticsEigenvectorMatrix density soundSpeed)⁻¹ =
        linearAcousticsEigenvectorMatrixInverse density soundSpeed

end NumStability.Leveque02Tracer
