/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.IsentropicSoundSpeedTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.FluidJacobian
import ComputationalMathematics.Source.LeVeque.Chapter02.SymmetricStrictHyperbolicity
import Mathlib.Tactic

/-!
# LeVeque equation (2.82): isentropic sound speed and its domain
-/

namespace NumStability.Leveque02Tracer

open Filter

/-- Positive pressure slope gives distinct real gas wave speeds; a positive
power law with exponent above one has vanishing sound speed toward vacuum. -/
theorem isentropicSoundSpeed : isentropicSoundSpeedTarget := by
  constructor
  · intro pressureLaw density velocity pressureSlope hdensity hslope hpressure
    dsimp only
    let soundSpeed := Real.sqrt pressureSlope
    let jacobian := fluidFluxJacobian
      (fluidConservedState density velocity) pressureSlope
    let eigenvalues : Fin 2 → ℝ := ![velocity - soundSpeed, velocity + soundSpeed]
    let eigenvectors : Fin 2 → (Fin 2 → ℝ) :=
      ![![1, velocity - soundSpeed], ![1, velocity + soundSpeed]]
    have hspeed : 0 < soundSpeed := Real.sqrt_pos.2 hslope
    have hspeedSq : soundSpeed ^ 2 = pressureSlope :=
      Real.sq_sqrt hslope.le
    have hmatrix : jacobian = !![0, 1; -velocity ^ 2 + pressureSlope, 2 * velocity] :=
      (fluidJacobian pressureLaw density velocity pressureSlope hdensity hpressure).1
    have hinjective : Function.Injective eigenvalues := by
      intro i j hij
      fin_cases i <;> fin_cases j
      · rfl
      · have h : velocity - soundSpeed = velocity + soundSpeed := by
          simpa [eigenvalues] using hij
        exfalso
        linarith
      · have h : velocity + soundSpeed = velocity - soundSpeed := by
          simpa [eigenvalues] using hij
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
    have heigen : ∀ i, jacobian.mulVec (eigenvectors i) =
        eigenvalues i • eigenvectors i := by
      intro i
      fin_cases i
      · ext j
        fin_cases j
        · simp [hmatrix, eigenvectors, eigenvalues, Matrix.mulVec,
            dotProduct, Fin.sum_univ_two]
        · simp [hmatrix, eigenvectors, eigenvalues, Matrix.mulVec,
            dotProduct, Fin.sum_univ_two]
          nlinarith [hspeedSq]
      · ext j
        fin_cases j
        · simp [hmatrix, eigenvectors, eigenvalues, Matrix.mulVec,
            dotProduct, Fin.sum_univ_two]
        · simp [hmatrix, eigenvectors, eigenvalues, Matrix.mulVec,
            dotProduct, Fin.sum_univ_two]
          nlinarith [hspeedSq]
    have hhas (i : Fin 2) :
        Module.End.HasEigenvalue (Matrix.toLin' jacobian) (eigenvalues i) := by
      apply Module.End.hasEigenvalue_of_hasEigenvector
      rw [Module.End.hasEigenvector_iff]
      exact ⟨(Module.End.mem_eigenspace_iff).mpr
        (by simpa only [Matrix.toLin'_apply] using heigen i), hnonzero i⟩
    have hstrict := symmetricStrictHyperbolicity.2
      jacobian eigenvalues eigenvectors hinjective hnonzero heigen
    exact ⟨hspeed, by simpa [eigenvalues] using hhas 0,
      by simpa [eigenvalues] using hhas 1, by linarith, hstrict.2⟩
  · intro coefficient exponent hcoefficient hexponent
    constructor
    · intro density hdensity
      exact (Real.hasDerivAt_rpow_const (Or.inl (ne_of_gt hdensity))).const_mul
        coefficient
    · have hpower : 0 < exponent - 1 := by linarith
      have hid : Filter.Tendsto (fun density : ℝ => density)
          (nhdsWithin (0 : ℝ) (Set.Ioi 0)) (nhds 0) :=
        tendsto_id.mono_left nhdsWithin_le_nhds
      have hrpow : Filter.Tendsto (fun density : ℝ => density ^ (exponent - 1))
          (nhdsWithin (0 : ℝ) (Set.Ioi 0)) (nhds 0) := by
        simpa [Real.zero_rpow (ne_of_gt hpower)] using
          hid.rpow_const (Or.inr hpower.le)
      have hscaled : Filter.Tendsto
          (fun density : ℝ => coefficient * (exponent * density ^ (exponent - 1)))
          (nhdsWithin (0 : ℝ) (Set.Ioi 0)) (nhds 0) := by
        simpa only [mul_assoc, mul_zero] using
          hrpow.const_mul (coefficient * exponent)
      simpa using (Real.continuous_sqrt.tendsto 0).comp hscaled

end NumStability.Leveque02Tracer
