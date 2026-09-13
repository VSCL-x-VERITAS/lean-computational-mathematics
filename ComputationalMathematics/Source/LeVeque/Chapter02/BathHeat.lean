/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.BathHeatTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.ClassicalExternalHeat

/-!
# Heat exchange with a constant-temperature bath

The existing classical source-balance calculation applies to the explicit
bath-exchange profile. Its value depends on the rod temperature, preserving
the feedback term in the source equation of Section 2.5.1.
-/

namespace NumStability.Leveque02Tracer

/-- Specializing classical heat balance to bath exchange gives the displayed feedback equation. -/
theorem bathHeat : bathHeatTarget := by
  intro temperature gradient conductivity exchange bathTemperature qt qxx fluxDerivative x t
    spaceDomain hopen hx htime hspace hgradient hflux hbalance
  exact classicalExternalHeat temperature
    (fun ξ τ => exchange * (bathTemperature - temperature ξ τ))
    gradient conductivity qt qxx fluxDerivative x t spaceDomain
    hopen hx htime hspace hgradient hflux hbalance

end NumStability.Leveque02Tracer
