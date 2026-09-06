import ComputationalMathematics.HDP.Scalar.Preliminaries

/-!
# Contract: HDP Chapter 1 distribution, CDF, and upper tail

Source-facing wrapper for the distribution function and upper-tail interface
used throughout Vershynin, *High-Dimensional Probability* (first edition,
2018), Chapter 1.  The mathematics lives in
`NumStability.HDP.Scalar.Preliminaries`; this module only exposes the stable
source-facing name.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Chapter 1's distribution, CDF, and upper-tail interface. -/
noncomputable def hdp_01_hdef_hcdf_htail
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) :
    NumStability.HDP.Scalar.Preliminaries.CDFTailModelData μ X :=
  NumStability.HDP.Scalar.Preliminaries.cdfTailModel μ X

/-- The book's cumulative-distribution formula `F_X(t) = P{X ≤ t}` at every
real threshold. -/
theorem hdp_01_hdef_hcdf_spec
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : AEMeasurable X μ) :
    ∀ t : ℝ, NumStability.HDP.Scalar.Preliminaries.cdf μ X t =
      μ (X ⁻¹' Set.Iic t) :=
  NumStability.HDP.Scalar.Preliminaries.cdf_eq_measure_preimage hX

end NumStability.HDP.Contract
