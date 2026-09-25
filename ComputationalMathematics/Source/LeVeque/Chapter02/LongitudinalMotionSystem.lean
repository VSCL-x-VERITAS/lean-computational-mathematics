/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LongitudinalMotionSystemTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.LongitudinalMixedPartials

/-!
# LeVeque equation (2.91): longitudinal motion equations

Kinematic compatibility follows from the previously proved mixed-partial
identity. The momentum equation is Newton's law for the supplied normal stress.
-/

namespace NumStability.Leveque02Tracer

/-- P-wave strain and velocity satisfy the two displayed motion equations
when mixed partials commute and Newton's force balance holds. -/
theorem longitudinalMotionSystem : longitudinalMotionSystemTarget := by
  intro X stress density x t Xxt Xtx velocityTime stressSpace _
    hspatial htemporal _ hspaceTime htimeSpace hcomm
    hvelocityTime hstressSpace hNewton
  have hkinematic := longitudinalMixedPartials X x t Xxt Xtx
    hspatial htemporal hspaceTime htimeSpace hcomm
  rcases hkinematic with ⟨_, _, _, _, hcompat⟩
  constructor
  · exact sub_eq_zero.mpr hcompat
  · rw [hvelocityTime.deriv, hstressSpace.deriv]
    exact sub_eq_zero.mpr hNewton

end NumStability.Leveque02Tracer
