import ComputationalMathematics.Source.Vershynin.Chapter02.Equation19.Signature
import ComputationalMathematics.HDP.Scalar.Preliminaries

/-! Stable Chapter 2 contract module for the `L²` centering inequality (2.19). -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

/-- Equation (2.19): subtracting the expectation cannot increase the `L²`
seminorm of a square-integrable real random variable. -/
theorem hdp_02_heq_h2_d19
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : MemLp X 2 μ) :
    eLpNorm (fun ω => X ω - ∫ x, X x ∂μ) 2 μ ≤ eLpNorm X 2 μ :=
  NumStability.HDP.Scalar.Preliminaries.centered_eLpNorm_two_le hX

theorem hdp_02_heq_h2_d19__contract : hdp_02_heq_h2_d19__contract_type := by
  intro Ω instΩ μ instμ X hX
  exact hdp_02_heq_h2_d19 hX

end NumStability.HDP.Contract
