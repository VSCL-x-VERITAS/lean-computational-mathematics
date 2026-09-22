/-
SPDX-License-Identifier: MIT
-/

import Mathlib.LinearAlgebra.Eigenspace.Matrix
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# Eigenvalues of the convected acoustic matrix
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.57): a constant background velocity shifts the two acoustic
eigenvalues by that velocity. -/
def convectedAcousticsEigenvaluesTarget : Prop :=
  ∀ (bulkModulus density backgroundVelocity : ℝ),
    0 < bulkModulus → 0 < density →
      let soundSpeed := Real.sqrt (bulkModulus / density)
      Module.End.HasEigenvalue
          (Matrix.toLin' (convectedLinearAcousticsMatrix
            bulkModulus density backgroundVelocity))
          (backgroundVelocity - soundSpeed) ∧
        Module.End.HasEigenvalue
          (Matrix.toLin' (convectedLinearAcousticsMatrix
            bulkModulus density backgroundVelocity))
          (backgroundVelocity + soundSpeed)

end NumStability.Leveque02Tracer
