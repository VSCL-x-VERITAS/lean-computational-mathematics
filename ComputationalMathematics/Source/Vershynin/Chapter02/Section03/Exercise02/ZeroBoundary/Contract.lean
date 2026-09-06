import ComputationalMathematics.HDP.Scalar.IndependentSums.LowerChernoffBoundary

/-! Boundary companion for the Chapter 2 contract of Exercise 2.3.2. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Contract

/-- The well-defined `t = 0` boundary companion to Exercise 2.3.2.

This is deliberately separate from the positive-threshold source wrapper: the
first-edition display states only `t < μ`, but its real quotient and real power
have no stated semantics for negative `t`.
-/
theorem hdp_02_hex_h2_d3_d2_zero
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i)) :
    μ.real {ω | ∑ i, (if B i ω then (1 : ℝ) else 0) ≤ 0} ≤
      Real.exp (-(∑ i, (p i : ℝ))) :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.poissonBinomial_zeroThresholdBound
    hp hB hLaw hMeas

end NumStability.HDP.Contract
