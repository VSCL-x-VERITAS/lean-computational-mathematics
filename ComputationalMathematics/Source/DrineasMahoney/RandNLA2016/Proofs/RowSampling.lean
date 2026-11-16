import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.RowSampling
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Equation04.RowSamplingProbability.Normalization
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Equation06.LeverageProbability.Normalization

/-! # Normalized row-norm and leverage distributions -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

open scoped BigOperators

theorem rowNormDistribution : Targets.rowNormDistribution := by
  intro m n A hA
  refine ⟨rowSqNormProb_nonneg A hA, rowSqNormProb_sum_eq_one A hA.ne', ?_⟩
  intro i
  rfl

theorem leverageDistribution : Targets.leverageDistribution := by
  intro m n U hn hU
  have hden := rowSqNormProbDen_pos_of_orthonormal_columns U hU hn
  refine ⟨rowSqNormProb_nonneg U hden,
    rowSqNormProb_sum_eq_one U hden.ne', ?_, ?_⟩
  · intro i
    exact leverageScoreProb_eq_rowNormSq_div_nat U hU i
  · intro i
    simpa only [leverageScore, rowNormSq, pow_two] using
      leverageScoreProb_eq_rowNormSq_div_nat U hU i

end NumStability.Source.DrineasMahoney.RandNLA2016
