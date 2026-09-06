import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding

noncomputable section

open MeasureTheory
open ProbabilityTheory

namespace NumStability.HDP.Contract

/-! Stable Chapter 2 alias for Exercise 2.2.10(b). -/
theorem hdp_02_hex_h2_d2_d10b
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {ε : ℝ} (hε : 0 < ε)
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hLaplace : ∀ i,
      Integrable (fun ω => Real.exp (-(1 / ε) * X i ω)) μ ∧
        (∫ ω, Real.exp (-(1 / ε) * X i ω) ∂μ) ≤ ε) :
    μ.real {ω | ∑ i, X i ω ≤ ε * (Fintype.card ι : ℝ)} ≤
      (Real.exp 1 * ε) ^ Fintype.card ι :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.smallBallProbability
    hε hX hIndep hLaplace

end NumStability.HDP.Contract
