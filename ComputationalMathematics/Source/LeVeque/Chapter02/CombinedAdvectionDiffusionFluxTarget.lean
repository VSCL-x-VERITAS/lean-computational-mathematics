/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.CombinedAdvectionDiffusionFluxModel

/-!
# Combined advection-diffusion flux target

Proof-free target for the combined-flux definition preceding equation (2.23).
-/

namespace NumStability.Leveque02Tracer

/-- Simultaneous constant advection and Fick diffusion have flux
`velocity * state - coefficient * gradient`. -/
def combinedAdvectionDiffusionFluxTarget : Prop :=
  ∀ velocity coefficient state gradient : ℝ,
    combinedAdvectionDiffusionFlux velocity coefficient state gradient =
      velocity * state - coefficient * gradient

end NumStability.Leveque02Tracer
