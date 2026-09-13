/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidStateFluxModel

/-!
# Conserved flux on a supplied density domain

Pressure is evaluated only where its law is defined. The existing conserved
state constructor is reused.
-/

namespace NumStability.Leveque02Tracer

/-- Conserved flux using a law only on its supplied density domain. -/
noncomputable def domainFluidStateFlux (densityDomain : Set ℝ)
    (pressureLaw : densityDomain → ℝ) (state : Fin 2 → ℝ)
    (inDomain : state 0 ∈ densityDomain) : Fin 2 → ℝ :=
  ![state 1, state 1 * state 1 / state 0 + pressureLaw ⟨state 0, inDomain⟩]

end NumStability.Leveque02Tracer
