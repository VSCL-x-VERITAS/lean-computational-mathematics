/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection

/-!
# Local translated-profile advection target

This proposed strengthening of the forward assertion in LeVeque (2.13)
requires only an actual derivative of the profile at the translated point.
It does not choose a global meaning for the source word "smooth". The
conclusion supplies both actual partial derivatives at the selected point.
Source applicability and genuine strengthening require independent audit;
this declaration is a proof-free target, not an accepted correspondence.
-/

namespace NumStability.Leveque02Tracer

/-- A local profile derivative suffices for the translated field's PDE at a point. -/
def advectionLocalProfileTarget : Prop :=
  ∀ (profile : ℝ → ℝ) (profileDerivative velocity x t : ℝ),
    HasDerivAt profile profileDerivative (x - velocity * t) →
      IsLinearAdvectionSolutionAt (travelingWave profile velocity) velocity x t

end NumStability.Leveque02Tracer
