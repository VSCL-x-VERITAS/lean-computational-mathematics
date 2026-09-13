/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Fin.VecNotation
import Mathlib.Data.Real.Basic

/-!
# Conserved coordinates for the density-only gas model

The state stores mass and momentum densities. The flux quotient is used only
on positive-density states by the source-facing target.
-/

namespace NumStability.Leveque02Tracer

/-- The two conserved densities in the density-only gas model. -/
noncomputable def fluidConservedState (density velocity : ℝ) : Fin 2 → ℝ :=
  ![density, density * velocity]

/-- Mass and momentum flux as a function of the two conserved densities. -/
noncomputable def fluidStateFlux (pressureLaw : ℝ → ℝ) (state : Fin 2 → ℝ) : Fin 2 → ℝ :=
  ![state 1, state 1 * state 1 / state 0 + pressureLaw (state 0)]

end NumStability.Leveque02Tracer
