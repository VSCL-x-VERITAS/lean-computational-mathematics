import ComputationalMathematics.Source.Vershynin.Chapter02.Equation01.Signature
import ComputationalMathematics.HDP.Scalar.IndependentSums.FairCoinChebyshev
/-! Source-facing contract for Equation (2.1). -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- Equation (2.1), printed page 12: Chebyshev's `4/N` bound for at least
`3N/4` heads. -/
theorem hdp_02_heq_h2_d1
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool}
    (hN : 0 < Fintype.card ι)
    (hB : ∀ i, Measurable (B i))
    (hIndep : iIndepFun B μ)
    (hLaw : ∀ i, Measure.map (B i) μ = fairBernoulliPMF.toMeasure) :
    μ.real {ω | ∑ i, bernoulliIndicator (B i ω) ≥
        (3 / 4 : ℝ) * (Fintype.card ι : ℝ)} ≤
      μ.real {ω | |∑ i, bernoulliIndicator (B i ω) -
        (Fintype.card ι : ℝ) / 2| ≥
          (Fintype.card ι : ℝ) / 4} ∧
    μ.real {ω | |∑ i, bernoulliIndicator (B i ω) -
        (Fintype.card ι : ℝ) / 2| ≥
          (Fintype.card ι : ℝ) / 4} ≤
      4 / (Fintype.card ι : ℝ) :=
  NumStability.HDP.Scalar.IndependentSums.FairCoinChebyshev.fairBernoulliSum_chebyshev
    hN hB hIndep hLaw

/-- The implementation inhabits the frozen Equation (2.1) signature. -/
theorem hdp_02_heq_h2_d1__contract : hdp_02_heq_h2_d1__contract_type := by
  intro ι Ω _ _ μ _ B hN hB hIndep hLaw
  exact hdp_02_heq_h2_d1 hN hB hIndep hLaw

end NumStability.HDP.Contract
