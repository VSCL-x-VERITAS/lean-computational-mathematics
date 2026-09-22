/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PressureSoundSpeedTarget

/-!
# Sound speed from the pressure-law derivative
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.56), reusing the audited bulk-modulus producer for (2.49). -/
theorem pressureSoundSpeed : pressureSoundSpeedTarget := by
  intro pressureLaw densityBackground pressureSlope soundSpeed
    hdensity _ hpressure hsoundSpeed
  rw [bulkModulus pressureLaw densityBackground pressureSlope hdensity hpressure] at hsoundSpeed
  convert hsoundSpeed using 1
  field_simp [ne_of_gt hdensity]

end NumStability.Leveque02Tracer
