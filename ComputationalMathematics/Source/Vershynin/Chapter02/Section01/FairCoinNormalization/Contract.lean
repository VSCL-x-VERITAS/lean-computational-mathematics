import ComputationalMathematics.Source.Vershynin.Chapter02.Section01.FairCoinNormalization.Signature
import ComputationalMathematics.HDP.Scalar.IndependentSums.FairCoinNormalization

/-! Source-facing contract for the normalization identity inside (2.2). -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- Section 2.1, printed page 13: with
`Z_N = (S_N - N/2) / sqrt (N/4)`, the events `S_N ≥ 3N/4` and
`Z_N ≥ sqrt (N/4)` coincide. -/
theorem hdp_02_hbody_h2_d1_hzn_hidentity
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool}
    (hN : 0 < Fintype.card ι)
    (_hB : ∀ i, Measurable (B i))
    (_hIndep : iIndepFun B μ)
    (_hLaw : ∀ i, Measure.map (B i) μ = fairBernoulliPMF.toMeasure) :
    {ω | ∑ i, bernoulliIndicator (B i ω) ≥
        (3 / 4 : ℝ) * (Fintype.card ι : ℝ)} =
      {ω | (∑ i, bernoulliIndicator (B i ω) -
          (Fintype.card ι : ℝ) / 2) /
            Real.sqrt ((Fintype.card ι : ℝ) / 4) ≥
          Real.sqrt ((Fintype.card ι : ℝ) / 4)} :=
  NumStability.HDP.Scalar.IndependentSums.FairCoinNormalization.fairBernoulliSum_standardizedThreeQuartersEvent
    hN

/-- The implementation inhabits the frozen Section 2.1 normalization signature. -/
theorem hdp_02_hbody_h2_d1_hzn_hidentity__contract :
    hdp_02_hbody_h2_d1_hzn_hidentity__contract_type := by
  intro ι Ω _ _ μ _ B hN hB hIndep hLaw
  exact hdp_02_hbody_h2_d1_hzn_hidentity hN hB hIndep hLaw

end NumStability.HDP.Contract
