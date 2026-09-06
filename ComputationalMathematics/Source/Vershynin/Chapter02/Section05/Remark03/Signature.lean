import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Frozen contract signature for Remark 2.5.3

Frozen `Prop`-valued signature for Vershynin, *High-Dimensional Probability*
(first edition, 2018), Remark 2.5.3, printed page 26: the constant `2`
appearing in the sub-gaussian properties of Proposition 2.5.2 may be replaced
by any absolute constant larger than `1`.

The signature exists so that the shape of the source-facing statement is
pinned independently of its proof, and so a later change to the proof cannot
silently change the contract.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

def hdp_02_hrem_h2_d5_d3__contract_type : Prop :=
  ∀ (A : ℝ), 1 < A →
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X →
          ∀ i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
            i ≠ .linearMGF → j ≠ .linearMGF → ∀ {Ki : ℝ}, 0 < Ki →
              NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyWithThreshold
                  μ X A i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyWithThreshold
                    μ X A j Kj) ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0 →
          ∀ i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
            ∀ {Ki : ℝ}, 0 < Ki →
              NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyWithThreshold
                  μ X A i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyWithThreshold
                    μ X A j Kj)

end NumStability.HDP.Contract
