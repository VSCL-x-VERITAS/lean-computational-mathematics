import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LowRankApproximation.ColumnSketches.RealSVD

/-!
# Vershynin Chapter 4, positive-rank active SVD component

This explicitly qualified source correspondence retains the common reconstruction, scalar ordering and zero
extension, both active orthonormal families, and both active Gram eigenpairs
with their nonnegative square-root coefficients. Its eigenvalue witnesses are
indexed by the active rank. It selects no complete-spectrum padding or extra
vector-family completion convention. The completed independent statement audit accepts this active component.
The original whole-list and full-basis source uncertainties remain separate.
-/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Contract

/-- The independently audited positive-dimension, positive-rank
active component. Every eigenvalue witness belongs to the same reconstruction. -/
def svdPositiveRankActiveGramRoots : Prop :=
  ∀ {m n : ℕ}, 0 < m → 0 < n →
    ∀ (A : Matrix (Fin m) (Fin n) ℝ), 0 < A.rank →
    ∃ (r : ℕ) (s : Fin n → ℝ)
      (u : Fin r → EuclideanSpace ℝ (Fin m))
      (v : Fin r → EuclideanSpace ℝ (Fin n))
      (hwidth : r ≤ n),
      NumStability.RealMatrixSVDExplicitFields A r s u v ∧
        ∃ (lambdaLeft lambdaRight : Fin r → ℝ),
          ∀ a : Fin r,
            0 ≤ lambdaLeft a ∧ 0 ≤ lambdaRight a ∧
              s (Fin.castLE hwidth a) = Real.sqrt (lambdaLeft a) ∧
              s (Fin.castLE hwidth a) = Real.sqrt (lambdaRight a) ∧
              (∀ i : Fin m,
                (∑ l : Fin m, (∑ j : Fin n, A i j * A l j) * u a l) =
                  lambdaLeft a * u a i) ∧
              (∀ j : Fin n,
                (∑ l : Fin n, (∑ i : Fin m, A i j * A i l) * v a l) =
                  lambdaRight a * v a j)

/-- The qualified active component of the Section 4.1.1 SVD paragraph, using
its existing common Gram-enriched reconstruction witness. -/
theorem hdp_04_svd_positive_rank_active_gram_roots :
    svdPositiveRankActiveGramRoots := by
  intro m n _hm _hn A _hrank
  obtain ⟨r, s, u, v, h⟩ := NumStability.exists_isRealMatrixSVDWithGramEigenrelations A
  refine ⟨r, s, u, v, h.rank_le_width,
    NumStability.isRealMatrixSVD_iff_explicit_fields.mp h.toIsRealMatrixSVD,
    (fun a ↦ s (Fin.castLE h.rank_le_width a) ^ 2),
    (fun a ↦ s (Fin.castLE h.rank_le_width a) ^ 2), ?_⟩
  intro a
  exact ⟨sq_nonneg _, sq_nonneg _,
    (Real.sqrt_sq (h.singularValues_nonnegative _)).symm,
    (Real.sqrt_sq (h.singularValues_nonnegative _)).symm,
    h.leftGram_eigenvector a, h.rightGram_eigenvector a⟩

end NumStability.HDP.Contract
