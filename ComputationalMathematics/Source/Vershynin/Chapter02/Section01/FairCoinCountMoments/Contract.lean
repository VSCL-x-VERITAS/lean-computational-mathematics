import ComputationalMathematics.Source.Vershynin.Chapter02.Section01.FairCoinCountMoments.Signature
import ComputationalMathematics.HDP.Scalar.IndependentSums.FairCoinMoments
/-! Source-facing contract for the fair-coin count moments in Section 2.1. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- Section 2.1, printed page 12: if `S_N` is the number of heads in `N`
independent fair coin tosses, then `E S_N = N / 2` and
`Var(S_N) = N / 4`. -/
theorem hdp_02_hbody_h2_d1_hsn_hmoments
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool}
    (_hN : 0 < Fintype.card ι)
    (hB : ∀ i, Measurable (B i))
    (hIndep : iIndepFun B μ)
    (hLaw : ∀ i, Measure.map (B i) μ = fairBernoulliPMF.toMeasure) :
    (∫ ω, ∑ i, bernoulliIndicator (B i ω) ∂μ) =
        (Fintype.card ι : ℝ) / 2 ∧
      Var[fun ω ↦ ∑ i, bernoulliIndicator (B i ω); μ] =
        (Fintype.card ι : ℝ) / 4 :=
  NumStability.HDP.Scalar.IndependentSums.FairCoinMoments.fairBernoulliSum_mean_variance
    hB hIndep hLaw

/-- The implementation inhabits the frozen source-facing signature. -/
theorem hdp_02_hbody_h2_d1_hsn_hmoments__contract :
    hdp_02_hbody_h2_d1_hsn_hmoments__contract_type := by
  intro ι Ω _ _ μ _ B hN hB hIndep hLaw
  exact hdp_02_hbody_h2_d1_hsn_hmoments hN hB hIndep hLaw

end NumStability.HDP.Contract
