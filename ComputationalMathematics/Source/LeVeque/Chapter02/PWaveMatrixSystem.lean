/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveMatrixSystemTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.LongitudinalMotionSystem
import Mathlib.Tactic

/-!
# LeVeque equation (2.93): strain-velocity matrix system
-/

namespace NumStability.Leveque02Tracer

/-- Substituting the constant-modulus stress law into the P-wave motion
equations gives the displayed two-by-two first-order system. -/
theorem pWaveMatrixSystem : pWaveMatrixSystemTarget := by
  intro X lameLambda shearModulus density x t Xxt Xtx strainSpace
    velocityTime stressSpace hdensity _ hspatial htemporal hvelocityNeighborhood
    _ hspaceTime htimeSpace hcomm hstrainSpace hvelocityTime hstressSpace hNewton
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
  have hstressConstitutive : HasDerivAt
      (fun ξ => planeNormalStress lameLambda shearModulus
        (longitudinalStrain X) ξ t) (K * strainSpace) x := by
    simpa [planeNormalStress, K] using hstrainSpace.const_mul K
  have hstressValue : stressSpace = K * strainSpace := by
    exact hstressSpace.deriv.symm.trans hstressConstitutive.deriv
  have hfirst' : Xxt - Xtx = 0 := by
    simpa only [hstrainTime.deriv, hvelocitySpace.deriv] using hfirst
  have hsecond' : density * velocityTime - K * strainSpace = 0 := by
    simpa only [hvelocityTime.deriv, hstressSpace.deriv, hstressValue] using hsecond
  change ∃ qt qx : Fin 2 → ℝ,
    HasDerivAt (fun τ => pWaveStrainVelocityState X x τ) qt t ∧
      HasDerivAt (fun ξ => pWaveStrainVelocityState X ξ t) qx x ∧
        qt + (pWaveCoefficientMatrix lameLambda shearModulus density).mulVec qx = 0
  refine ⟨![Xxt, velocityTime], ![strainSpace, Xtx], ?_, ?_, ?_⟩
  · apply hasDerivAt_pi.mpr
    simpa [pWaveStrainVelocityState, Fin.forall_fin_two] using
      And.intro hstrainTime hvelocityTime
  · apply hasDerivAt_pi.mpr
    simpa [pWaveStrainVelocityState, Fin.forall_fin_two] using
      And.intro hstrainSpace hvelocitySpace
  · ext i
    fin_cases i
    · simpa [pWaveCoefficientMatrix, Matrix.mulVec, dotProduct,
        Fin.sum_univ_two] using hfirst'
    · have hd : density ≠ 0 := ne_of_gt hdensity
      simp [pWaveCoefficientMatrix]
      field_simp [hd]
      linarith

end NumStability.Leveque02Tracer
