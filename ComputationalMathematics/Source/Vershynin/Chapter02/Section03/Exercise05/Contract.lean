import ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff

/-! Stable Chapter 2 forwarding theorem for Exercise 2.3.5. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators
open scoped NNReal

namespace NumStability.HDP.Contract

theorem hdp_02_hex_h2_d3_d5
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i))
    {δ : ℝ} (hδ0 : 0 < δ) (hδ1 : δ ≤ 1)
    (hExp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam * (if B i ω then 1 else 0))) μ)
    (hExpS : ∀ (lam : ℝ),
      Integrable (fun ω => Real.exp (lam * ∑ i, (if B i ω then 1 else 0))) μ) :
    μ.real {ω |
        δ * (∑ i, (p i : ℝ)) ≤
          |(∑ i, (if B i ω then 1 else 0)) - ∑ i, (p i : ℝ)|} ≤
      2 * Real.exp (-(∑ i, (p i : ℝ)) * δ ^ 2 / 4) :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.poissonBinomialTwoSidedQuadraticBound
    hp hB hLaw hMeas hδ0 hδ1 hExp hExpS

end NumStability.HDP.Contract
