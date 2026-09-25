/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise23Target
import ComputationalMathematics.Source.LeVeque.Chapter02.WaveAcousticsSimilarity
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring

/-!
# Exercise 2.3: first-order wave eigenpairs and acoustic similarity
-/

namespace NumStability.Leveque02Tracer

/-- The explicit wave eigenvectors supplement the existing exact similarity
and eigenvalue theorem. -/
theorem exercise23 : exercise23Target := by
  intro bulkModulus density hbulk hdensity
  let speed := Real.sqrt (bulkModulus / density)
  let wave := waveFirstOrderMatrix speed
  let left : Fin 2 → ℝ := ![-speed, 1]
  let right : Fin 2 → ℝ := ![speed, 1]
  let S : Matrix (Fin 2) (Fin 2) ℝ := Matrix.diagonal ![1, density]
  let SInv : Matrix (Fin 2) (Fin 2) ℝ := Matrix.diagonal ![1, density⁻¹]
  have hspeed : 0 < speed := Real.sqrt_pos.2 (div_pos hbulk hdensity)
  have hleft : wave.mulVec left = (-speed) • left := by
    ext i
    fin_cases i
    · simp [wave, left, waveFirstOrderMatrix, Matrix.mulVec,
        dotProduct, Fin.sum_univ_two, pow_two]
    · simp [wave, left, waveFirstOrderMatrix, Matrix.mulVec,
        dotProduct, Fin.sum_univ_two]
  have hright : wave.mulVec right = speed • right := by
    ext i
    fin_cases i
    · simp [wave, right, waveFirstOrderMatrix, Matrix.mulVec,
        dotProduct, Fin.sum_univ_two, pow_two]
    · simp [wave, right, waveFirstOrderMatrix, Matrix.mulVec,
        dotProduct, Fin.sum_univ_two]
  have hleftNe : left ≠ 0 := by
    intro hz
    have hcomponent := congrFun hz (1 : Fin 2)
    simp [left] at hcomponent
  have hrightNe : right ≠ 0 := by
    intro hz
    have hcomponent := congrFun hz (1 : Fin 2)
    simp [right] at hcomponent
  have hsimilar := waveAcousticsSimilarity bulkModulus density hbulk hdensity
  dsimp only at hsimilar
  exact ⟨hspeed, hleft, hleftNe, hright, hrightNe,
    hsimilar.1, hsimilar.2.1, hsimilar.2.2.1⟩

end NumStability.Leveque02Tracer
