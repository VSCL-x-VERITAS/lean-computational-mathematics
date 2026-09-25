/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveStressVelocitySystemTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveMotionSystem
import Mathlib.Tactic

/-!
# LeVeque equation (2.100): shear stress and velocity matrix system
-/

namespace NumStability.Leveque02Tracer

/-- Eliminating shear strain gives the printed stress-velocity system. -/
theorem shearWaveStressVelocitySystem : shearWaveStressVelocitySystemTarget := by
  intro W shearModulus density x t Wxt Wtx velocityTime stressSpace
    hdensity _ hspatial htemporal hvelocityNeighborhood _
    hspaceTime htimeSpace hcomm hvelocityTime hstressSpace hNewton
  have hvelocitySpace : HasDerivAt
      (fun ξ => shearWaveVelocity W ξ t) Wtx x := by
    simpa [shearWaveVelocity] using htimeSpace
  have hstressTime : HasDerivAt
      (fun τ => planeShearStress shearModulus (shearWaveStrain W) x τ)
      (shearModulus * Wxt) t := by
    convert hspaceTime.const_mul shearModulus using 1
    funext τ
    dsimp [planeShearStress, shearWaveStrain]
    ring
  have hmotion := shearWaveMotionSystem W
    (planeShearStress shearModulus (shearWaveStrain W))
    density x t Wxt Wtx velocityTime stressSpace hdensity
    hspatial htemporal hvelocityNeighborhood hspaceTime htimeSpace hcomm
    hvelocityTime hstressSpace hNewton
  rcases hmotion with ⟨_, hsecond⟩
  have hsecond' : density * velocityTime - stressSpace = 0 := by
    simpa only [hvelocityTime.deriv, hstressSpace.deriv] using hsecond
  change ∃ qt qx : Fin 2 → ℝ,
    HasDerivAt (fun τ => shearWaveStressVelocityState W shearModulus x τ) qt t ∧
      HasDerivAt (fun ξ => shearWaveStressVelocityState W shearModulus ξ t) qx x ∧
        qt + (shearWaveStressVelocityMatrix shearModulus density).mulVec qx = 0
  refine ⟨![shearModulus * Wxt, velocityTime], ![stressSpace, Wtx], ?_, ?_, ?_⟩
  · apply hasDerivAt_pi.mpr
    simpa [shearWaveStressVelocityState, Fin.forall_fin_two] using
      And.intro hstressTime hvelocityTime
  · apply hasDerivAt_pi.mpr
    simpa [shearWaveStressVelocityState, Fin.forall_fin_two] using
      And.intro hstressSpace hvelocitySpace
  · ext i
    fin_cases i
    · simp [shearWaveStressVelocityMatrix]
      rw [hcomm]
      ring
    · have hd : density ≠ 0 := ne_of_gt hdensity
      simp [shearWaveStressVelocityMatrix]
      field_simp [hd]
      linarith [hsecond']

end NumStability.Leveque02Tracer
