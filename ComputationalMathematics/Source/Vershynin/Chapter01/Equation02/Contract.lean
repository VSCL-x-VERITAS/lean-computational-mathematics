import ComputationalMathematics.HDP.Scalar.Preliminaries

/-!
Stable source-facing contract for Equation (1.2), kept separate from the
standard-deviation identity so each source row has an independently auditable
declaration.
-/

namespace NumStability.HDP.Contract

open MeasureTheory
open NumStability.HDP.Scalar.Preliminaries

/-- Equation (1.2): covariance is the expectation of the product of the
centered representatives and hence their representative-level `L²` inner
product. -/
theorem hdp_01_heq_h1_d2_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X Y : Ω → ℝ)
    (_hX : MemLp X 2 μ) (_hY : MemLp Y 2 μ) :
    covariance μ X Y =
        expectation μ (fun ω =>
          (X ω - expectation μ X) * (Y ω - expectation μ Y)) ∧
      expectation μ (fun ω =>
          (X ω - expectation μ X) * (Y ω - expectation μ Y)) =
        l2InnerProduct μ
          (fun ω => X ω - expectation μ X)
          (fun ω => Y ω - expectation μ Y) := by
  constructor <;> rfl

end NumStability.HDP.Contract
