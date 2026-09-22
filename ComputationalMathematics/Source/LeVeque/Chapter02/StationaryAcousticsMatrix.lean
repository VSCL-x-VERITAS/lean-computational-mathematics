/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.StationaryAcousticsMatrixTarget

/-!
# Stationary-background acoustics matrix
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.51): setting the background velocity to zero in (2.50) gives
the standard stationary pressure--velocity acoustics matrix. -/
theorem stationaryAcousticsMatrix : stationaryAcousticsMatrixTarget := by
  intro pressureLaw densityBackground pressureSlope _ _ _
  rfl

end NumStability.Leveque02Tracer
