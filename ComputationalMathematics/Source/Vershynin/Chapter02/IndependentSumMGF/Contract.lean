import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding

/-! Stable Chapter 2 forwarding declaration for MGF tensorization. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory

namespace NumStability.HDP.Contract

theorem hdp_02_hlem_hmgf_hindependent_hsum
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} (lam : ℝ) (a : ι → ℝ)
    (hX : iIndepFun X μ)
    (hExp : ∀ i, Integrable (fun ω => Real.exp (lam * (a i * X i ω))) μ) :
    ∫ ω, Real.exp (lam * ∑ i, a i * X i ω) ∂μ =
      ∏ i, ∫ ω, Real.exp (lam * (a i * X i ω)) ∂μ :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.mgfIndependentSum lam a hX hExp

end NumStability.HDP.Contract
