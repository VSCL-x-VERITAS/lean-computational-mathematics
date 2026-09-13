/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.CapacityBalanceTarget

/-!
# Capacity-weighted conservation

Time-independent capacity scales the actual state time derivative. Uniqueness
identifies that derivative with the conserved-state rate, and substitution in
the given balance yields the capacity equation (2.27).
-/

namespace NumStability.Leveque02Tracer

/-- Conservation of the capacity-weighted state gives the displayed capacity law. -/
theorem capacityBalance : capacityBalanceTarget := by
  intro E _ _ q capacity flux qt conservedRate fluxDerivative x t S T
    _hx _ht _hspace htime hqt hconserved _hflux hbalance
  have hvalue : capacity x • qt = conservedRate :=
    htime.eq_deriv _ (hqt.const_smul (capacity x)) hconserved
  rw [hvalue]
  exact hbalance

end NumStability.Leveque02Tracer
