/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Sound speeds relative to the fluid and to a fixed observer
-/

namespace NumStability.Leveque02Tracer

/-- The interpretation following equation (2.57): subtracting the constant
fluid velocity from the two fixed-observer wave velocities recovers the
left- and right-going sound speeds relative to the fluid. -/
def soundObserverTarget : Prop :=
  ∀ (soundSpeed backgroundVelocity : ℝ),
    (backgroundVelocity - soundSpeed) - backgroundVelocity = -soundSpeed ∧
      (backgroundVelocity + soundSpeed) - backgroundVelocity = soundSpeed

end NumStability.Leveque02Tracer
