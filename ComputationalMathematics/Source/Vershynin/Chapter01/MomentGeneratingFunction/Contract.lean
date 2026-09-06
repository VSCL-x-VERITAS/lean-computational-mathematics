import ComputationalMathematics.HDP.Scalar.Preliminaries

/-!
Cross-split stable API for `HDP-01-DEF-MGF`.

The reusable producer owns the extended nonnegative integral, its finite
domain, and the finite-real interface.  This contract leaf owns the book alias
and the displayed definition.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Stable source-facing extended and finite-real MGF interface. -/
def hdp_01_hdef_hmgf
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) :
    Type :=
  NumStability.HDP.Scalar.Preliminaries.MGFModelData μ X

/-- The book's displayed formula `M_X(t) = E exp(tX)`, represented by the
nonnegative Lebesgue integral so that no unstated finiteness convention is
required. -/
theorem hdp_01_hdef_hmgf_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (_hX : Measurable X) (t : ℝ) :
    NumStability.HDP.Scalar.Preliminaries.mgf μ X t =
      ∫⁻ ω, ENNReal.ofReal (Real.exp (t * X ω)) ∂μ := by
  rfl

end NumStability.HDP.Contract
