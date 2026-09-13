/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.DomainStateFluxModel

/-!
# Domain-explicit physical and conserved fluid coordinates

The quotient is evaluated at nonzero density in the supplied pressure-law
domain. No total extension of the constitutive law is required.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.40) holds throughout the defined, nonzero density domain. -/
def domainStateFluxTarget : Prop :=
  ∀ (densityDomain : Set ℝ) (pressureLaw : densityDomain → ℝ)
    (density : densityDomain) (velocity : ℝ), (density : ℝ) ≠ 0 →
    fluidConservedState density velocity 0 = (density : ℝ) ∧
    fluidConservedState density velocity 1 = (density : ℝ) * velocity ∧
    domainFluidStateFlux densityDomain pressureLaw (fluidConservedState density velocity)
      density.property =
      ![(density : ℝ) * velocity,
        (density : ℝ) * velocity * velocity + pressureLaw density]

end NumStability.Leveque02Tracer
