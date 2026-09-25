/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.SymmetricStrictHyperbolicityTarget

/-!
# Symmetric and strict hyperbolicity criteria
-/

namespace NumStability.Leveque02Tracer

/-- Real symmetric matrices have a complete real eigenbasis, and distinct
real eigenvalues have independent nonzero right eigenvectors. -/
theorem symmetricStrictHyperbolicity : symmetricStrictHyperbolicityTarget := by
  constructor
  · intro m coefficient hsymmetric
    have hhermitian : coefficient.IsHermitian := by
      change coefficient.conjTranspose = coefficient
      simpa only [Matrix.conjTranspose_eq_transpose_of_trivial] using hsymmetric
    let b : Module.Basis (Fin m) ℝ (Fin m → ℝ) :=
      hhermitian.eigenvectorBasis.toBasis.map
        (EuclideanSpace.equiv (Fin m) ℝ).toLinearEquiv
    refine ⟨hhermitian.eigenvalues, b, ?_⟩
    intro p
    simpa only [b, Module.Basis.map_apply] using
      hhermitian.mulVec_eigenvectorBasis p
  · intro m coefficient eigenvalues eigenvectors hinjective hnonzero heigen
    have heigenvectors : ∀ p,
        Module.End.HasEigenvector (Matrix.toLin' coefficient)
          (eigenvalues p) (eigenvectors p) := by
      intro p
      exact ⟨(Module.End.mem_eigenspace_iff).mpr
        (by simpa only [Matrix.toLin'_apply] using heigen p), hnonzero p⟩
    have hindependent : LinearIndependent ℝ eigenvectors :=
      Module.End.eigenvectors_linearIndependent'
        (Matrix.toLin' coefficient) eigenvalues hinjective eigenvectors heigenvectors
    exact ⟨hindependent,
      (NumStability.isRealHyperbolicMatrix_iff_independent_real_eigenvectors coefficient).mpr
        ⟨eigenvalues, eigenvectors, hindependent, heigen⟩⟩

end NumStability.Leveque02Tracer
