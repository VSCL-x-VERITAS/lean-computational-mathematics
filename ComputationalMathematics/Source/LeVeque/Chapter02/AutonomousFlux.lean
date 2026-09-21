/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AutonomousFluxTarget

/-!
# LeVeque Chapter 2: autonomous scalar fluxes
-/

namespace NumStability.Leveque02Tracer

/-- A scalar flux is autonomous on selected domains exactly when it has a
state-only representative there. -/
theorem autonomousFluxCharacterization : autonomousFluxTarget := by
  intro stateDomain spatialDomain temporalDomain spaceTimeFlux
  rfl

end NumStability.Leveque02Tracer
