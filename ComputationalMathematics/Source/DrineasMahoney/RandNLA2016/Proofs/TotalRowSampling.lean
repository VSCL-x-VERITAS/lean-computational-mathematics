import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.TotalRowSampling
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Equation05.GramApproximation.TotalExpectedBound

/-! # Expected Gram error with the zero-input branch -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

theorem totalExpectedGramError : Targets.totalExpectedGramError := by
  intro m n s A hs
  exact totalRowSqNormTraceProbability_expectationReal_totalRowSampleGram_frob_error_le
    A (by exact_mod_cast hs)

end NumStability.Source.DrineasMahoney.RandNLA2016
