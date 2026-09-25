/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PressureShearArrivalOrderTarget
import Mathlib.Algebra.Order.Field.Basic

/-!
# LeVeque Chapter 2: conditional P- and S-wave arrival order
-/

namespace NumStability.Leveque02Tracer

/-- Over the same positive distance, the assumed faster P-wave arrives first. -/
theorem pressureShearArrivalOrder : pressureShearArrivalOrderTarget := by
  intro compressionSpeed shearSpeed distance launchTime hdistance hshear hspeed
  have hreciprocal : 1 / compressionSpeed < 1 / shearSpeed :=
    one_div_lt_one_div_of_lt hshear hspeed
  have htravel : distance / compressionSpeed < distance / shearSpeed := by
    simpa [div_eq_mul_inv, mul_comm] using
      mul_lt_mul_of_pos_left hreciprocal hdistance
  exact add_lt_add_right htravel launchTime

end NumStability.Leveque02Tracer
