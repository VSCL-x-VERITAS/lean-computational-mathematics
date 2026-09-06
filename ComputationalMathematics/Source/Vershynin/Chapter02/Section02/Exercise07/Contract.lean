import ComputationalMathematics.Source.Vershynin.Chapter02.Section02.Theorem06.Contract

/-! Source-facing Chapter 2 contract for Exercise 2.2.7. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory

namespace NumStability.HDP.Contract

/-- Exercise 2.2.7, discharged with the exact constant `2` stated in Theorem
2.2.6. -/
theorem hdp_02_hex_h2_d2_d7_source
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {m M : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hbound : ∀ i, ∀ᵐ ω ∂μ, X i ω ∈ Set.Icc (m i) (M i))
    (ht : 0 < t) :
    μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} ≤
      Real.exp (-2 * t ^ 2 / (∑ i, ‖M i - m i‖ ^ 2)) :=
  hdp_02_hthm_h2_d2_d6_source hX hIndep hbound ht

end NumStability.HDP.Contract
