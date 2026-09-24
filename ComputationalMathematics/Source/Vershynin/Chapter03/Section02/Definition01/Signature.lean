import ComputationalMathematics.HDP.Vector.Isotropy

/-! Frozen contract signature for Definition 3.2.1. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_hdef_h3_d2_d1__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Fin n → Ω → ℝ), (∀ i, MemLp (X i) 2 μ) →
      (NumStability.HDP.Vector.Isotropy.IsIsotropic μ X ↔
        NumStability.HDP.Vector.Covariance.secondMomentMatrix μ X = 1)

end NumStability.HDP.Contract
