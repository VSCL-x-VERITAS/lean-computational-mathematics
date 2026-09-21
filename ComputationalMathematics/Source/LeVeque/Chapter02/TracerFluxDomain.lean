/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TracerFluxDomainTarget

/-!
# LeVeque Chapter 2, equation (2.3): domain-aware tracer flux
-/

namespace NumStability.Leveque02Tracer

/-- At every admitted position and time, the signed tracer-mass flux is the
prescribed signed velocity times the nonnegative linear tracer density. -/
theorem domainAwareFluxProduct : domainAwareFluxProductTarget := by
  intro spatialDomain temporalDomain velocity density x t hx ht hdensity
  rfl

end NumStability.Leveque02Tracer
