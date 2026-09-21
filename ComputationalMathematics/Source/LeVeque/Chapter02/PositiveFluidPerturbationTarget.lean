/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidPerturbationModel

/-!
# Positive-density fluid background decomposition

The exact decomposition precedes the later small-perturbation approximation.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.43) about a positive-density constant background state. -/
def positiveFluidPerturbationTarget : Prop :=
  ∀ (densityBackground velocityBackground : ℝ) (state : ℝ → ℝ → (Fin 2 → ℝ))
    (x t : ℝ), 0 < densityBackground →
    state x t = fluidConservedState densityBackground velocityBackground +
      fluidPerturbation (fluidConservedState densityBackground velocityBackground) (state x t) ∧
    fluidPerturbation (fluidConservedState densityBackground velocityBackground) (state x t) 0 =
      state x t 0 - densityBackground ∧
    fluidPerturbation (fluidConservedState densityBackground velocityBackground) (state x t) 1 =
      state x t 1 - densityBackground * velocityBackground

end NumStability.Leveque02Tracer
