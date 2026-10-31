import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.MeasureTheory.Constructions.Pi

/-! Ordinary finite Gaussian translation target; no source or mixture-model assertion. -/
set_option autoImplicit false
open MeasureTheory ProbabilityTheory
open scoped NNReal
universe u
namespace FiniteGaussianShiftPreparation

def ShiftedProductGaussianLaw {ι : Type*} [Fintype ι]
    (m : ι → ℝ) (v : ι → ℝ≥0) : Prop :=
  Measure.map (fun x : ι → ℝ ↦ fun j ↦ m j + x j)
    (Measure.pi (fun j ↦ gaussianReal 0 (v j))) =
      Measure.pi (fun j ↦ gaussianReal (m j) (v j))

/-- Coordinate translation of centered product Gaussians, including zero variances. -/
def ShiftedProductGaussianClosedTarget : Prop :=
  ∀ {ι : Type u} [Fintype ι] (m : ι → ℝ) (v : ι → ℝ≥0),
    ShiftedProductGaussianLaw m v

end FiniteGaussianShiftPreparation
