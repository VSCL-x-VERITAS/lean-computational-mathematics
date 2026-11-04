import ComputationalMathematics.HDP.Probability.FiniteGaussianLikelihood

/-! Ordinary weak-mode measurability target; every variance is permitted. -/
set_option autoImplicit false
open NumStability.HDP.Probability
open scoped NNReal
universe u
namespace CommonLabelDecoderPreparation

def CommonLabelDecoderMeasurable {ι : Type*} [Fintype ι]
    (r : ι → ℝ) (v : ι → ℝ≥0) : Prop :=
  Measurable (weightedGaussianWeakMode r v)

def CommonLabelDecoderMeasurableClosedTarget : Prop :=
  ∀ {ι : Type u} [Fintype ι] (r : ι → ℝ) (v : ι → ℝ≥0),
    CommonLabelDecoderMeasurable r v

end CommonLabelDecoderPreparation
