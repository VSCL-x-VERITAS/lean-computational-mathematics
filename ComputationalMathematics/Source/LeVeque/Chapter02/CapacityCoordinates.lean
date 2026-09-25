/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.CapacityCoordinatesTarget

/-!
# LeVeque Chapter 2: CapacityCoordinates

Coordinate identities for a tracer balance with spatial capacity.
-/

namespace NumStability.Leveque02Tracer

theorem capacityModel : capacityModelTarget := by
  intro capacity state flux
  constructor <;> rfl

#print axioms capacityModel

end NumStability.Leveque02Tracer
