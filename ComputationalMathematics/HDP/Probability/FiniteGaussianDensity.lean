import ComputationalMathematics.HDP.Probability.FiniteGaussianLikelihood
import ComputationalMathematics.MeasureTheory.Constructions.Pi

/-!
# Finite product Gaussian densities

For nonzero coordinate variances, the product Gaussian measure has the
coordinate likelihood product as its density against the finite product
of Lebesgue measures. Means may have either sign and the index may be empty.
-/

set_option autoImplicit false
open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal ProbabilityTheory
universe u
namespace NumStability.HDP.Probability

/-- A finite product of nondegenerate real Gaussian measures has the product
coordinate density against the product of real volume measures. -/
theorem pi_gaussianReal_eq_withDensity {ι : Type u} [Fintype ι]
    (m : ι → ℝ) (v : ι → ℝ≥0) (hv : ∀ j, v j ≠ 0) :
    Measure.pi (fun j ↦ gaussianReal (m j) (v j)) =
      (Measure.pi (fun _ : ι ↦ (volume : Measure ℝ))).withDensity
        (fun x ↦ ENNReal.ofReal (vectorGaussianLikelihood m v x)) := by
  have hscalar :
      (fun j : ι ↦ gaussianReal (m j) (v j)) =
        (fun j : ι ↦ (volume : Measure ℝ).withDensity
          (fun y ↦ ENNReal.ofReal (gaussianPDFReal (m j) (v j) y))) := by
    funext j
    rw [gaussianReal_of_var_ne_zero (m j) (hv j), gaussianPDF_def]
  rw [hscalar]
  simpa only [vectorGaussianLikelihood] using
    (Measure.pi_withDensity_ofReal
      (fun _ : ι ↦ (volume : Measure ℝ))
      (fun j : ι ↦ gaussianPDFReal (m j) (v j))
      (fun j ↦ integrable_gaussianPDFReal (m j) (v j))
      (fun j y ↦ gaussianPDFReal_nonneg (m j) (v j) y))

end NumStability.HDP.Probability
