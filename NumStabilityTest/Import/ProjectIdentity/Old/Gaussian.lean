import NumStability.Analysis.Probability.Gaussian.AbsoluteMoment

/-! Project identity migration: old import API regression. -/

#check NumStability.integral_abs_mul_standardGaussianPDF_eq_sqrt

open MeasureTheory ProbabilityTheory

example : (∫ x : ℝ, |x| * gaussianPDFReal 0 1 x) = Real.sqrt (2 / Real.pi) :=
  NumStability.integral_abs_mul_standardGaussianPDF_eq_sqrt
