import ComputationalMathematics.HDP.Scalar.SubExponentialPowerOrlicz

/-!
# Frozen contract signature for Example 2.7.12

This file is intentionally proof-free. It records the finite-space
coincidence with the classical `Lᵖ` construction asserted by the source.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

def hdp_02_hexample_h2_d7_d12__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (p : NNReal) (hp : 1 ≤ p),
    ∀ X : Ω → ℝ, AEStronglyMeasurable X μ →
      (NumStability.HDP.Scalar.SubExponential.orliczMember
          (NumStability.HDP.Scalar.SubExponential.powerOrliczFunction p hp) μ X ↔
        MemLp X (p : ENNReal) μ)

end NumStability.HDP.Contract
