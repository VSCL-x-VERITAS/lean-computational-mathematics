/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PSystemHyperbolicityTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.SymmetricStrictHyperbolicity
import Mathlib.Tactic

/-!
# Hyperbolicity of the p-system on positive specific volume
-/

namespace NumStability.Leveque02Tracer

/-- Negative pressure slope gives two distinct real characteristic speeds
and a complete real eigenbasis for the p-system flux Jacobian. -/
theorem pSystemHyperbolicity : pSystemHyperbolicityTarget := by
  intro pressureLaw specificVolume pressureSlope _ _ hslope
  let speed : ℝ := Real.sqrt (-pressureSlope)
  let coefficient : Matrix (Fin 2) (Fin 2) ℝ :=
    !![0, -1; pressureSlope, 0]
  let eigenvalues : Fin 2 → ℝ := ![-speed, speed]
  let eigenvectors : Fin 2 → (Fin 2 → ℝ) :=
    ![![1, speed], ![1, -speed]]
  have hspeed : 0 < speed := by
    exact Real.sqrt_pos.2 (by linarith)
  have hspeedSq : speed ^ 2 = -pressureSlope := by
    exact Real.sq_sqrt (by linarith : 0 ≤ -pressureSlope)
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
      have h0 := congrFun h (0 : Fin 2)
      simp [eigenvectors] at h0
    · intro h
      have h0 := congrFun h (0 : Fin 2)
      simp [eigenvectors] at h0
  have heigen : ∀ i, coefficient.mulVec (eigenvectors i) =
      eigenvalues i • eigenvectors i := by
    intro i
    fin_cases i
    · ext j
      fin_cases j
      · simp [coefficient, eigenvectors, eigenvalues, Matrix.mulVec,
          dotProduct, Fin.sum_univ_two]
      · simp [coefficient, eigenvectors, eigenvalues, Matrix.mulVec,
          dotProduct, Fin.sum_univ_two]
        nlinarith [hspeedSq]
    · ext j
      fin_cases j
      · simp [coefficient, eigenvectors, eigenvalues, Matrix.mulVec,
          dotProduct, Fin.sum_univ_two]
      · simp [coefficient, eigenvectors, eigenvalues, Matrix.mulVec,
          dotProduct, Fin.sum_univ_two]
        nlinarith [hspeedSq]
  have hstrict :=
    symmetricStrictHyperbolicity.2 coefficient eigenvalues eigenvectors
      hinjective hnonzero heigen
  exact ⟨hspeed, hstrict.2⟩

end NumStability.Leveque02Tracer
