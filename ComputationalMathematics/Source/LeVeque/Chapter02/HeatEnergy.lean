/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.HeatEnergyTarget

/-!
# Temperature-to-energy formula

The source constitutive definition identifies internal energy density with
spatial heat capacity times the temperature field.
-/

namespace NumStability.Leveque02Tracer

/-- Internal energy density has the displayed constitutive value in Section2.3. -/
theorem thermalEnergy : thermalEnergyTarget := by
  intro capacity temperature x t
  rfl

end NumStability.Leveque02Tracer
