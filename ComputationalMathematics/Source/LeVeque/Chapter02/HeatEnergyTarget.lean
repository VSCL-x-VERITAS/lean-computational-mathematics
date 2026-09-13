/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.HeatEnergyModel

/-!
# Internal energy density formula

Proof-free correspondence for the temperature-to-energy definition in
Section2.3, preserving the spatial dependence of heat capacity.
-/

namespace NumStability.Leveque02Tracer

/-- The internal energy density is heat capacity times temperature. -/
def thermalEnergyTarget : Prop :=
  ∀ (capacity : ℝ → ℝ) (temperature : ℝ → ℝ → ℝ) (x t : ℝ),
    thermalEnergyDensity capacity temperature x t = capacity x * temperature x t

end NumStability.Leveque02Tracer
