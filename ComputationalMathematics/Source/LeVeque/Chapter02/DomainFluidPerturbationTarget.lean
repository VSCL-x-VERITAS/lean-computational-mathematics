/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidPerturbationModel

/-!
# Perturbation coordinates on physical domains

The background and field share a supplied admissible-state domain. The exact
decomposition is evaluated only on the supplied space-time domain.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.43) on the supplied physical-state and space-time domains. -/
def domainFluidPerturbationTarget : Prop :=
  ∀ (admissibleStates : Set (Fin 2 → ℝ)) (spaceTimeDomain : Set (ℝ × ℝ))
    (densityBackground velocityBackground : ℝ),
    fluidConservedState densityBackground velocityBackground ∈ admissibleStates →
    ∀ (state : spaceTimeDomain → admissibleStates) (location : spaceTimeDomain),
      (state location : Fin 2 → ℝ) = fluidConservedState densityBackground velocityBackground +
        fluidPerturbation (fluidConservedState densityBackground velocityBackground) (state location) ∧
      fluidPerturbation (fluidConservedState densityBackground velocityBackground) (state location) 0 =
        (state location : Fin 2 → ℝ) 0 - densityBackground ∧
      fluidPerturbation (fluidConservedState densityBackground velocityBackground) (state location) 1 =
        (state location : Fin 2 → ℝ) 1 - densityBackground * velocityBackground

end NumStability.Leveque02Tracer
