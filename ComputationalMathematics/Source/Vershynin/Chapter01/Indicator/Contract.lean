import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Stable Chapter 1 contract for the indicator-function definition. -/

noncomputable section

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.Preliminaries

/-- The source's indicator `1_E` is one on `E` and zero off `E`. -/
theorem hdp_01_hdef_hindicator
    {Ω : Type*} [MeasurableSpace Ω] (E : Set Ω) (ω : Ω) :
    (ω ∈ E → indicatorFunction E ω = 1) ∧
      (ω ∉ E → indicatorFunction E ω = 0) := by
  constructor <;> intro hω <;> simp [indicatorFunction, hω]

end NumStability.HDP.Contract
