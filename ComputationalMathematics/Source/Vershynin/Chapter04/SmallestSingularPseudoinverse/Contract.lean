import ComputationalMathematics.Analysis.OperatorNorms.RealComplexification
import ComputationalMathematics.Analysis.Eigenvalues.OrderedSpectrum
import ComputationalMathematics.Analysis.SingularValues.ExtremeValues
import ComputationalMathematics.Source.Higham.Chapter14.Section05.SpectralConvergence
import ComputationalMathematics.Source.Higham.Chapter20.Lemma11.Core.Results

/-!
# Vershynin Chapter 4: smallest singular value and pseudoinverse

Thin source contract for the full-column-rank characterization by the smallest
singular value and its reciprocal Moore--Penrose pseudoinverse norm formula.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Chapter 4, p. 77: for a tall real matrix, full column rank is
equivalent to positivity of the smallest singular value; in the full-rank
case that value is the reciprocal operator norm of the Moore--Penrose
pseudoinverse. -/
theorem hdp_04_smallest_singular_value_full_rank_and_pseudoinverse
    {m k : Nat}
    (A : Fin m → Fin (k + 1) → Real) :
    spectrum ℝ
        (NumStability.rectCourantFischerRightGram A).toEuclideanLin =
      Set.range (NumStability.hermitianOrderedEigenvalue
        (NumStability.rectCourantFischerRightGram_isHermitian A)) ∧
    (∀ μ : ℝ,
      Module.End.HasEigenvalue
          (NumStability.rectCourantFischerRightGram A).toEuclideanLin μ →
        Finset.card {i |
          NumStability.hermitianOrderedEigenvalue
              (NumStability.rectCourantFischerRightGram_isHermitian A) i = μ} =
          Module.finrank ℝ (Module.End.eigenspace
            (NumStability.rectCourantFischerRightGram A).toEuclideanLin μ)) ∧
    (∀ i j : Fin (k + 1), i ≤ j →
      NumStability.rectCourantFischerSingularValue A j ≤
        NumStability.rectCourantFischerSingularValue A i) ∧
    (∀ i : Fin (k + 1),
      NumStability.rectCourantFischerSingularValue A (Fin.last k) ≤
        NumStability.rectCourantFischerSingularValue A i) ∧
    (NumStability.rectCourantFischerSingularValue A (Fin.last k) ≠ 0 →
      k + 1 ≤ m) ∧
    (k + 1 ≤ m →
      (NumStability.complexMatrixRank
          (NumStability.realRectToCMatrix A) = k + 1 ↔
        0 < NumStability.rectCourantFischerSingularValue A (Fin.last k))) ∧
    (∃ Aplus : Fin (k + 1) → Fin m → Real,
      NumStability.RectMoorePenrosePseudoinverse m (k + 1) A Aplus) ∧
    (∀ Aplus : Fin (k + 1) → Fin m → Real,
      NumStability.RectMoorePenrosePseudoinverse m (k + 1) A Aplus →
      NumStability.complexMatrixRank (NumStability.realRectToCMatrix A) = k + 1 →
        NumStability.rectCourantFischerSingularValue A (Fin.last k) =
          1 / NumStability.realMatrixOperatorNorm Aplus) := by
  have hbridge :=
    NumStability.realRectToCMatrix_last_singularValue_eq_rectCourantFischer A
  refine ⟨NumStability.spectrum_eq_range_hermitianOrderedEigenvalue
      (NumStability.rectCourantFischerRightGram_isHermitian A),
    fun _ hμ ↦ NumStability.card_hermitianOrderedEigenvalue_eq
      (NumStability.rectCourantFischerRightGram_isHermitian A) hμ,
    NumStability.rectCourantFischerSingularValue_antitone A,
    ?_, ?_, ?_, ?_, ?_⟩
  · intro i
    exact NumStability.rectCourantFischerSingularValue_antitone A
      (Fin.le_last i)
  · intro hne
    rw [← hbridge] at hne
    exact
      NumStability.complexMatrixSingularValue_last_ne_zero_imp_card_le_height
        (NumStability.realRectToCMatrix A) hne
  · intro _hmn
    rw [← hbridge]
    exact
      (NumStability.complexMatrixSingularValue_last_pos_iff_rank_eq_card
        (NumStability.realRectToCMatrix A)).symm
  · exact ⟨NumStability.Ch14Ext.ch14ext_rectMoorePenrosePseudoinverse A,
      NumStability.Ch14Ext.ch14ext_rectMoorePenrosePseudoinverse_certificate A⟩
  · intro Aplus hMP hrank
    rw [← hbridge]
    have hrecip :=
      NumStability.higham20_lemma20_11_pseudoinverse_op2_eq_recip_rankSingular
        A Aplus (Fin.last k) hMP (by simpa using hrank)
    have hspos :
        0 < NumStability.complexMatrixSingularValue
          (NumStability.realRectToCMatrix A) (Fin.last k) :=
      (NumStability.complexMatrixSingularValue_last_pos_iff_rank_eq_card
        (NumStability.realRectToCMatrix A)).2 hrank
    have hsigma :
        NumStability.complexMatrixSingularValue
            (NumStability.realRectToCMatrix A) (Fin.last k) =
          1 / NumStability.complexMatrixOp2
            (NumStability.realRectToCMatrix Aplus) := by
      rw [hrecip]
      field_simp [ne_of_gt hspos]
    rw [NumStability.realMatrixOperatorNorm_eq_complexMatrixOp2_realRectToCMatrix]
    exact hsigma

end NumStability.HDP.Contract
