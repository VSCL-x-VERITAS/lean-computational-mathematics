import ComputationalMathematics.HDP.Scalar.Preliminaries

/-! Source-facing contracts for Equation (1.3), including its printed
zero-exponent obstruction and the corrected positive-exponent theorem. -/

namespace NumStability.HDP.Contract

open MeasureTheory
open NumStability.HDP.Scalar.Preliminaries

/-! Compatibility aliases for the original corrected Equation (1.3) surface. -/
theorem hdp_01_hcor_hlp_hmonotone
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {p q : ENNReal}
    (hpq : p ≤ q) (hX : AEStronglyMeasurable X μ) :
    eLpNorm X p μ ≤ eLpNorm X q μ :=
  lpNormMonoProbability hpq hX

theorem hdp_01_hcor_hlp_hmonotone_zero :
    ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ},
      eLpNorm X 0 μ = 0 :=
  fun {_} {_} {_} => lpNormExponentZero

/-- The printed finite-`p` formula uses the exponent `1 / p`; at the stated
endpoint `p = 0`, no real reciprocal can satisfy its defining equation. -/
theorem hdp_01_heq_h1_d3_source_obstruction :
    ¬ ∃ r : ℝ, (0 : ℝ) * r = 1 := by
  norm_num

/-- Mathlib totalizes the separate `eLpNorm` zero-exponent branch as zero;
this records the available model without identifying it with the book's
undefined `1 / 0` formula. -/
theorem hdp_01_heq_h1_d3_zero_model
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} :
    eLpNorm X 0 μ = 0 :=
  lpNormExponentZero

/-- Corrected form of Equation (1.3): on a probability space, the extended
`L^p` norm is monotone for nonzero exponents, including the `q = ∞` endpoint. -/
theorem hdp_01_heq_h1_d3_corrected
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {p q : ENNReal}
    (_hp : p ≠ 0) (hpq : p ≤ q)
    (hX : AEStronglyMeasurable X μ) :
    eLpNorm X p μ ≤ eLpNorm X q μ :=
  lpNormMonoProbability hpq hX

end NumStability.HDP.Contract
