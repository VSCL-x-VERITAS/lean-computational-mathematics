/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.WaveAcousticsSimilarityTarget
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 2: similarity and speeds of the first-order wave matrix
-/

namespace NumStability.Leveque02Tracer

/-- The wave matrix is a diagonal change of basis of the stationary-acoustics
matrix, and its two speeds are the left- and right-going sound speeds. -/
theorem waveAcousticsSimilarity : waveAcousticsSimilarityTarget := by
  intro bulkModulus density hbulk hdensity
  let soundSpeed := Real.sqrt (bulkModulus / density)
  let S : Matrix (Fin 2) (Fin 2) ℝ := Matrix.diagonal ![1, density]
  let SInv : Matrix (Fin 2) (Fin 2) ℝ := Matrix.diagonal ![1, density⁻¹]
  have hdensity_ne : density ≠ 0 := ne_of_gt hdensity
  have hspeed_sq : soundSpeed ^ 2 = bulkModulus / density := by
    exact Real.sq_sqrt (div_nonneg hbulk.le hdensity.le)
  have hleft : S * SInv = 1 := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [S, SInv, Matrix.mul_apply, Fin.sum_univ_two, hdensity_ne]
  have hright : SInv * S = 1 := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [S, SInv, Matrix.mul_apply, Fin.sum_univ_two, hdensity_ne]
  have hsimilar : waveFirstOrderMatrix soundSpeed =
      S * linearAcousticsMatrix bulkModulus density * SInv := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [waveFirstOrderMatrix, S, SInv, linearAcousticsMatrix,
        Matrix.mul_apply, Fin.sum_univ_two, hspeed_sq, hdensity_ne,
        div_eq_mul_inv]
  have heigen (negative : Bool) :
      Module.End.HasEigenvalue (Matrix.toLin' (waveFirstOrderMatrix soundSpeed))
        (if negative then -soundSpeed else soundSpeed) := by
    let speed := if negative then -soundSpeed else soundSpeed
    let vector : Fin 2 → ℝ := ![speed, 1]
    have hspeed : speed ^ 2 = soundSpeed ^ 2 := by
      cases negative <;> simp [speed]
    have hvec : (waveFirstOrderMatrix soundSpeed).mulVec vector = speed • vector := by
      ext i
      fin_cases i
      · simpa [waveFirstOrderMatrix, vector, Matrix.mulVec, dotProduct,
          Fin.sum_univ_two, pow_two] using hspeed.symm
      · simp [waveFirstOrderMatrix, vector, Matrix.mulVec, dotProduct,
          Fin.sum_univ_two]
    have hne : vector ≠ 0 := by
      intro hz
      have hcomponent := congrFun hz 1
      simp [vector] at hcomponent
    apply Module.End.hasEigenvalue_of_hasEigenvector
    rw [Module.End.hasEigenvector_iff]
    exact ⟨(Module.End.mem_eigenspace_iff).mpr
      (by simpa only [Matrix.toLin'_apply] using hvec), hne⟩
  exact ⟨hleft, hright, hsimilar, by simpa using heigen true,
    by simpa using heigen false⟩

end NumStability.Leveque02Tracer
