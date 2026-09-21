/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.BulkModulusTarget

/-!
# LeVeque equation (2.49)
-/

namespace NumStability.Leveque02Tracer

/-- The acoustic bulk-modulus identity from equation (2.49). -/
theorem bulkModulus : bulkModulusTarget := by
  intro pressureLaw densityBackground pressureSlope _hdensity hpressure
  simp [acousticBulkModulus, hpressure.deriv]

end NumStability.Leveque02Tracer
