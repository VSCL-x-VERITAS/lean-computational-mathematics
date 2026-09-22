/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticStateTarget

/-!
# Pressure--velocity acoustic state notation
-/

namespace NumStability.Leveque02Tracer

/-- The source's acoustic state notation reuses the canonical pressure--velocity
state in the stated component order. -/
theorem acousticState : acousticStateTarget := by
  intro pressure velocity x t
  rfl

end NumStability.Leveque02Tracer
