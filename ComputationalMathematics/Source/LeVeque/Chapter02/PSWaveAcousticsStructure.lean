/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PSWaveAcousticsStructureTarget
import Mathlib.Tactic

/-!
# LeVeque Chapter 2: PSWaveAcousticsStructure

Acoustic structure of pressure and shear waves in the stress system.
-/

namespace NumStability.Leveque02Tracer

private noncomputable def stressVelocityMatrix (bulkModulus density : ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  !![0, -bulkModulus; -density⁻¹, 0]

/-- Negating the stress coordinate turns either stress-velocity system into
the scalar pressure-velocity acoustics equations, including actual derivative
witnesses in both directions. -/
private theorem stressVelocity_matrixForm_iff
    (stress velocity : ℝ → ℝ → ℝ) (bulkModulus density x t : ℝ) :
    IsConstantCoefficientLinearSystemSolutionAt
        (linearAcousticsState stress velocity)
        (stressVelocityMatrix bulkModulus density) x t ↔
      IsLinearAcousticsSolutionAt
        (fun ξ τ => -stress ξ τ) velocity bulkModulus density x t := by
  constructor
  · rintro ⟨qt, qx, ht, hx, hresidual⟩
    have hst : HasDerivAt (fun τ => stress x τ) (qt 0) t := by
      simpa [linearAcousticsState] using (hasDerivAt_pi.mp ht 0)
    have hsx : HasDerivAt (fun ξ => stress ξ t) (qx 0) x := by
      simpa [linearAcousticsState] using (hasDerivAt_pi.mp hx 0)
    have hvt : HasDerivAt (fun τ => velocity x τ) (qt 1) t := by
      simpa [linearAcousticsState] using (hasDerivAt_pi.mp ht 1)
    have hvx : HasDerivAt (fun ξ => velocity ξ t) (qx 1) x := by
      simpa [linearAcousticsState] using (hasDerivAt_pi.mp hx 1)
    have h0 := congrFun hresidual (0 : Fin 2)
    have h1 := congrFun hresidual (1 : Fin 2)
    simp [stressVelocityMatrix, dotProduct,
      Fin.sum_univ_two] at h0 h1
    refine ⟨-(qt 0), -(qx 0), qt 1, qx 1,
      by simpa using hst.neg, by simpa using hsx.neg, hvt, hvx, ?_, ?_⟩
    · nlinarith [h0]
    · nlinarith [h1]
  · rintro ⟨pt, px, ut, ux, hpt, hpx, hut, hux, hpressure, hvelocity⟩
    refine ⟨![-pt, ut], ![-px, ux], ?_, ?_, ?_⟩
    · rw [hasDerivAt_pi]
      intro i
      fin_cases i
      · have hfun : (fun τ : ℝ => stress x τ) =
            -(fun τ : ℝ => -stress x τ) := by
          funext τ
          simp
        change HasDerivAt (fun τ => stress x τ) (-pt) t
        rw [hfun]
        exact hpt.neg
      · simpa [linearAcousticsState] using hut
    · rw [hasDerivAt_pi]
      intro i
      fin_cases i
      · have hfun : (fun ξ : ℝ => stress ξ t) =
            -(fun ξ : ℝ => -stress ξ t) := by
          funext ξ
          simp
        change HasDerivAt (fun ξ => stress ξ t) (-px) x
        rw [hfun]
        exact hpx.neg
      · simpa [linearAcousticsState] using hux
    · funext i
      fin_cases i
      · simp [stressVelocityMatrix]
        nlinarith [hpressure]
      · simp [stressVelocityMatrix]
        nlinarith [hvelocity]

theorem pSWaveAcousticsStructure : pSWaveAcousticsStructureTarget := by
  intro lameLambda shearModulus density _hdensity _hbulk _hshear
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [stressToPressureSign, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [linearAcousticsMatrix, stressToPressureSign,
        pWaveStressVelocityMatrix, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [linearAcousticsMatrix, stressToPressureSign,
        shearWaveStressVelocityMatrix, Matrix.mul_apply, Fin.sum_univ_two]
  · intro X x t
    constructor
    · ext i
      fin_cases i <;>
        simp [stressToPressureSign, pWaveStressVelocityState,
          linearAcousticsState, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
    · simpa [pWaveStressVelocityState, pWaveStressVelocityMatrix,
        stressVelocityMatrix, linearAcousticsState, one_div] using
        (stressVelocity_matrixForm_iff
          (fun ξ τ => planeNormalStress lameLambda shearModulus
            (longitudinalStrain X) ξ τ)
          (longitudinalMaterialVelocity X)
          (lameLambda + 2 * shearModulus) density x t)
  · intro W x t
    constructor
    · ext i
      fin_cases i <;>
        simp [stressToPressureSign, shearWaveStressVelocityState,
          linearAcousticsState, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
    · simpa [shearWaveStressVelocityState, shearWaveStressVelocityMatrix,
        stressVelocityMatrix, linearAcousticsState, one_div] using
        (stressVelocity_matrixForm_iff
          (fun ξ τ => planeShearStress shearModulus
            (shearWaveStrain W) ξ τ)
          (shearWaveVelocity W) shearModulus density x t)

end NumStability.Leveque02Tracer
