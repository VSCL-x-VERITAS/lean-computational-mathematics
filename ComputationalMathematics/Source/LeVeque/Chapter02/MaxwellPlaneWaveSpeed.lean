/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellPlaneWaveSpeedTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.SymmetricStrictHyperbolicity
import Mathlib.Tactic

/-!
# LeVeque equation (2.119): real transverse electromagnetic wave speeds
-/

namespace NumStability.Leveque02Tracer

/-- For positive `εμ`, the constant transverse Maxwell matrix has the two
real characteristic speeds `±1/√(εμ)` and a complete real eigenbasis. -/
theorem maxwellPlaneWaveSpeed : maxwellPlaneWaveSpeedTarget := by
  intro ε μ hproduct
  let speed : ℝ := 1 / Real.sqrt (ε * μ)
  let eigenvalues : Fin 2 → ℝ := ![-speed, speed]
  let eigenvectors : Fin 2 → (Fin 2 → ℝ) :=
    ![![-speed, 1], ![speed, 1]]
  have hrootpos : 0 < Real.sqrt (ε * μ) := Real.sqrt_pos.2 hproduct
  have hrootsq : (Real.sqrt (ε * μ)) ^ 2 = ε * μ :=
    Real.sq_sqrt hproduct.le
  have hspeedpos : 0 < speed := by
    dsimp [speed]
    exact one_div_pos.2 hrootpos
  have hspeedsq : speed ^ 2 = 1 / (ε * μ) := by
    dsimp [speed]
    rw [one_div, inv_pow, hrootsq]
    simp only [one_div]
  have hspeedsq' : speed ^ 2 = μ⁻¹ * ε⁻¹ := by
    simpa only [one_div, mul_inv_rev] using hspeedsq
  have hinjective : Function.Injective eigenvalues := by
    intro i j hij
    fin_cases i <;> fin_cases j
    · rfl
    · have h : -speed = speed := by simpa [eigenvalues] using hij
      exfalso
      linarith
    · have h : speed = -speed := by simpa [eigenvalues] using hij
      exfalso
      linarith
    · rfl
  have hnonzero : ∀ i, eigenvectors i ≠ 0 := by
    intro i
    fin_cases i
    · intro h
      have h1 := congrFun h (1 : Fin 2)
      simp [eigenvectors] at h1
    · intro h
      have h1 := congrFun h (1 : Fin 2)
      simp [eigenvectors] at h1
  have heigen : ∀ i,
      (maxwellPlaneWaveCoefficient ε μ).mulVec (eigenvectors i) =
        eigenvalues i • eigenvectors i := by
    intro i
    fin_cases i
    · ext j
      fin_cases j
      · simp [maxwellPlaneWaveCoefficient, eigenvectors, eigenvalues,
          Matrix.mulVec, dotProduct, Fin.sum_univ_two]
        nlinarith [hspeedsq']
      · simp [maxwellPlaneWaveCoefficient, eigenvectors, eigenvalues,
          Matrix.mulVec, dotProduct, Fin.sum_univ_two]
    · ext j
      fin_cases j
      · simp [maxwellPlaneWaveCoefficient, eigenvectors, eigenvalues,
          Matrix.mulVec, dotProduct, Fin.sum_univ_two]
        nlinarith [hspeedsq']
      · simp [maxwellPlaneWaveCoefficient, eigenvectors, eigenvalues,
          Matrix.mulVec, dotProduct, Fin.sum_univ_two]
  have hstrict :=
    symmetricStrictHyperbolicity.2
      (maxwellPlaneWaveCoefficient ε μ) eigenvalues eigenvectors
      hinjective hnonzero heigen
  exact ⟨hspeedpos, hinjective, hnonzero, heigen, hstrict.2⟩

end NumStability.Leveque02Tracer
