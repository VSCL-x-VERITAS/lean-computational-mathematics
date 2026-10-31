import ComputationalMathematics.Analysis.OperatorNorms.RealComplexification
import ComputationalMathematics.Analysis.Eigenvalues.OrderedSpectrum
import ComputationalMathematics.Analysis.SingularValues.ExtremeValues
import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Pseudoinverse.CompactSVD
import ComputationalMathematics.Analysis.SingularValues.PseudoinverseNorm
import ComputationalMathematics.Analysis.SingularValues.FullColumnRank
import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Pseudoinverse.PenroseEquations

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

/-- Vershynin, Chapter 4, p. 77: the shape obstruction, full-column-rank
equivalence, and reciprocal pseudoinverse norm, with full column rank expressed
as a trivial real kernel and the pseudoinverse specified by all four Penrose
equations. The original spectral/rank contract remains available above. -/
theorem hdp_04_smallest_singular_value_kernel_and_penrose_equations
    {m k : ℕ} (A : Matrix (Fin m) (Fin (k + 1)) ℝ) :
    (rectCourantFischerSingularValue A (Fin.last k) ≠ 0 → k + 1 ≤ m) ∧
    (k + 1 ≤ m →
      ((∀ x : Fin (k + 1) → ℝ, rectMatMulVec A x = 0 → x = 0) ↔
        0 < rectCourantFischerSingularValue A (Fin.last k))) ∧
    (∃ B : Matrix (Fin (k + 1)) (Fin m) ℝ,
      (A * B) * A = A ∧ (B * A) * B = B ∧
        (A * B).transpose = A * B ∧ (B * A).transpose = B * A) ∧
    (∀ B : Matrix (Fin (k + 1)) (Fin m) ℝ,
      ((A * B) * A = A ∧ (B * A) * B = B ∧
        (A * B).transpose = A * B ∧ (B * A).transpose = B * A) →
      (∀ x : Fin (k + 1) → ℝ, rectMatMulVec A x = 0 → x = 0) →
      rectCourantFischerSingularValue A (Fin.last k) =
        1 / realMatrixOperatorNorm B) := by
  obtain ⟨_hspectrum, _hmultiplicity, _horder, _hleast, hshape, hrank, hex, hrecip⟩ :=
    hdp_04_smallest_singular_value_full_rank_and_pseudoinverse A
  refine ⟨hshape,
    fun _ ↦ trivial_rectMatMulVec_kernel_iff_last_singularValue_pos A, ?_, ?_⟩
  · obtain ⟨B, hB⟩ := hex
    exact ⟨B, (rectMoorePenrosePseudoinverse_iff_penrose_equations A B).mp hB⟩
  · intro B hB hker
    have hspos := (trivial_rectMatMulVec_kernel_iff_last_singularValue_pos A).mp hker
    exact hrecip B
      ((rectMoorePenrosePseudoinverse_iff_penrose_equations A B).mpr hB)
      ((hrank (hshape (ne_of_gt hspos))).mpr hspos)

end NumStability.HDP.Contract
