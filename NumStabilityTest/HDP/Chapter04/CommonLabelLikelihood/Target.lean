import Mathlib.Probability.Distributions.Gaussian.Real

/-! Ordinary proof-free likelihood target. Original three declaration bodies are
transported unchanged from the phase113 proposal; no proof acceptance is claimed. -/

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal ProbabilityTheory

universe u

namespace CommonLabelGaussianPreparation

noncomputable def vectorGaussianLikelihood {ι : Type*} [Fintype ι]
    (m : ι → ℝ) (v : ι → ℝ≥0) (x : ι → ℝ) : ℝ :=
  ∏ j, gaussianPDFReal (m j) (v j) (x j)

noncomputable def weightedGaussianScore {ι : Type*} [Fintype ι]
    (r : ι → ℝ) (v : ι → ℝ≥0) (x : ι → ℝ) : ℝ :=
  ∑ j, r j * x j / (v j : ℝ)

def ProductLikelihoodComparison {ι : Type*} [Fintype ι]
    (r : ι → ℝ) (v : ι → ℝ≥0) : Prop :=
  (∀ j, v j ≠ 0) → ∀ x,
    vectorGaussianLikelihood (fun j ↦ -(r j)) v x ≤ vectorGaussianLikelihood r v x ↔
      0 ≤ weightedGaussianScore r v x

/-- Closed ordinary target, including empty finite index types and weak ties. -/
def ProductLikelihoodComparisonClosedTarget : Prop :=
  ∀ (ι : Type u) [Fintype ι] (r : ι → ℝ) (v : ι → ℝ≥0),
    ProductLikelihoodComparison r v

end CommonLabelGaussianPreparation
