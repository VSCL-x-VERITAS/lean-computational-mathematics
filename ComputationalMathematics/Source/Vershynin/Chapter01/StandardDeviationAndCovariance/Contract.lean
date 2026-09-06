import ComputationalMathematics.HDP.Scalar.Preliminaries

/-! Stable Chapter 1 definition family for standard deviation and covariance. -/

noncomputable section

namespace NumStability.HDP.Contract

open MeasureTheory
open NumStability.HDP.Scalar.Preliminaries

noncomputable def hdp_01_hdef_hstdev_hcovariance
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X Y : Ω → ℝ) :
    (l2Norm μ (fun ω => X ω - expectation μ X) = standardDeviation μ X) ∧
      (covariance μ X Y =
        l2InnerProduct μ
          (fun ω => X ω - expectation μ X)
          (fun ω => Y ω - expectation μ Y)) :=
  stdevCovarianceIdentities μ X Y

/-- The standard-deviation identity following Equation (1.1): for a real
square-integrable random variable, the `L²` norm of its centered representative
is the square root of its variance, which is the standard deviation. -/
theorem hdp_01_hclaim_hstdev_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (_hX : MemLp X 2 μ) :
    l2Norm μ (fun ω => X ω - expectation μ X) =
        Real.sqrt (variance μ X) ∧
      Real.sqrt (variance μ X) = standardDeviation μ X := by
  constructor <;> rfl

end NumStability.HDP.Contract
