import ComputationalMathematics.HDP.Scalar.Standardization

/-! Frozen contract signature for scalar standardization in Section 3.2.2. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_2_standard_score__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Ω → ℝ), MemLp X 2 μ → 0 < variance X μ →
      NumStability.HDP.Scalar.Standardization.standardScore μ X =
          (fun ω => (X ω - ∫ ω, X ω ∂μ) / Real.sqrt (variance X μ)) ∧
        (∫ ω, NumStability.HDP.Scalar.Standardization.standardScore μ X ω ∂μ) = 0 ∧
        variance (NumStability.HDP.Scalar.Standardization.standardScore μ X) μ = 1

end NumStability.HDP.Contract
