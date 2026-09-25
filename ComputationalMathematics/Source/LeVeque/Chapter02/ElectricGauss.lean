/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ElectricGaussTarget

/-!
# LeVeque equation (2.111): electric Gauss constraint
-/

namespace NumStability.Leveque02Tracer

/-- The charge-free divergence constraint is its three diagonal Cartesian
spatial partials, each with an actual derivative witness. -/
theorem electricGauss : electricGaussTarget := by
  intro electricDisplacement position time
  rfl

end NumStability.Leveque02Tracer
