import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.MeasureTheory.Constructions.Pi

/-!
# Translation of finite product Gaussian measures

Coordinate addition translates a centered product Gaussian law to the law
with the prescribed means and unchanged variances. Zero coordinate variances
and an empty finite index are allowed.
-/

set_option autoImplicit false
open MeasureTheory ProbabilityTheory
open scoped NNReal
universe u
namespace NumStability.HDP.Probability

/-- Translate a centered product Gaussian, including zero-variance coordinates. -/
theorem pi_gaussianReal_zero_map_const_add {ι : Type u} [Fintype ι]
    (m : ι → ℝ) (v : ι → ℝ≥0) :
    (Measure.pi (fun j ↦ gaussianReal 0 (v j))).map
        (fun x : ι → ℝ ↦ fun j ↦ m j + x j) =
      Measure.pi (fun j ↦ gaussianReal (m j) (v j)) := by
  have hf (j : ι) : Measurable (fun x : ℝ ↦ m j + x) :=
    measurable_const.add measurable_id
  letI (j : ι) : IsProbabilityMeasure
      ((gaussianReal 0 (v j)).map (fun x : ℝ ↦ m j + x)) :=
    Measure.isProbabilityMeasure_map (hf j).aemeasurable
  rw [Measure.pi_map_pi (fun j ↦ (hf j).aemeasurable)]
  simp only [gaussianReal_map_const_add, zero_add]

end NumStability.HDP.Probability
