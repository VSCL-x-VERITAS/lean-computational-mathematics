/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise25Target
import ComputationalMathematics.Source.LeVeque.Chapter02.SymmetricStrictHyperbolicity
import Mathlib.Tactic

/-!
# Exercise 2.5: exact stress-slope condition for elastic hyperbolicity
-/

namespace NumStability.Leveque02Tracer

private theorem elastic_eigenvalue_sq
    (density stressSlope eigenvalue : ℝ) (v : Fin 2 → ℝ)
    (hvne : v ≠ 0)
    (hv : (nonlinearElasticCoefficient density stressSlope).mulVec v =
      eigenvalue • v) :
    stressSlope / density = eigenvalue ^ 2 := by
  have hfirst : -(v 1) = eigenvalue * v 0 := by
    have h := congrFun hv (0 : Fin 2)
    simpa [nonlinearElasticCoefficient, Matrix.mulVec, dotProduct,
      Fin.sum_univ_two] using h
  have hsecond : -(stressSlope / density) * v 0 =
      eigenvalue * v 1 := by
    have h := congrFun hv (1 : Fin 2)
    simpa [nonlinearElasticCoefficient, Matrix.mulVec, dotProduct,
      Fin.sum_univ_two] using h
  have hfirstNe : v 0 ≠ 0 := by
    intro hzero
    have hsecondZero : v 1 = 0 := by simpa [hzero] using hfirst
    apply hvne
    funext i
    fin_cases i <;> simp [hzero, hsecondZero]
  have hmul := congrArg (fun z : ℝ => eigenvalue * z) hfirst
  have hproduct :
      (stressSlope / density - eigenvalue ^ 2) * v 0 = 0 := by
    nlinarith [hsecond, hmul]
  have hzero := (mul_eq_zero.mp hproduct).resolve_right hfirstNe
  linarith

/-- Positive stress slope gives two real elastic wave families. Conversely,
zero slope is defective and negative slope has no real eigenbasis. -/
theorem exercise25 : exercise25Target := by
  intro stressLaw density strain stressSlope hdensity _
  let coefficient := nonlinearElasticCoefficient density stressSlope
  have hdensityNe : density ≠ 0 := ne_of_gt hdensity
  dsimp [exercise25Target]
  constructor
  · constructor
    · intro hhyper
      obtain ⟨eigenvalues, eigenbasis, heigen⟩ := hhyper
      have hnonneg : 0 ≤ stressSlope := by
        have hsquare := elastic_eigenvalue_sq density stressSlope
          (eigenvalues 0) (eigenbasis 0) (eigenbasis.ne_zero 0)
          (heigen 0)
        have hdiv : 0 ≤ stressSlope / density := by
          rw [hsquare]
          positivity
        have hslopeEq : stressSlope = (stressSlope / density) * density := by
          field_simp [hdensityNe]
        rw [hslopeEq]
        positivity
      by_contra hnotpositive
      have hzero : stressSlope = 0 := by
        have hnonpositive : stressSlope ≤ 0 := le_of_not_gt hnotpositive
        exact le_antisymm hnonpositive hnonneg
      let projection : (Fin 2 → ℝ) →ₗ[ℝ] ℝ := LinearMap.proj 1
      have hprojection : projection = 0 := eigenbasis.ext (fun p => by
        have hsquare := elastic_eigenvalue_sq density stressSlope
          (eigenvalues p) (eigenbasis p) (eigenbasis.ne_zero p)
          (heigen p)
        have heigenzero : eigenvalues p = 0 := by
          rw [hzero] at hsquare
          have hsqzero : eigenvalues p ^ 2 = 0 := by
            simpa using hsquare.symm
          nlinarith [hsqzero]
        have hfirst := congrFun (heigen p) (0 : Fin 2)
        simp [nonlinearElasticCoefficient,
          Matrix.mulVec, dotProduct, Fin.sum_univ_two,
          heigenzero] at hfirst
        simpa [projection] using hfirst)
      have hvalue := congrArg
        (fun f : (Fin 2 → ℝ) →ₗ[ℝ] ℝ => f ![0, 1]) hprojection
      norm_num [projection] at hvalue
    · intro hslope
      let speed := Real.sqrt (stressSlope / density)
      let eigenvalues : Fin 2 → ℝ := ![-speed, speed]
      let eigenvectors : Fin 2 → (Fin 2 → ℝ) :=
        ![![1, speed], ![1, -speed]]
      have hspeed : 0 < speed := Real.sqrt_pos.2 (div_pos hslope hdensity)
      have hspeedSq : speed ^ 2 = stressSlope / density :=
        Real.sq_sqrt (div_nonneg hslope.le hdensity.le)
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
          · simp [coefficient, nonlinearElasticCoefficient,
              eigenvectors, eigenvalues, Matrix.mulVec, dotProduct,
              Fin.sum_univ_two]
          · simp [coefficient, nonlinearElasticCoefficient,
              eigenvectors, eigenvalues, Matrix.mulVec, dotProduct,
              Fin.sum_univ_two]
            nlinarith [hspeedSq]
        · ext j
          fin_cases j
          · simp [coefficient, nonlinearElasticCoefficient,
              eigenvectors, eigenvalues, Matrix.mulVec, dotProduct,
              Fin.sum_univ_two]
          · simp [coefficient, nonlinearElasticCoefficient,
              eigenvectors, eigenvalues, Matrix.mulVec, dotProduct,
              Fin.sum_univ_two]
            nlinarith [hspeedSq]
      exact (symmetricStrictHyperbolicity.2 coefficient
        eigenvalues eigenvectors hinjective hnonzero heigen).2
  · intro hslope
    let speed := Real.sqrt (stressSlope / density)
    let eigenvalues : Fin 2 → ℝ := ![-speed, speed]
    let eigenvectors : Fin 2 → (Fin 2 → ℝ) :=
      ![![1, speed], ![1, -speed]]
    have hspeed : 0 < speed := Real.sqrt_pos.2 (div_pos hslope hdensity)
    have hspeedSq : speed ^ 2 = stressSlope / density :=
      Real.sq_sqrt (div_nonneg hslope.le hdensity.le)
    have heigen : ∀ i, coefficient.mulVec (eigenvectors i) =
        eigenvalues i • eigenvectors i := by
      intro i
      fin_cases i
      · ext j
        fin_cases j
        · simp [coefficient, nonlinearElasticCoefficient,
            eigenvectors, eigenvalues, Matrix.mulVec, dotProduct,
            Fin.sum_univ_two]
        · simp [coefficient, nonlinearElasticCoefficient,
            eigenvectors, eigenvalues, Matrix.mulVec, dotProduct,
            Fin.sum_univ_two]
          nlinarith [hspeedSq]
      · ext j
        fin_cases j
        · simp [coefficient, nonlinearElasticCoefficient,
            eigenvectors, eigenvalues, Matrix.mulVec, dotProduct,
            Fin.sum_univ_two]
        · simp [coefficient, nonlinearElasticCoefficient,
            eigenvectors, eigenvalues, Matrix.mulVec, dotProduct,
            Fin.sum_univ_two]
          nlinarith [hspeedSq]
    have hhas (i : Fin 2) :
        Module.End.HasEigenvalue (Matrix.toLin' coefficient) (eigenvalues i) := by
      apply Module.End.hasEigenvalue_of_hasEigenvector
      rw [Module.End.hasEigenvector_iff]
      have hne : eigenvectors i ≠ 0 := by
        fin_cases i <;> intro hz <;>
          have h0 := congrFun hz (0 : Fin 2) <;>
          simp [eigenvectors] at h0
      exact ⟨(Module.End.mem_eigenspace_iff).mpr
        (by simpa only [Matrix.toLin'_apply] using heigen i), hne⟩
    exact ⟨hspeed, by simpa [eigenvalues] using hhas 0,
      by simpa [eigenvalues] using hhas 1⟩

end NumStability.Leveque02Tracer
