/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ConstantSystemTarget

/-!
# LeVeque equation (2.42)

The existing constant-linear-flux theorem identifies the actual conservation
equation with the constant-coefficient system. This source wrapper adds no
matrix differentiation or conservation-law producer.
-/

namespace NumStability.Leveque02Tracer

/-- The given constant matrix defines the source linear conservation system. -/
theorem constantSystem : constantSystemTarget := by
  intro m q coefficient x t qx hqx
  exact conservationLaw_constantLinearFlux_iff q coefficient x t qx hqx

end NumStability.Leveque02Tracer
