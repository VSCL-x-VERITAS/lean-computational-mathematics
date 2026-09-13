/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidStateFluxModel

/-!
# Physical and conserved fluid coordinates

The positive mass coordinate makes the momentum-flux quotient meaningful.
This target records the state and flux definitions, without an evolution claim.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.40) agrees in physical and conserved coordinates at positive density. -/
def fluidStateFluxTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (density velocity : ℝ), 0 < density →
    fluidConservedState density velocity 0 = density ∧
    fluidConservedState density velocity 1 = density * velocity ∧
    fluidStateFlux pressureLaw (fluidConservedState density velocity) =
      ![density * velocity, density * velocity * velocity + pressureLaw density]

end NumStability.Leveque02Tracer
