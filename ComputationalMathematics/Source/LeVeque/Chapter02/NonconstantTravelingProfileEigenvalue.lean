/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.NonconstantTravelingProfileEigenvalueTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.TravelingProfileMatrixEquationLocal
import Mathlib.Analysis.Calculus.MeanValue

/-!
# LeVeque Chapter 2: a nonconstant traveling wave has an eigenvalue speed
-/

namespace NumStability.Leveque02Tracer

/-- A nonconstant profile has a nonzero derivative somewhere, while every
nonzero profile derivative along a traveling-wave solution is an eigenvector. -/
theorem nonconstantTravelingProfileEigenvalue :
    nonconstantTravelingProfileEigenvalueTarget := by
  intro m hm coefficient profile speed hdiff hnonconstant hsolution
  have heigenvector (ξ : ℝ) (hne : deriv profile ξ ≠ 0) :
      Module.End.HasEigenvector (Matrix.toLin' coefficient) speed
        (deriv profile ξ) := by
    have hprofile : HasDerivAt profile (deriv profile ξ)
        (ξ - speed * 0) := by
      simpa using (hdiff ξ).hasDerivAt
    have hmatrix := (travelingProfileMatrixEquationLocal
      m hm coefficient profile (deriv profile ξ) speed ξ 0 hprofile).mp
        (hsolution ξ 0)
    rw [Module.End.hasEigenvector_iff]
    constructor
    · rw [Module.End.mem_eigenspace_iff, Matrix.toLin'_apply]
      exact hmatrix
    · exact hne
  have hnonzero : ∃ ξ : ℝ, deriv profile ξ ≠ 0 := by
    by_contra h
    push_neg at h
    obtain ⟨a, b, hab⟩ := hnonconstant
    exact hab (is_const_of_deriv_eq_zero hdiff h a b)
  obtain ⟨ξ, hne⟩ := hnonzero
  exact ⟨Module.End.hasEigenvalue_of_hasEigenvector (heigenvector ξ hne),
    heigenvector⟩

end NumStability.Leveque02Tracer
