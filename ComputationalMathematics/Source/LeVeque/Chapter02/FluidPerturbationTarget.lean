/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidPerturbationModel

/-!
# Fluid state and background decomposition

The exact coordinate decomposition precedes any approximation or linearized
evolution equation. Its second component is momentum deviation.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.43) decomposes density and momentum about the given background. -/
def fluidPerturbationTarget : Prop :=
  ∀ (densityBackground velocityBackground : ℝ) (state : ℝ → ℝ → (Fin 2 → ℝ))
    (x t : ℝ),
    state x t = fluidConservedState densityBackground velocityBackground +
      fluidPerturbation (fluidConservedState densityBackground velocityBackground) (state x t) ∧
    fluidPerturbation (fluidConservedState densityBackground velocityBackground) (state x t) 0 =
      state x t 0 - densityBackground ∧
    fluidPerturbation (fluidConservedState densityBackground velocityBackground) (state x t) 1 =
      state x t 1 - densityBackground * velocityBackground

end NumStability.Leveque02Tracer
