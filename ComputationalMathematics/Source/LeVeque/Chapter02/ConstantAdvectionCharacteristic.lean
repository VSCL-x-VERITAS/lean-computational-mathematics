/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ConstantAdvectionCharacteristicTarget

/-!
# LeVeque Chapter 2: ConstantAdvectionCharacteristic

Characteristic propagation for a constant-velocity advection field.
-/

namespace NumStability.Leveque02Tracer

/-- Constancy of a classical advection field along every straight characteristic. -/
theorem constantAdvectionCharacteristic : constantAdvectionCharacteristicTarget := by
  intro q velocity hdiff hpde origin time
  rw [NumStability.linearAdvection_eq_travelingWave_of_differentiable hdiff hpde]
  simp [NumStability.travelingWave]

end NumStability.Leveque02Tracer
