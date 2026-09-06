import ComputationalMathematics.HDP.Scalar.SubGaussian
/-!
# Contract signature: HDP Remark 2.5.3

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
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (A : ℝ) (hA : 1 < A),
    ((∃ K : ℝ, 0 < K ∧
        NumStability.HDP.Scalar.SubGaussian.SubGaussianTailBoundWithThreshold μ X K 2) ↔
      ∃ K : ℝ, 0 < K ∧
        NumStability.HDP.Scalar.SubGaussian.SubGaussianTailBoundWithThreshold μ X K A) ∧
    ((∃ K : ℝ, 0 < K ∧
        NumStability.HDP.Scalar.SubGaussian.SubGaussianSquarePointWithThreshold μ X K 2) ↔
      ∃ K : ℝ, 0 < K ∧
        NumStability.HDP.Scalar.SubGaussian.SubGaussianSquarePointWithThreshold μ X K A)

end NumStability.HDP.Contract
