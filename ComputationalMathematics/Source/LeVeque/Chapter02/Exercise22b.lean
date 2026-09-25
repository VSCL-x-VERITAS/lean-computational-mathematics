/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise22bTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.IsentropicSoundSpeed
import ComputationalMathematics.Source.LeVeque.Chapter02.SymmetricStrictHyperbolicity
import Mathlib.Tactic

/-!
# Exercise 2.2(b): primitive gas hyperbolicity
-/

namespace NumStability.Leveque02Tracer

/-- The primitive and conservative gas systems have the same two distinct
real characteristic speeds when the pressure slope is positive. -/
theorem exercise22b : exercise22bTarget := by
  intro pressureLaw densityFromPressure density velocity pressureSlope
    hdensity hslope hpressure hinverse
  let speed := Real.sqrt pressureSlope
  let primitive := primitiveGasCoefficient density velocity pressureSlope
  let conservative := fluidFluxJacobian
    (fluidConservedState density velocity) pressureSlope
  let eigenvalues : Fin 2 → ℝ := ![velocity - speed, velocity + speed]
  let eigenvectors : Fin 2 → (Fin 2 → ℝ) :=
    ![![-density * speed, 1], ![density * speed, 1]]
  have hspeed : 0 < speed := Real.sqrt_pos.2 hslope
  have hspeedSq : speed ^ 2 = pressureSlope := Real.sq_sqrt hslope.le
  have hdensityNe : density ≠ 0 := ne_of_gt hdensity
  have hinjective : Function.Injective eigenvalues := by
    intro i j hij
    fin_cases i <;> fin_cases j
    · rfl
    · have h : velocity - speed = velocity + speed := by
        simpa [eigenvalues] using hij
      exfalso
      linarith
    · have h : velocity + speed = velocity - speed := by
        simpa [eigenvalues] using hij
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
  have heigen : ∀ i, primitive.mulVec (eigenvectors i) =
      eigenvalues i • eigenvectors i := by
    intro i
    fin_cases i
    · ext j
      fin_cases j
      · simp [primitive, primitiveGasCoefficient, eigenvectors,
          eigenvalues, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
        nlinarith [hspeedSq]
      · simp [primitive, primitiveGasCoefficient, eigenvectors,
          eigenvalues, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
        field_simp [hdensityNe]
        ring
    · ext j
      fin_cases j
      · simp [primitive, primitiveGasCoefficient, eigenvectors,
          eigenvalues, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
        nlinarith [hspeedSq]
      · simp [primitive, primitiveGasCoefficient, eigenvectors,
          eigenvalues, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
        field_simp [hdensityNe]
        ring
  have hprimitiveEigen (i : Fin 2) :
      Module.End.HasEigenvalue (Matrix.toLin' primitive) (eigenvalues i) := by
    apply Module.End.hasEigenvalue_of_hasEigenvector
    rw [Module.End.hasEigenvector_iff]
    exact ⟨(Module.End.mem_eigenspace_iff).mpr
      (by simpa only [Matrix.toLin'_apply] using heigen i), hnonzero i⟩
  have hprimitiveHyper := (symmetricStrictHyperbolicity.2
    primitive eigenvalues eigenvectors hinjective hnonzero heigen).2
  have hconservative := isentropicSoundSpeed.1
    pressureLaw density velocity pressureSlope hdensity hslope hpressure
  dsimp only at hconservative
  dsimp [exercise22bTarget]
  exact ⟨hspeed, by linarith, hprimitiveHyper, hconservative.2.2.2.2,
    by simpa [eigenvalues] using hprimitiveEigen 0,
    by simpa [eigenvalues] using hprimitiveEigen 1,
    hconservative.2.1, hconservative.2.2.1⟩

end NumStability.Leveque02Tracer
