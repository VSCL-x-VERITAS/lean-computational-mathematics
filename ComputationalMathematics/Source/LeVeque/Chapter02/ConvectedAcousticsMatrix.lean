/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ConvectedAcousticsMatrixTarget

/-!
# Matrix form of convected linear acoustics
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.50): the pressure--velocity equations (2.48) are equivalent to
their displayed two-component constant-matrix system. -/
theorem convectedAcousticsMatrix : convectedAcousticsMatrixTarget := by
  intro pressureLaw pressure velocity pressureSlope densityBackground backgroundVelocity x t
    hdensity _
  exact convectedLinearAcoustics_matrixForm_iff pressure velocity
    (acousticBulkModulus pressureLaw densityBackground)
    densityBackground backgroundVelocity x t (ne_of_gt hdensity)

end NumStability.Leveque02Tracer
