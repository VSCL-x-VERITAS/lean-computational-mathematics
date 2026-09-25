/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveMatrixSystemTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveMotionSystem
import Mathlib.Tactic

/-!
# LeVeque equation (2.99): shear strain and velocity matrix system
-/

namespace NumStability.Leveque02Tracer

/-- Substituting the constant shear-stress law into the S-wave motion
equations gives the displayed two-by-two first-order system. -/
theorem shearWaveMatrixSystem : shearWaveMatrixSystemTarget := by
  intro W shearModulus density x t Wxt Wtx strainSpace velocityTime stressSpace
    hdensity _ hspatial htemporal hvelocityNeighborhood _ hspaceTime htimeSpace
    hcomm hstrainSpace hvelocityTime hstressSpace hNewton
  let M : ℝ := 2 * shearModulus
  have hstrainTime : HasDerivAt
      (fun τ => shearWaveStrain W x τ) ((1 / 2 : ℝ) * Wxt) t := by
    simpa [shearWaveStrain] using hspaceTime.const_mul (1 / 2 : ℝ)
  have hvelocitySpace : HasDerivAt
      (fun ξ => shearWaveVelocity W ξ t) Wtx x := by
    simpa [shearWaveVelocity] using htimeSpace
  have hmotion := shearWaveMotionSystem W
    (planeShearStress shearModulus (shearWaveStrain W))
    density x t Wxt Wtx velocityTime stressSpace hdensity
    hspatial htemporal hvelocityNeighborhood hspaceTime htimeSpace hcomm
    hvelocityTime hstressSpace hNewton
  rcases hmotion with ⟨hfirst, hsecond⟩
  have hstressConstitutive : HasDerivAt
      (fun ξ => planeShearStress shearModulus (shearWaveStrain W) ξ t)
      (M * strainSpace) x := by
    simpa [planeShearStress, M] using hstrainSpace.const_mul M
  have hstressValue : stressSpace = M * strainSpace := by
    exact hstressSpace.deriv.symm.trans hstressConstitutive.deriv
  have hfirst' : (1 / 2 : ℝ) * Wxt - (1 / 2 : ℝ) * Wtx = 0 := by
    simpa only [hstrainTime.deriv, hvelocitySpace.deriv] using hfirst
  have hsecond' : density * velocityTime - M * strainSpace = 0 := by
    simpa only [hvelocityTime.deriv, hstressSpace.deriv, hstressValue] using hsecond
  change ∃ qt qx : Fin 2 → ℝ,
    HasDerivAt (fun τ => shearWaveStrainVelocityState W x τ) qt t ∧
      HasDerivAt (fun ξ => shearWaveStrainVelocityState W ξ t) qx x ∧
        qt + (shearWaveCoefficientMatrix shearModulus density).mulVec qx = 0
  refine ⟨![(1 / 2 : ℝ) * Wxt, velocityTime], ![strainSpace, Wtx], ?_, ?_, ?_⟩
  · apply hasDerivAt_pi.mpr
    simpa [shearWaveStrainVelocityState, Fin.forall_fin_two] using
      And.intro hstrainTime hvelocityTime
  · apply hasDerivAt_pi.mpr
    simpa [shearWaveStrainVelocityState, Fin.forall_fin_two] using
      And.intro hstrainSpace hvelocitySpace
  · ext i
    fin_cases i
    · simp [shearWaveCoefficientMatrix]
      nlinarith [hfirst']
    · have hd : density ≠ 0 := ne_of_gt hdensity
      simp [shearWaveCoefficientMatrix]
      field_simp [hd]
      linarith [hsecond']

end NumStability.Leveque02Tracer
