/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveEigenvaluesTarget
import Mathlib.Tactic

/-!
# LeVeque equation (2.94): compressional-wave speed and eigenvalues
-/

namespace NumStability.Leveque02Tracer

/-- The P-wave matrix has the two real eigenvalues given by its positive
compressional speed. -/
theorem pWaveEigenvalues : pWaveEigenvaluesTarget := by
  intro lameLambda shearModulus density hdensity hmodulus
  let K : ℝ := lameLambda + 2 * shearModulus
  let speed : ℝ := compressionalWaveSpeed lameLambda shearModulus density
  have hratio : 0 < K / density := div_pos (by simpa [K] using hmodulus) hdensity
  have hspeed : 0 < speed := by
    exact Real.sqrt_pos.2 (by simpa [speed, compressionalWaveSpeed, K] using hratio)
  have hspeedSq : speed ^ 2 = K / density := by
    simpa [speed, compressionalWaveSpeed, K] using Real.sq_sqrt hratio.le
  have heigen (negative : Bool) :
      Module.End.HasEigenvalue
        (Matrix.toLin' (pWaveCoefficientMatrix lameLambda shearModulus density))
        (if negative then -speed else speed) := by
    let eigenvalue : ℝ := if negative then -speed else speed
    let vector : Fin 2 → ℝ := ![1, -eigenvalue]
    have heigenSq : eigenvalue ^ 2 = K / density := by
      cases negative <;> simpa [eigenvalue] using hspeedSq
    have hvec : (pWaveCoefficientMatrix lameLambda shearModulus density).mulVec
        vector = eigenvalue • vector := by
      ext i
      fin_cases i
      · simp [pWaveCoefficientMatrix, vector, Matrix.mulVec, dotProduct,
          Fin.sum_univ_two]
      · simpa [pWaveCoefficientMatrix, vector, Matrix.mulVec, dotProduct,
          Fin.sum_univ_two, K, pow_two] using heigenSq.symm
    have hne : vector ≠ 0 := by
      intro hz
      have hcomponent := congrFun hz (0 : Fin 2)
      simp [vector] at hcomponent
    apply Module.End.hasEigenvalue_of_hasEigenvector
    rw [Module.End.hasEigenvector_iff]
    exact ⟨(Module.End.mem_eigenspace_iff).mpr
      (by simpa only [Matrix.toLin'_apply] using hvec), hne⟩
  exact ⟨hspeed, by simpa using heigen true, by simpa using heigen false⟩

end NumStability.Leveque02Tracer
