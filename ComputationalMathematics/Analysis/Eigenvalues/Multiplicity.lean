import Mathlib.Analysis.InnerProductSpace.Spectrum
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Eigenspace.Basic
import Mathlib.LinearAlgebra.Dimension.Finrank


/-! Ordinary support: counting an absent spectral value gives zero,
so the finite-dimensional multiplicity formula needs no eigenvalue premise. -/

noncomputable section

namespace NumStability

open Module.End

theorem card_filter_symmetric_eigenvalues_eq_finrank
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    [FiniteDimensional ℝ E] {T : Module.End ℝ E}
    (hT : T.IsSymmetric) {n : ℕ} (hn : Module.finrank ℝ E = n) (μ : ℝ) :
    Finset.card {i | hT.eigenvalues hn i = μ} =
      Module.finrank ℝ (eigenspace T μ) := by
  classical
  by_cases hμ : HasEigenvalue T μ
  · exact hT.card_filter_eigenvalues_eq hn hμ
  · have hspace : eigenspace T μ = ⊥ := by
      by_contra hne
      exact hμ (hasEigenvalue_iff.mpr hne)
    have hcount : Finset.card {i | hT.eigenvalues hn i = μ} = 0 := by
      apply Finset.card_eq_zero.mpr
      apply Finset.filter_eq_empty_iff.mpr
      intro i _ hi
      exact hμ (by simpa only [hi] using hT.hasEigenvalue_eigenvalues hn i)
    rw [hcount, hspace, finrank_bot]


end NumStability

end

/-! Ordinary support for transporting an eigenspace between coordinate
functions and the canonical Euclidean-space realization of a matrix. -/

noncomputable section

namespace NumStability

open Module.End

theorem eigenspace_toEuclideanLin_eq_comap
    {ι : Type*} [Fintype ι] [DecidableEq ι] (A : Matrix ι ι ℝ) (μ : ℝ) :
    eigenspace A.toEuclideanLin μ =
      (eigenspace A.mulVecLin μ).comap
        (WithLp.linearEquiv 2 ℝ (ι → ℝ)).toLinearMap := by
  ext x
  simp only [Module.End.mem_eigenspace_iff, Submodule.mem_comap]
  change A.toEuclideanLin x = μ • x ↔
    A.mulVec (WithLp.ofLp x) = μ • WithLp.ofLp x
  exact (WithLp.ofLp_injective 2).eq_iff.symm

theorem finrank_eigenspace_toEuclideanLin_eq_mulVecLin
    {ι : Type*} [Fintype ι] [DecidableEq ι] (A : Matrix ι ι ℝ) (μ : ℝ) :
    Module.finrank ℝ (eigenspace A.toEuclideanLin μ) =
      Module.finrank ℝ (eigenspace A.mulVecLin μ) := by
  rw [eigenspace_toEuclideanLin_eq_comap,
    Submodule.comap_equiv_eq_map_symm, LinearEquiv.finrank_map_eq]


end NumStability

end
