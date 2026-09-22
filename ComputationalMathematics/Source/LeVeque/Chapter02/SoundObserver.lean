/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Tactic.Ring
import ComputationalMathematics.Source.LeVeque.Chapter02.SoundObserverTarget

/-!
# Sound speeds relative to the fluid and to a fixed observer
-/

namespace NumStability.Leveque02Tracer

/-- The observer interpretation following equation (2.57): the common
background velocity cancels when fixed-observer wave velocities are measured
relative to the fluid. -/
theorem soundObserver : soundObserverTarget := by
  intro soundSpeed backgroundVelocity
  constructor <;> ring

end NumStability.Leveque02Tracer
