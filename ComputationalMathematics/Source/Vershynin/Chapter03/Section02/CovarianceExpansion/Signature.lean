import ComputationalMathematics.HDP.Vector.Covariance

/-! Frozen contract signature for the covariance expansion in Section 3.2. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_2_covariance_expansion__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Fin n → Ω → ℝ),
    (∀ i, MemLp (X i) 2 μ) →
      NumStability.HDP.Vector.Covariance.covarianceMatrix μ X =
        (fun i j =>
          (∫ ω, X i ω * X j ω ∂μ) -
            (∫ ω, X i ω ∂μ) * (∫ ω, X j ω ∂μ))

end NumStability.HDP.Contract
