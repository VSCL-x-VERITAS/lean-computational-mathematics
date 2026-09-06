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

end NumStability.HDP.Contract
