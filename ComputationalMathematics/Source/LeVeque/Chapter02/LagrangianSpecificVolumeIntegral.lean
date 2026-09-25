/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianSpecificVolumeIntegralTarget

/-!
# LeVeque equation (2.103): specific-volume interval integral
-/

namespace NumStability.Leveque02Tracer

/-- Under the actual mass-coordinate Jacobian `X_ξ=V`, the integral of
specific volume is the physical separation of the endpoint particles. -/
theorem lagrangianSpecificVolumeIntegral : lagrangianSpecificVolumeIntegralTarget := by
  intro initialDensity referenceLocation particlePosition eulerianDensity
    leftLabel rightLabel time _ _ _ _ _ hcoordinate hintegrable
  exact intervalIntegral.integral_eq_sub_of_hasDerivAt hcoordinate hintegrable

end NumStability.Leveque02Tracer
