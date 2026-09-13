/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ConstantTracerFluxTarget

/-!
# Constant-velocity tracer flux

Equation (2.5) specializes the state flux to constant velocity. Substitution
in the existing product convention removes the position and time arguments.
-/

namespace NumStability.Leveque02Tracer

/-- The constant-velocity specialization of LeVeque's state flux in (2.5). -/
theorem constantTracerFluxDefinition : constantTracerFluxTarget := by
  intro velocity state x t
  rfl

end NumStability.Leveque02Tracer
