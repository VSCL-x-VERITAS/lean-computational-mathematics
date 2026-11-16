import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.RowNorm.TotalTraceProbability
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Equation05.GramApproximation.SampledGramEndpoints

/-!
# Equation (5) with an explicit zero-input sampling convention

For nonzero inputs this is the original independent norm-squared row sampler
and expected Gram-error bound. For zero inputs the total sampler returns the
explicit zero sketch, so the same error estimate holds with both sides zero.
The fallback is a stated extension; the printed source does not specify it.
-/

namespace NumStability

/-- Total expected Eq5 Gram error, for every finite input matrix and positive
sample count, including zero inputs and empty row or column dimensions. -/
theorem totalRowSqNormTraceProbability_expectationReal_totalRowSampleGram_frob_error_le
    {m n s : ℕ} (A : Fin m → Fin n → ℝ) (hs : 0 < (s : ℝ)) :
    (totalRowSqNormTraceProbability (s := s) A).expectationReal
      (fun outcome =>
        frobNorm (fun j k => totalRowSampleGram A outcome j k - rowGram A j k)) ≤
      rowSqNormProbDen A / Real.sqrt (s : ℝ) := by
  by_cases hden : 0 < rowSqNormProbDen A
  · rw [totalRowSqNormTraceProbability_of_pos A hden,
      FiniteProbability.expectationReal_onSome]
    simpa only [totalRowSampleGram_some, one_div, div_eq_mul_inv, one_mul, mul_comm] using
      rowSqNormTraceProbability_expectationReal_rowSampleGram_frob_error_le A hden hs
  · have hzero : rowSqNormProbDen A = 0 :=
      le_antisymm (le_of_not_gt hden) (frobNormSqRect_nonneg A)
    have hentries : ∀ i j, A i j = 0 := (rowSqNormProbDen_eq_zero_iff A).mp hzero
    have hGram : rowGram A = fun _ _ => 0 := by
      ext j k
      simp [rowGram, hentries]
    have hFrob : frobNorm (fun _ _ : Fin n => (0 : ℝ)) = 0 :=
      (frobNorm_eq_zero_iff _).mpr (fun _ _ => rfl)
    rw [totalRowSqNormTraceProbability_of_zero A hzero,
      FiniteProbability.expectationReal_atNone]
    simp [hGram, hFrob, hzero]

end NumStability
