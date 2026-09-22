/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.StationaryAcousticsEquationsTarget

/-!
# Stationary pressure--velocity acoustics equations
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.52): at zero background velocity the undivided component
equations are equivalent to the standard normalized linear-acoustics system. -/
theorem stationaryAcousticsEquations : stationaryAcousticsEquationsTarget := by
  intro pressureLaw pressure velocity densityBackground pressureSlope x t
    hdensity _ _
  rw [← convectedLinearAcoustics_matrixForm_iff pressure velocity
    (acousticBulkModulus pressureLaw densityBackground) densityBackground 0 x t
    (ne_of_gt hdensity)]
  change IsConstantCoefficientLinearSystemSolutionAt
      (linearAcousticsState pressure velocity)
      (linearAcousticsMatrix (acousticBulkModulus pressureLaw densityBackground)
        densityBackground) x t ↔ _
  exact linearAcoustics_matrixForm_iff pressure velocity
    (acousticBulkModulus pressureLaw densityBackground) densityBackground x t

end NumStability.Leveque02Tracer
