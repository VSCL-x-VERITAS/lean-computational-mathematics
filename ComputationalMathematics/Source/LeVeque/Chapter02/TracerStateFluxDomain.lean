/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TracerStateFluxDomainTarget

/-!
# LeVeque Chapter 2, equation (2.4): domain-aware tracer state flux
-/

namespace NumStability.Leveque02Tracer

/-- At every admitted position and time, the prescribed-velocity flux function
maps a physical local density state to signed velocity times that state. -/
theorem domainAwareStateFluxProduct : domainAwareStateFluxProductTarget := by
  intro spatialDomain temporalDomain velocity state x t hx ht hstate
  rfl

end NumStability.Leveque02Tracer
