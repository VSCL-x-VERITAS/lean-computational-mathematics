/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.CapacityBalanceTarget

/-!
# Capacity-weighted conservation

Time-independent capacity scales the actual state time derivative. Derivative
uniqueness identifies that rate with the conserved-state rate, so the inherited
conservation balance is equivalent to the displayed equation (2.27).
-/

namespace NumStability.Leveque02Tracer

/-- Conservation of the capacity-weighted state gives the displayed capacity law. -/
theorem capacityBalance : capacityBalanceTarget := by
  intro q capacity flux qt conservedRate fluxDerivative x t hqt hconserved _hflux
  have hscaled : HasDerivAt (fun τ => capacity x * q x τ) (capacity x * qt) t :=
    hqt.const_mul (capacity x)
  have hvalue : capacity x * qt = conservedRate := hscaled.unique hconserved
  rw [hvalue]

end NumStability.Leveque02Tracer
