/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.IsentropicPressureTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.DomainPressure

/-!
# LeVeque equation (2.35)

The special isentropic pressure model evaluates its supplied real-power law
at the positive local density. This is a constitutive identity; slope
positivity and the constant-entropy model are separate source claims.
-/

namespace NumStability.Leveque02Tracer

/-- The isentropic equation of state is `p = κ̂ * ρ ^ γ` on positive density. -/
theorem isentropicPressure : isentropicPressureTarget := by
  intro coefficient exponent spaceTimeDomain density location
  simpa only [isentropicPressureLaw] using
    (domainPressure (Set.Ioi 0) spaceTimeDomain
      (isentropicPressureLaw coefficient exponent) density location)

end NumStability.Leveque02Tracer
