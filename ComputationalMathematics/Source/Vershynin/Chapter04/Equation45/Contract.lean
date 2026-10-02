import ComputationalMathematics.Analysis.Eigenvalues.OrderedSpectrum
import ComputationalMathematics.Analysis.SingularValues.CourantFischer

/-!
# Vershynin Chapter 4, Equation (4.5)

Source contract for the optimal two-sided Euclidean expansion bounds supplied
by the extreme singular values.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.5): for a real matrix with nonempty domain, the
smallest singular value is the largest possible lower expansion constant and
the largest singular value is the smallest possible upper expansion constant
in the two-sided inequality valid for every vector. -/
theorem hdp_04_equation_4_5 {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) :
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
    (∀ x : EuclideanSpace ℝ (Fin (n + 1)), ∀ i : Fin m,
      Matrix.toEuclideanLin A x i = ∑ j : Fin (n + 1), A i j * x j) ∧
    (∀ i j : Fin (n + 1), i ≤ j →
      NumStability.rectCourantFischerSingularValue A j ≤
        NumStability.rectCourantFischerSingularValue A i) ∧
      (∀ i : Fin (n + 1),
        NumStability.rectCourantFischerSingularValue A (Fin.last n) ≤
            NumStability.rectCourantFischerSingularValue A i ∧
          NumStability.rectCourantFischerSingularValue A i ≤
            NumStability.rectCourantFischerSingularValue A (0 : Fin (n + 1))) ∧
      NumStability.AreOptimalExtremeSingularValueBounds A
        (NumStability.rectCourantFischerSingularValue A (Fin.last n))
        (NumStability.rectCourantFischerSingularValue A (0 : Fin (n + 1))) := by
  refine ⟨NumStability.spectrum_eq_range_hermitianOrderedEigenvalue
      (NumStability.rectCourantFischerRightGram_isHermitian A),
    fun _ hμ ↦ NumStability.card_hermitianOrderedEigenvalue_eq
      (NumStability.rectCourantFischerRightGram_isHermitian A) hμ,
    ?_,
    fun i j hij ↦
      NumStability.rectCourantFischerSingularValue_antitone A hij,
    fun i ↦ ⟨?_, ?_⟩,
    NumStability.rectCourantFischer_extremeSingularValues_areOptimalBounds A⟩
  · intro x i
    simp [Matrix.toLpLin_apply, Matrix.mulVec, dotProduct]
  · exact NumStability.rectCourantFischerSingularValue_antitone A (Fin.le_last i)
  · exact NumStability.rectCourantFischerSingularValue_antitone A (Fin.zero_le i)

end NumStability.HDP.Contract
