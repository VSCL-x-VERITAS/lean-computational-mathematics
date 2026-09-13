/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.DomainPressureModel

/-!
# Density-only pressure on the model's domains

The defining equation of state is evaluated only where the supplied pressure
law and density field are defined. Their domains remain parameters because
equation (2.36) does not specify a universal vacuum or negative-density rule.
-/

namespace NumStability.Leveque02Tracer

/-- The pressure at each model point is its law at the actual density. -/
def domainPressureTarget : Prop :=
  ∀ (densityDomain : Set ℝ) (spaceTimeDomain : Set (ℝ × ℝ))
    (pressureLaw : densityDomain → ℝ) (density : spaceTimeDomain → densityDomain)
    (location : spaceTimeDomain),
    pressureOnDomains densityDomain spaceTimeDomain pressureLaw density location =
      pressureLaw (density location)

end NumStability.Leveque02Tracer
