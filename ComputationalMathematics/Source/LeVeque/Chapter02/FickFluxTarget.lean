/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FickFluxModel

/-!
# Fick flux definition correspondence

The state argument is q_x in the author's notation. No differentiability
hypothesis is needed to define this scalar constitutive function of that state.
-/

namespace NumStability.Leveque02Tracer

/-- The source's scalar Fick flux function has its displayed negative-gradient value. -/
def fickFluxTarget : Prop :=
  ∀ (coefficient gradient : ℝ), fickFlux coefficient gradient = -(coefficient * gradient)

end NumStability.Leveque02Tracer
