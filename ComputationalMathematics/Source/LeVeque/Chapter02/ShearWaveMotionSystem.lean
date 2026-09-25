/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveMotionSystemTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.LongitudinalMixedPartials
import Mathlib.Tactic

/-!
# LeVeque equation (2.98): transverse shear-wave equations of motion
-/

namespace NumStability.Leveque02Tracer

/-- Mixed-partial commutation supplies the shear kinematic equation;
transverse Newton balance supplies the independent momentum equation. -/
theorem shearWaveMotionSystem : shearWaveMotionSystemTarget := by
  intro W shearStress density x t Wxt Wtx velocityTime stressSpace
    hdensity hspatial htemporal _ hspaceTime htimeSpace hcomm
    hvelocityTime hstressSpace hNewton
  have hkinematic := longitudinalMixedPartials W x t Wxt Wtx
    hspatial htemporal hspaceTime htimeSpace hcomm
  rcases hkinematic with ⟨_, hvelocitySpaceLong, _, _, _⟩
  have hvelocitySpace : HasDerivAt
      (fun ξ => shearWaveVelocity W ξ t) Wtx x := by
    simpa [shearWaveVelocity, longitudinalMaterialVelocity] using
      hvelocitySpaceLong
  have hstrainTime : HasDerivAt
      (fun τ => shearWaveStrain W x τ) ((1 / 2 : ℝ) * Wxt) t := by
    simpa [shearWaveStrain] using hspaceTime.const_mul (1 / 2 : ℝ)
  constructor
  · rw [hstrainTime.deriv, hvelocitySpace.deriv, hcomm]
    ring
  · rw [hvelocityTime.deriv, hstressSpace.deriv]
    linarith

end NumStability.Leveque02Tracer
