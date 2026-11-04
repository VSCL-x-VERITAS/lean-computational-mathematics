import ComputationalMathematics.HDP.Vector.Bernoulli
import ComputationalMathematics.HDP.Vector.Gaussian

/-!
# Symmetric two-component Gaussian mixtures

The canonical equal mixture of `N(μ, I)` and `N(-μ, I)`, represented as the
law of `θ μ + g` for an independent Rademacher sign and standard Gaussian
vector.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Vector.GaussianMixture

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- The deterministic map `(θ,g) ↦ θ μ + g`. -/
def mixtureMap {n : ℕ} (μ : Fin n → ℝ) (z : ℝ × (Fin n → ℝ)) : Fin n → ℝ :=
  fun i ↦ z.1 * μ i + z.2 i

/-- The equal two-component spherical Gaussian mixture with means `μ` and
`-μ`: the image of an independent Rademacher sign and standard Gaussian. -/
def gaussianMixtureMeasure {n : ℕ} (μ : Fin n → ℝ) : Measure (Fin n → ℝ) :=
  Measure.map (mixtureMap μ)
    (rademacherPMF.toMeasure.prod (NumStability.standardGaussianVectorMeasure n))

/-- The product law of `m` independent observations from the mixture. -/
def gaussianMixtureSampleMeasure (m : ℕ) {n : ℕ} (μ : Fin n → ℝ) :
    Measure (Fin m → Fin n → ℝ) :=
  Measure.pi fun _ : Fin m ↦ gaussianMixtureMeasure μ

/-- A random vector follows the symmetric Gaussian-mixture model when its law
is the canonical mixture measure. -/
def HasGaussianMixtureLaw {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : Ω → Fin n → ℝ) (μ : Fin n → ℝ) : Prop :=
  HasLaw X (gaussianMixtureMeasure μ) P

/-- A finite random sample follows the model when its joint law is the product
of `m` copies of the mixture measure. -/
def HasGaussianMixtureSampleLaw {Ω : Type*} [MeasurableSpace Ω] {m n : ℕ}
    (P : Measure Ω) (X : Fin m → Ω → Fin n → ℝ) (μ : Fin n → ℝ) : Prop :=
  HasLaw (fun ω i ↦ X i ω) (gaussianMixtureSampleMeasure m μ) P

theorem gaussianMixtureMeasure_eq_map_prod {n : ℕ} (μ : Fin n → ℝ) :
    gaussianMixtureMeasure μ =
      Measure.map (fun z : ℝ × (Fin n → ℝ) ↦ fun i ↦ z.1 * μ i + z.2 i)
        (rademacherPMF.toMeasure.prod
          (NumStability.standardGaussianVectorMeasure n)) := rfl

theorem gaussianMixtureSampleMeasure_eq_pi (m : ℕ) {n : ℕ} (μ : Fin n → ℝ) :
    gaussianMixtureSampleMeasure m μ =
      Measure.pi (fun _ : Fin m ↦ gaussianMixtureMeasure μ) := rfl

end NumStability.HDP.Vector.GaussianMixture
