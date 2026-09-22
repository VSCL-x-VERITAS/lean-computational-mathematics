/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics
import ComputationalMathematics.Source.LeVeque.Chapter02.BulkModulusModel

/-!
# Stationary-background acoustics matrix
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.51) is the zero-background-velocity specialization of the
convected pressure--velocity matrix, with the bulk modulus from (2.49). -/
def stationaryAcousticsMatrixTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (densityBackground pressureSlope : ℝ),
    0 < densityBackground → 0 < pressureSlope →
      HasDerivAt pressureLaw pressureSlope densityBackground →
        convectedLinearAcousticsMatrix
            (acousticBulkModulus pressureLaw densityBackground) densityBackground 0 =
          linearAcousticsMatrix
            (acousticBulkModulus pressureLaw densityBackground) densityBackground

end NumStability.Leveque02Tracer
