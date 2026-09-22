/-
SPDX-License-Identifier: MIT
-/

import Mathlib.LinearAlgebra.Eigenspace.Matrix
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# Eigenvalues of the stationary acoustic matrix
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.54): the stationary acoustic matrix has the two wave speeds
`-c₀` and `+c₀`, with `c₀` defined by equation (2.55). -/
def stationaryAcousticsEigenvaluesTarget : Prop :=
  ∀ (bulkModulus density : ℝ), 0 < bulkModulus → 0 < density →
    let soundSpeed := Real.sqrt (bulkModulus / density)
    Module.End.HasEigenvalue
        (Matrix.toLin' (linearAcousticsMatrix bulkModulus density))
        (-soundSpeed) ∧
      Module.End.HasEigenvalue
        (Matrix.toLin' (linearAcousticsMatrix bulkModulus density))
        soundSpeed

end NumStability.Leveque02Tracer
