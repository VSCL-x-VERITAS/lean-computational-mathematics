/-
SPDX-License-Identifier: MIT
-/

import Mathlib.LinearAlgebra.Eigenspace.Matrix
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# Eigenvectors of the convected acoustic matrix
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.58): the displayed pressure--velocity vectors remain
eigenvectors when a constant background velocity shifts their eigenvalues. -/
def convectedAcousticsEigenvectorsTarget : Prop :=
  ∀ (bulkModulus density backgroundVelocity : ℝ),
    0 < bulkModulus → 0 < density →
      let soundSpeed := Real.sqrt (bulkModulus / density)
      Module.End.HasEigenvector
          (Matrix.toLin' (convectedLinearAcousticsMatrix
            bulkModulus density backgroundVelocity))
          (backgroundVelocity - soundSpeed)
          (linearAcousticsLeftEigenvector density soundSpeed) ∧
        Module.End.HasEigenvector
          (Matrix.toLin' (convectedLinearAcousticsMatrix
            bulkModulus density backgroundVelocity))
          (backgroundVelocity + soundSpeed)
          (linearAcousticsRightEigenvector density soundSpeed)

end NumStability.Leveque02Tracer
