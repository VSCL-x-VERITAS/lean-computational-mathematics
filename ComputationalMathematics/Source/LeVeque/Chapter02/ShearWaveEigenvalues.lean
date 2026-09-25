/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveEigenvaluesTarget
import Mathlib.Tactic

/-!
# LeVeque equation (2.101): shear-wave speed and eigenvalues
-/

namespace NumStability.Leveque02Tracer

/-- The strain–velocity and stress–velocity S-wave matrices have the same two
real eigenvalues, determined by the positive shear speed. -/
theorem shearWaveEigenvalues : shearWaveEigenvaluesTarget := by
  intro shearModulus density hshear hdensity
  let speed : ℝ := shearWaveSpeed shearModulus density
  have hratio : 0 < shearModulus / density := div_pos hshear hdensity
  have hspeed : 0 < speed := by
    exact Real.sqrt_pos.2 (by simpa [speed, shearWaveSpeed] using hratio)
  have hspeedSq : speed ^ 2 = shearModulus / density := by
    simpa [speed, shearWaveSpeed] using Real.sq_sqrt hratio.le
  have heigenStrain (negative : Bool) :
      Module.End.HasEigenvalue
        (Matrix.toLin' (shearWaveCoefficientMatrix shearModulus density))
        (if negative then -speed else speed) := by
    let eigenvalue : ℝ := if negative then -speed else speed
    let vector : Fin 2 → ℝ := ![1, -2 * eigenvalue]
    have heigenSq : eigenvalue ^ 2 = shearModulus / density := by
      cases negative <;> simpa [eigenvalue] using hspeedSq
    have hcoeff : -(2 * shearModulus / density) =
        eigenvalue * (-2 * eigenvalue) := by
      calc
        -(2 * shearModulus / density) = -2 * (shearModulus / density) := by ring
        _ = -2 * eigenvalue ^ 2 := by rw [heigenSq]
        _ = eigenvalue * (-2 * eigenvalue) := by ring
    have hvec : (shearWaveCoefficientMatrix shearModulus density).mulVec
        vector = eigenvalue • vector := by
      ext i
      fin_cases i
      · simp [shearWaveCoefficientMatrix, vector, Matrix.mulVec, dotProduct,
          Fin.sum_univ_two]
      · simpa [shearWaveCoefficientMatrix, vector, Matrix.mulVec, dotProduct,
          Fin.sum_univ_two] using hcoeff
    have hne : vector ≠ 0 := by
      intro hz
      have hcomponent := congrFun hz (0 : Fin 2)
      simp [vector] at hcomponent
    apply Module.End.hasEigenvalue_of_hasEigenvector
    rw [Module.End.hasEigenvector_iff]
    exact ⟨(Module.End.mem_eigenspace_iff).mpr
      (by simpa only [Matrix.toLin'_apply] using hvec), hne⟩
  have heigenStress (negative : Bool) :
      Module.End.HasEigenvalue
        (Matrix.toLin' (shearWaveStressVelocityMatrix shearModulus density))
        (if negative then -speed else speed) := by
    let eigenvalue : ℝ := if negative then -speed else speed
    let vector : Fin 2 → ℝ := ![density * eigenvalue, -1]
    have heigenSq : eigenvalue ^ 2 = shearModulus / density := by
      cases negative <;> simpa [eigenvalue] using hspeedSq
    have hnonzero : density ≠ 0 := ne_of_gt hdensity
    have hsqMul : eigenvalue ^ 2 * density = shearModulus :=
      (eq_div_iff hnonzero).mp heigenSq
    have hvec : (shearWaveStressVelocityMatrix shearModulus density).mulVec
        vector = eigenvalue • vector := by
      ext i
      fin_cases i
      · simp [shearWaveStressVelocityMatrix, vector, Matrix.mulVec, dotProduct,
          Fin.sum_univ_two]
        nlinarith [hsqMul]
      · simp [shearWaveStressVelocityMatrix, vector, Matrix.mulVec, dotProduct,
          Fin.sum_univ_two, hnonzero]
    have hne : vector ≠ 0 := by
      intro hz
      have hcomponent := congrFun hz (1 : Fin 2)
      simp [vector] at hcomponent
    apply Module.End.hasEigenvalue_of_hasEigenvector
    rw [Module.End.hasEigenvector_iff]
    exact ⟨(Module.End.mem_eigenspace_iff).mpr
      (by simpa only [Matrix.toLin'_apply] using hvec), hne⟩
  exact ⟨hspeed, by simpa using heigenStrain true,
    by simpa using heigenStrain false,
    by simpa using heigenStress true,
    by simpa using heigenStress false⟩

end NumStability.Leveque02Tracer
