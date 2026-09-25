/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.NonlinearPWaveSystemTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.LongitudinalMotionSystem

/-!
# LeVeque equation (2.97): nonlinear P-wave equations of motion
-/

namespace NumStability.Leveque02Tracer

/-- The longitudinal motion equations remain valid when normal stress is an
arbitrary constitutive function of the extensional strain. -/
theorem nonlinearPWaveSystem : nonlinearPWaveSystemTarget := by
  intro X stressLaw density x t Xxt Xtx velocityTime stressSpace
    hdensity hspatial htemporal hvelocityNeighborhood _
    hspaceTime htimeSpace hcomm hvelocityTime hstressSpace hNewton
  exact longitudinalMotionSystem X (nonlinearPWaveStress stressLaw X)
    density x t Xxt Xtx velocityTime stressSpace hdensity
    hspatial htemporal hvelocityNeighborhood hspaceTime htimeSpace hcomm
    hvelocityTime hstressSpace hNewton

end NumStability.Leveque02Tracer
