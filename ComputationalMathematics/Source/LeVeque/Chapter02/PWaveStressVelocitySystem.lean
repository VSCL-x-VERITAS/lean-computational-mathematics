/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveStressVelocitySystemTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.LongitudinalMotionSystem
import Mathlib.Tactic

/-!
# LeVeque equation (2.95): normal-stress and velocity matrix system
-/

namespace NumStability.Leveque02Tracer

/-- Eliminating longitudinal strain gives the displayed stress-velocity
first-order system for a homogeneous elastic material. -/
theorem pWaveStressVelocitySystem : pWaveStressVelocitySystemTarget := by
  intro X lameLambda shearModulus density x t Xxt Xtx velocityTime stressSpace
    hdensity _ hspatial htemporal hvelocityNeighborhood _
    hspaceTime htimeSpace hcomm hvelocityTime hstressSpace hNewton
  let K : ℝ := lameLambda + 2 * shearModulus
  have hkinematic := longitudinalMixedPartials X x t Xxt Xtx
    hspatial htemporal hspaceTime htimeSpace hcomm
  rcases hkinematic with ⟨hstrainTime, hvelocitySpace, _, _, _⟩
  have hmotion := longitudinalMotionSystem X
    (planeNormalStress lameLambda shearModulus (longitudinalStrain X))
    density x t Xxt Xtx velocityTime stressSpace hdensity
    hspatial htemporal hvelocityNeighborhood hspaceTime htimeSpace hcomm
    hvelocityTime hstressSpace hNewton
  rcases hmotion with ⟨hfirst, hsecond⟩
  have hfirst' : Xxt - Xtx = 0 := by
    simpa only [hstrainTime.deriv, hvelocitySpace.deriv] using hfirst
  have hsecond' : density * velocityTime - stressSpace = 0 := by
    simpa only [hvelocityTime.deriv, hstressSpace.deriv] using hsecond
  have hstressTime : HasDerivAt
      (fun τ => planeNormalStress lameLambda shearModulus
        (longitudinalStrain X) x τ) (K * Xxt) t := by
    simpa [planeNormalStress, K] using hstrainTime.const_mul K
  change ∃ qt qx : Fin 2 → ℝ,
    HasDerivAt (fun τ => pWaveStressVelocityState X lameLambda shearModulus x τ) qt t ∧
      HasDerivAt (fun ξ => pWaveStressVelocityState X lameLambda shearModulus ξ t) qx x ∧
        qt + (pWaveStressVelocityMatrix lameLambda shearModulus density).mulVec qx = 0
  refine ⟨![K * Xxt, velocityTime], ![stressSpace, Xtx], ?_, ?_, ?_⟩
  · apply hasDerivAt_pi.mpr
    simpa [pWaveStressVelocityState, Fin.forall_fin_two] using
      And.intro hstressTime hvelocityTime
  · apply hasDerivAt_pi.mpr
    simpa [pWaveStressVelocityState, Fin.forall_fin_two] using
      And.intro hstressSpace hvelocitySpace
  · ext i
    fin_cases i
    · simp [pWaveStressVelocityMatrix, K]
      nlinarith [hfirst']
    · have hd : density ≠ 0 := ne_of_gt hdensity
      simp [pWaveStressVelocityMatrix]
      field_simp [hd]
      linarith [hsecond']

end NumStability.Leveque02Tracer
