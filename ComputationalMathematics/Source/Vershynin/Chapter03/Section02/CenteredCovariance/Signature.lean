import ComputationalMathematics.HDP.Vector.Covariance

/-! Frozen contract signature for the centered covariance identity in Section 3.2. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_2_centered_covariance__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Fin n → Ω → ℝ),
    (∀ i, MemLp (X i) 2 μ) →
      NumStability.HDP.Vector.Covariance.meanVector μ X = 0 →
        NumStability.HDP.Vector.Covariance.covarianceMatrix μ X =
          NumStability.HDP.Vector.Covariance.secondMomentMatrix μ X

end NumStability.HDP.Contract
