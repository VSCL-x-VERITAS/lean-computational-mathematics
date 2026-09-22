/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TravelingProfileTarget

/-!
# Vector travelling-wave ansatz
-/

namespace NumStability.Leveque02Tracer

/-- The source's vector travelling-wave ansatz reuses the canonical translated
profile constructor. -/
theorem travelingProfile : travelingProfileTarget := by
  intro m _ profile speed x t _
  rfl

end NumStability.Leveque02Tracer
