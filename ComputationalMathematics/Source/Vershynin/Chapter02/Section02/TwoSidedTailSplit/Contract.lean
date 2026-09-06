import ComputationalMathematics.HDP.Scalar.IndependentSums.TwoSidedTail

/-! Stable Chapter 2 forwarding declaration for the exact two-sided split. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

theorem hdp_02_hbody_h2_d2_htwo_hsided_hsplit
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {S : Ω → ℝ} (hS : Measurable S) {t : ℝ} (ht : 0 < t) :
    μ.real {ω | |S ω| ≥ t} =
      μ.real {ω | S ω ≥ t} + μ.real {ω | -S ω ≥ t} :=
  NumStability.HDP.Scalar.IndependentSums.TwoSidedTail.measureReal_abs_ge_eq_add
    hS ht

end NumStability.HDP.Contract
