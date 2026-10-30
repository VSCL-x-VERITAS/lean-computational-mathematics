import ComputationalMathematics.HDP.Graph.CertifiedSecondEigenvector
import Mathlib.Analysis.InnerProductSpace.Projection.Reflection

/-!
# Complete certificates for arbitrary unit second eigenvectors

Reflecting the canonical eigenbasis within one eigenspace places a supplied
unit eigenvector in its designated slot, including repeated eigenvalues.
-/

noncomputable section

namespace NumStability.HDP.Graph.SpectralClustering

private theorem reflection_preserves_eigenvector {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsHermitian)
    (u v x : EuclideanSpace ℝ (Fin n)) (α μ : ℝ)
    (hu : A.toEuclideanLin u = α • u)
    (hv : A.toEuclideanLin v = α • v)
    (hx : A.toEuclideanLin x = μ • x) :
    A.toEuclideanLin ((ℝ ∙ (u - v))ᗮ.reflection x) =
      μ • ((ℝ ∙ (u - v))ᗮ.reflection x) := by
  have hw : A.toEuclideanLin (u - v) = α • (u - v) := by
    rw [map_sub, hu, hv, smul_sub]
  by_cases hα : α = μ
  · subst μ
    simp only [Submodule.reflection_orthogonal_apply, Submodule.reflection_singleton_apply,
      map_neg, map_sub, map_nsmul, map_smul, hw, hx]
    module
  · have hinner : inner ℝ (u - v) x = 0 :=
      (Matrix.isHermitian_iff_isSymmetric.mp hA).orthogonalFamily_eigenspaces hα
        ⟨u - v, Module.End.mem_eigenspace_iff.mpr hw⟩
        ⟨x, Module.End.mem_eigenspace_iff.mpr hx⟩
    have hfix : (ℝ ∙ (u - v))ᗮ.reflection x = x :=
      Submodule.reflection_mem_subspace_eq_self
        (Submodule.mem_orthogonal_singleton_iff_inner_right.mpr hinner)
    rw [hfix]
    exact hx

/-- Every unit vector at the second ordered value extends to a complete
decreasing orthonormal eigenbasis, even when that eigenvalue is repeated. -/
theorem isSecondOrderedEigenvector_of_unit_eigenvector
    {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsHermitian)
    (hn : 1 < n) (v : EuclideanSpace ℝ (Fin n)) (hv : ‖v‖ = 1)
    (heigen : A.toEuclideanLin v =
      NumStability.hermitianOrderedEigenvalue hA ⟨1, hn⟩ • v) :
    IsSecondOrderedEigenvector A hn v := by
  let b := NumStability.hermitianOrderedEigenbasis hA
  let u := b ⟨1, hn⟩
  let R := (ℝ ∙ (u - v))ᗮ.reflection
  refine ⟨NumStability.hermitianOrderedEigenvalue hA, b.map R,
    NumStability.hermitianOrderedEigenvalue_antitone hA, ?_, ?_⟩
  · intro i
    change A.toEuclideanLin (R (b i)) =
      NumStability.hermitianOrderedEigenvalue hA i • R (b i)
    exact reflection_preserves_eigenvector A hA u v (b i)
      (NumStability.hermitianOrderedEigenvalue hA ⟨1, hn⟩)
      (NumStability.hermitianOrderedEigenvalue hA i)
      (NumStability.hermitianOrderedEigenbasis_apply hA ⟨1, hn⟩)
      heigen (NumStability.hermitianOrderedEigenbasis_apply hA i)
  · change v = R u
    symm
    exact Submodule.reflection_sub ((b.norm_eq_one ⟨1, hn⟩).trans hv.symm)

/-- The complete certificate has exactly the ordinary unit-vector and
second ordered eigenvalue specification, without an eigenvalue-gap premise. -/
theorem isSecondOrderedEigenvector_iff_unit_eigenvector
    {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsHermitian)
    (hn : 1 < n) (v : EuclideanSpace ℝ (Fin n)) :
    IsSecondOrderedEigenvector A hn v ↔
      ‖v‖ = 1 ∧ A.toEuclideanLin v =
        NumStability.hermitianOrderedEigenvalue hA ⟨1, hn⟩ • v := by
  constructor
  · intro hv
    exact hv.spec hA
  · rintro ⟨hv, heigen⟩
    exact isSecondOrderedEigenvector_of_unit_eigenvector A hA hn v hv heigen

end NumStability.HDP.Graph.SpectralClustering
