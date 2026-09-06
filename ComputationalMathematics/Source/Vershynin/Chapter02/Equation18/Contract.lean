import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Stable Chapter 2 forwarding declaration for the Gaussian sum law. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators
open scoped NNReal

namespace NumStability.HDP.Contract

theorem hdp_02_heq_h2_d18 {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {σ : ι → ℝ≥0} (a : ι → ℝ)
    (hLaw : ∀ i, HasLaw (X i) (gaussianReal 0 (σ i)) μ)
    (hIndep : iIndepFun X μ) :
    HasLaw (fun ω => ∑ i, a i * X i ω)
      (gaussianReal 0 (∑ i, Real.toNNReal ((a i) ^ 2) * σ i)) μ :=
  NumStability.HDP.Scalar.SubGaussian.independentGaussianWeightedSumLaw a hLaw hIndep

end NumStability.HDP.Contract
