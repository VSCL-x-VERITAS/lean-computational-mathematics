import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding

/-! Stable Chapter 2 forwarding module for Theorem 2.2.6. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory

namespace NumStability.HDP.Contract

/-- Theorem 2.2.6 without a spurious positive-total-width premise. When all
interval widths vanish, the displayed right-hand side is one and the result is
the universal probability bound. -/
theorem hdp_02_hthm_h2_d2_d6_source
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {m M : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hbound : ∀ i, ∀ᵐ ω ∂μ, X i ω ∈ Set.Icc (m i) (M i))
    (ht : 0 < t) :
    μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} ≤
      Real.exp (-2 * t ^ 2 / (∑ i, ‖M i - m i‖ ^ 2)) := by
  by_cases hv : 0 < ∑ i, ‖M i - m i‖ ^ 2
  · exact
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.boundedIndependentHoeffding
        hX hIndep hbound ht hv
  · have hnonneg : 0 ≤ ∑ i, ‖M i - m i‖ ^ 2 :=
      Finset.sum_nonneg (fun i _ => sq_nonneg ‖M i - m i‖)
    have hzero : ∑ i, ‖M i - m i‖ ^ 2 = 0 :=
      le_antisymm (le_of_not_gt hv) hnonneg
    rw [hzero]
    norm_num
    exact (measureReal_le_one (μ := μ)).trans (by norm_num)

end NumStability.HDP.Contract
