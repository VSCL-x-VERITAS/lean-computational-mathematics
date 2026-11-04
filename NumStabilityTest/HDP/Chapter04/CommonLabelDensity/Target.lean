import ComputationalMathematics.HDP.Probability.FiniteGaussianLikelihood
import ComputationalMathematics.MeasureTheory.Constructions.Pi

/-! Ordinary finite coordinate-product Gaussian density target. -/

set_option autoImplicit false

open MeasureTheory ProbabilityTheory NumStability.HDP.Probability
open scoped BigOperators ENNReal NNReal ProbabilityTheory

universe u
namespace CommonLabelDensityPreparation

def ProductGaussianDensity {ι : Type*} [Fintype ι]
    (m : ι → ℝ) (v : ι → ℝ≥0) : Prop :=
  (∀ j, v j ≠ 0) →
    Measure.pi (fun j ↦ gaussianReal (m j) (v j)) =
      (Measure.pi (fun _ : ι ↦ (volume : Measure ℝ))).withDensity
        (fun x ↦ ENNReal.ofReal (vectorGaussianLikelihood m v x))

/-- Universally closed ordinary density target, including an empty finite index. -/
def ProductGaussianDensityClosedTarget : Prop :=
  ∀ {ι : Type u} [Fintype ι] (m : ι → ℝ) (v : ι → ℝ≥0),
    ProductGaussianDensity m v

end CommonLabelDensityPreparation
