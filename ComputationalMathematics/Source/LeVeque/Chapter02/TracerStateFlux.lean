/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TracerStateFluxTarget

/-!
# LeVeque (2.4): the flux function of state, position, and time

The state is linear tracer density. The known velocity field multiplies that
state to give signed rightward mass flux in the one-dimensional tracer model.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.4), with a density-state argument separate from position and time. -/
theorem stateFluxDefinition : stateFluxTarget := by
  intro velocity state x t hstate
  rfl

end NumStability.Leveque02Tracer
