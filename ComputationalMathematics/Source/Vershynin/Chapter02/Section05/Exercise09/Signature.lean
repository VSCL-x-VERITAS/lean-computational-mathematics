import ComputationalMathematics.HDP.Scalar.NonSubGaussian

/-!
# Frozen contract signature for Exercise 2.5.9

This proof-free signature uniformly covers the conventional nondegenerate
parameter ranges of all four distribution families named in the exercise:
positive Poisson and exponential rates, positive Pareto shape and scale, and
arbitrary Cauchy location with positive scale. These explicit universal
binders are a strengthening of the source, which leaves its family parameters
implicit.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

def hdp_02_hex_h2_d5_d9__contract_type : Prop :=
  (∀ rate : ℝ≥0, 0 < rate →
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
        (poissonMeasure rate) (fun n : ℕ => (n : ℝ)) = ∞) ∧
  (∀ rate : ℝ, 0 < rate →
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
        (expMeasure rate) id = ∞) ∧
  (∀ shape scale : ℝ≥0, 0 < shape → 0 < scale →
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
        (NumStability.HDP.Scalar.SubGaussian.paretoMeasure shape scale) id = ∞) ∧
  (∀ loc : ℝ, ∀ scale : ℝ≥0, 0 < scale →
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
        (NumStability.HDP.Scalar.SubGaussian.cauchyLocationScaleMeasure loc scale)
        id = ∞)

end NumStability.HDP.Contract
