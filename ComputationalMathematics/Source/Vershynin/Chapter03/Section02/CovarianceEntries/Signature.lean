import ComputationalMathematics.HDP.Vector.Covariance

/-! Frozen contract signature for the covariance-entry formula in Section 3.2. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_2_covariance_entries__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Fin n → Ω → ℝ),
    (∀ i, MemLp (X i) 2 μ) →
      ∀ i j,
        NumStability.HDP.Vector.Covariance.covarianceMatrix μ X i j =
          ∫ ω, (X i ω - ∫ ω, X i ω ∂μ) *
            (X j ω - ∫ ω, X j ω ∂μ) ∂μ

end NumStability.HDP.Contract
