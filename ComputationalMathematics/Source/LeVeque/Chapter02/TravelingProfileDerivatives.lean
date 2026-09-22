/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TravelingProfileDerivativesTarget

/-!
# Derivatives of a vector travelling profile
-/

namespace NumStability.Leveque02Tracer

/-- The source's time and space derivative identities are the derivative
witnesses already supplied by the canonical travelling-wave theorem. -/
theorem travelingProfileDerivatives : travelingProfileDerivativesTarget := by
  intro m _ profile profileDerivative speed x t _ hprofile
  exact travelingWave_hasDerivAt_time_and_space speed x t hprofile

end NumStability.Leveque02Tracer
