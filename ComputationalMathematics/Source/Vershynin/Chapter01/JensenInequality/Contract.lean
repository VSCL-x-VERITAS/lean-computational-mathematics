import ComputationalMathematics.HDP.Scalar.Preliminaries

/-! Stable Chapter 1 forwarding module for Jensen's inequality. -/

namespace NumStability.HDP.Contract

open MeasureTheory
open NumStability.HDP.Scalar.Preliminaries

/-- Original Chapter 1 forwarding alias for Jensen's inequality. -/
theorem hdp_01_hthm_hjensen
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {φ : ℝ → ℝ}
    (hφ : ConvexOn ℝ Set.univ φ)
    (hX : Integrable X μ)
    (hφX : Integrable (fun ω => φ (X ω)) μ) :
    φ (expectation μ X) ≤ expectation μ (fun ω => φ (X ω)) :=
  jensenIntegral hφ hX hφX

/-- Source-facing Jensen inequality for a real integrable random variable and
an integrable convex transform. The two integrability hypotheses make the
book's real-valued expectations mathematically defined. -/
theorem hdp_01_hthm_hjensen_spec
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {φ : ℝ → ℝ}
    (hφ : ConvexOn ℝ Set.univ φ)
    (hX : Integrable X μ)
    (hφX : Integrable (fun ω => φ (X ω)) μ) :
    φ (expectation μ X) ≤ expectation μ (fun ω => φ (X ω)) :=
  jensenIntegral hφ hX hφX

end NumStability.HDP.Contract
