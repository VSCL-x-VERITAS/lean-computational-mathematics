/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.HeatCapacityTarget

/-!
# Heat capacity and the time derivative

Time-independent capacity scales the actual temperature time derivative.
Uniqueness identifies that rate with the conductivity-gradient derivative.
-/

namespace NumStability.Leveque02Tracer

/-- A time-independent capacity gives the differential heat equation (2.26). -/
theorem heatCapacity : heatCapacityTarget := by
  intro E _ _ q gradient qt productDerivative capacity conductivity x t S T
    _hx _ht _hspace htime hqt _hgradient _hproduct
  have henergy := hqt.const_smul (capacity x)
  constructor
  · intro hrate
    exact htime.eq_deriv _ henergy hrate
  · intro hvalue
    exact henergy.congr_deriv hvalue

end NumStability.Leveque02Tracer
