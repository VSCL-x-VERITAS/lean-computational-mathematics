import ComputationalMathematics.Analysis.SingularValues.Transpose
import ComputationalMathematics.HDP.Matrix.RealSVDFullBases
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Data.Real.Sqrt
import Mathlib.LinearAlgebra.Matrix.Rank

/-!
# Vershynin Chapter 4, compatible full-rank square SVD

This qualified source correspondence selects positive-size real square matrices
of full rank. Both complete singular families and the nonnegative Gram labels
are chosen jointly with the same ordered reconstruction coefficients. Repeated
singular values are permitted; no separate spectrum, tie rule or signed-label
convention is selected.

The target and proof retain their independently audited declarations. The proof
composes the existing full-basis SVD and rank-cutoff results. The general
rectangular, deficient-rank and zero-matrix source questions remain separate.
-/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Contract

/-- The independently audited positive-size, full-rank real square contract,
with complete singular families and compatible Gram eigenvalue labels. -/
def svdPositiveSquareFullRankCompatibleGramTarget : Prop :=
  ∀ (N : ℕ), 0 < N →
    ∀ (A : Matrix (Fin N) (Fin N) ℝ), A.rank = N →
      ∃ (s : Fin N → ℝ)
        (U V : OrthonormalBasis (Fin N) ℝ (EuclideanSpace ℝ (Fin N)))
        (lambdaLeft lambdaRight : Fin N → ℝ),
        (∀ k, 0 ≤ s k) ∧
          Antitone s ∧
          (∀ k, 0 < s k) ∧
          (∀ i j, A i j = ∑ k : Fin N, s k * U k i * V k j) ∧
          (∀ k, 0 ≤ lambdaLeft k ∧ 0 ≤ lambdaRight k ∧
            s k = Real.sqrt (lambdaLeft k) ∧
            s k = Real.sqrt (lambdaRight k) ∧
            (∀ i : Fin N,
              (∑ l : Fin N, (∑ j : Fin N, A i j * A l j) * U k l) =
                lambdaLeft k * U k i) ∧
            (∀ j : Fin N,
              (∑ l : Fin N, (∑ i : Fin N, A i j * A i l) * V k l) =
                lambdaRight k * V k j))

/-- Qualified Section 4.1.1 source correspondence, reusing the existing
full-basis SVD and rank-cutoff producers. -/
theorem svdPositiveSquareFullRankCompatibleGram :
    svdPositiveSquareFullRankCompatibleGramTarget := by
  intro N _ A hA
  obtain ⟨r, hm, hn, s, U, V, h⟩ :=
    NumStability.exists_realMatrixSVD_full_orthonormal_bases A
  have hr : r = N := h.rank_eq.trans hA
  subst r
  refine ⟨s, U, V, (fun k => s k ^ 2), (fun k => s k ^ 2),
    h.singularValues_nonnegative, h.singularValues_antitone, ?_, ?_, ?_⟩
  · intro k
    rw [h.toIsRealMatrixSVD.singularValue_eq_rectSingularValue k]
    apply (NumStability.rectSingularValue_pos_iff_lt_rank A k).2
    simpa only [hA] using k.isLt
  · intro i j
    simpa only [Fin.castLE_refl] using h.reconstruction i j
  · intro k
    refine ⟨sq_nonneg _, sq_nonneg _,
      (Real.sqrt_sq (h.singularValues_nonnegative k)).symm,
      (Real.sqrt_sq (h.singularValues_nonnegative k)).symm, ?_, ?_⟩
    · intro i
      simpa only [Fin.castLE_refl] using h.leftGram_eigenvector k i
    · intro j
      simpa only [Fin.castLE_refl] using h.rightGram_eigenvector k j

end NumStability.HDP.Contract
