import ComputationalMathematics.HDP.Probability.FiniteGaussianLikelihood
import Mathlib.MeasureTheory.Constructions.Pi
import Mathlib.Probability.Kernel.Posterior
import Mathlib.Probability.ProbabilityMassFunction.Constructions

/-! Ordinary shared-label posterior target. No source claim or proof acceptance. -/
set_option autoImplicit false
open MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal ProbabilityTheory
universe u
namespace CommonLabelPosteriorPreparation

noncomputable def CommonLabelPosteriorRatio {ι : Type*} [Fintype ι]
    (r : ι → ℝ) (v : ι → ℝ≥0) : Prop :=
  (∀ j, v j ≠ 0) →
    let μminus := Measure.pi (fun j ↦ gaussianReal (-(r j)) (v j))
    let μplus := Measure.pi (fun j ↦ gaussianReal (r j) (v j))
    let K := Kernel.boolKernel μminus μplus
    let π := (PMF.bernoulli (1 / 2)
      (half_le_self (zero_le_one : (0 : ℝ≥0) ≤ 1))).toMeasure
    let M := K ∘ₘ π
    M ≪ Measure.pi (fun _ : ι ↦ (volume : Measure ℝ)) ∧
      ∀ᵐ x ∂M, (posterior K π) x ({true} : Set Bool) =
        ENNReal.ofReal (NumStability.HDP.Probability.vectorGaussianLikelihoodRatio r v x)

/-- Predictive-mixture absolute continuity and its almost-everywhere true posterior ratio. -/
def CommonLabelPosteriorRatioClosedTarget : Prop :=
  ∀ {ι : Type u} [Fintype ι] (r : ι → ℝ) (v : ι → ℝ≥0),
    CommonLabelPosteriorRatio r v

end CommonLabelPosteriorPreparation
