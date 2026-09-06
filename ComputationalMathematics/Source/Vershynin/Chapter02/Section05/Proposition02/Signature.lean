import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Frozen contract signature for Proposition 2.5.2

This file is intentionally proof-free.  The implementation is checked in the
semantic module and the contract wrapper is checked against this type.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

def hdp_02_hprop_h2_d5_d2__contract_type : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    (∀ {Ω : Type*} [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
      Measurable X →
        ∀ i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
          i ≠ .linearMGF → j ≠ .linearMGF → ∀ {Ki : ℝ}, 0 < Ki →
            NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i Ki →
              ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X j Kj) ∧
    (∀ {Ω : Type*} [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
      Measurable X → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0 →
        ∀ i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
          ∀ {Ki : ℝ}, 0 < Ki →
            NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i Ki →
              ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X j Kj)

end NumStability.HDP.Contract
