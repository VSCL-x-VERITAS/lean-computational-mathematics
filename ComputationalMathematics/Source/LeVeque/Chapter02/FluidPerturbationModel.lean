/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidStateFluxModel

/-!
# Conserved-state perturbation

The perturbation subtracts a constant density/momentum background.
-/

namespace NumStability.Leveque02Tracer

/-- The deviation of the conserved fluid state from its constant background. -/
noncomputable def fluidPerturbation (background state : Fin 2 → ℝ) : Fin 2 → ℝ :=
  state - background

end NumStability.Leveque02Tracer
