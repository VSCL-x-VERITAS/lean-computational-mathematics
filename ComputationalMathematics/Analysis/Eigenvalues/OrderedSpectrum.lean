import ComputationalMathematics.Analysis.Eigenvalues.CourantFischer
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

/-!
# Complete-spectrum bridges for ordered Hermitian eigenvalues

This additive module keeps completeness and multiplicity bridges separate
from the frozen Courant--Fischer core.
-/

namespace NumStability

noncomputable section

/-- Every entry of the ordered eigenvalue sequence belongs to the spectrum of
the represented self-adjoint operator. -/
theorem hermitianOrderedEigenvalue_mem_spectrum {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian) (i : Fin n) :
    hermitianOrderedEigenvalue hA i ∈ spectrum ℝ A.toEuclideanLin := by
  exact ((Matrix.isHermitian_iff_isSymmetric.mp hA).hasEigenvalue_eigenvalues
    finrank_euclideanSpace_fin i).mem_spectrum

/-- The ordered sequence exhausts the complete spectrum. -/
theorem spectrum_eq_range_hermitianOrderedEigenvalue {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian) :
    spectrum ℝ A.toEuclideanLin = Set.range (hermitianOrderedEigenvalue hA) := by
  ext μ
  constructor
  · intro hμ
    have heig : Module.End.HasEigenvalue A.toEuclideanLin μ :=
      Module.End.HasEigenvalue.of_mem_spectrum hμ
    obtain ⟨i, hi⟩ :=
      (Matrix.isHermitian_iff_isSymmetric.mp hA).exists_eigenvalues_eq
        finrank_euclideanSpace_fin heig
    exact ⟨i, hi⟩
  · rintro ⟨i, rfl⟩
    exact hermitianOrderedEigenvalue_mem_spectrum hA i

/-- The ordered eigenvalue sequence records algebraic multiplicity. -/
theorem card_hermitianOrderedEigenvalue_eq {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian) {μ : ℝ}
    (hμ : Module.End.HasEigenvalue A.toEuclideanLin μ) :
    Finset.card {i | hermitianOrderedEigenvalue hA i = μ} =
      Module.finrank ℝ (Module.End.eigenspace A.toEuclideanLin μ) := by
  exact (Matrix.isHermitian_iff_isSymmetric.mp hA).card_filter_eigenvalues_eq
    finrank_euclideanSpace_fin hμ

end

end NumStability
