/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.CompressionLimitTarget
import Mathlib.Tactic

/-!
# Complete one-dimensional compression and extensional strain
-/

namespace NumStability.Leveque02Tracer

/-- At a differentiability point, the kinematic strain reaches `-1` exactly
when the local stretch derivative vanishes. -/
theorem compressionLimit : compressionLimitTarget := by
  intro X x t _
  dsimp [longitudinalStrain]
  constructor <;> intro h <;> linarith

end NumStability.Leveque02Tracer
