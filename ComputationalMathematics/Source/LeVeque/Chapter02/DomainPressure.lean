/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.DomainPressureTarget

/-!
# LeVeque equation (2.36) on the model domains

The given pressure law determines pressure by composition with the density
field. Subtype membership supplies exactly the law's evaluation domain.
-/

namespace NumStability.Leveque02Tracer

/-- The model pressure equals its specified constitutive law at the density. -/
theorem domainPressure : domainPressureTarget := by
  intro densityDomain spaceTimeDomain pressureLaw density location
  rfl

end NumStability.Leveque02Tracer
