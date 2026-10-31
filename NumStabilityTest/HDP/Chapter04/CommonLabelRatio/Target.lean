import ComputationalMathematics.HDP.Probability.FiniteGaussianLikelihood

/-! Ordinary closed ratio range and weak-mode target. No posterior claim. -/

set_option autoImplicit false

open NumStability.HDP.Probability
open scoped BigOperators NNReal

universe u
namespace CommonLabelRatioPreparation

noncomputable def commonLabelRatio {ι : Type*} [Fintype ι]
    (r : ι → ℝ) (v : ι → ℝ≥0) (x : ι → ℝ) : ℝ :=
  vectorGaussianLikelihood r v x /
    (vectorGaussianLikelihood (fun j ↦ -(r j)) v x + vectorGaussianLikelihood r v x)

noncomputable def commonLabelWeakMode {ι : Type*} [Fintype ι]
    (r : ι → ℝ) (v : ι → ℝ≥0) (x : ι → ℝ) : Bool :=
  if 0 ≤ weightedGaussianScore r v x then true else false

def CommonLabelRatioRangeAndWeakMode {ι : Type*} [Fintype ι]
    (r : ι → ℝ) (v : ι → ℝ≥0) : Prop :=
  (∀ j, v j ≠ 0) → ∀ x,
    0 < commonLabelRatio r v x ∧ commonLabelRatio r v x < 1 ∧
      (if commonLabelWeakMode r v x then
        1 - commonLabelRatio r v x ≤ commonLabelRatio r v x
      else commonLabelRatio r v x ≤ 1 - commonLabelRatio r v x)

/-- Universally closed ordinary target, including the empty finite index. -/
def CommonLabelRatioRangeAndWeakModeClosedTarget : Prop :=
  ∀ {ι : Type u} [Fintype ι] (r : ι → ℝ) (v : ι → ℝ≥0),
    CommonLabelRatioRangeAndWeakMode r v

end CommonLabelRatioPreparation
