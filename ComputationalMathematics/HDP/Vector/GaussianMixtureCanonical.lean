import ComputationalMathematics.HDP.Vector.GaussianMixture
import Mathlib.MeasureTheory.Constructions.Pi

/-!
# Canonical latent Gaussian-mixture samples

We retain the independent Rademacher labels and standard-Gaussian noises as
the sample space.  The observed point is the measurable map
`(θ,g) ↦ θ μ + g`.  This presentation makes row independence explicit while
having exactly the same point law as `gaussianMixtureMeasure`.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Vector.GaussianMixture

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- Law of one latent sign and one independent standard-Gaussian noise row. -/
def latentNoiseObservationMeasure (n : ℕ) :
    Measure (ℝ × (Fin n → ℝ)) :=
  rademacherPMF.toMeasure.prod (NumStability.standardGaussianVectorMeasure n)

instance latentNoiseObservationMeasure_isProbabilityMeasure (n : ℕ) :
    IsProbabilityMeasure (latentNoiseObservationMeasure n) :=
  ⟨by simp [latentNoiseObservationMeasure]⟩

/-- Product law of `m` independent latent-sign/noise rows. -/
def latentNoiseSampleMeasure (m n : ℕ) :
    Measure (Fin m → ℝ × (Fin n → ℝ)) :=
  Measure.pi fun _ : Fin m ↦ latentNoiseObservationMeasure n

/-- Latent community sign in row `i`. -/
def canonicalLabel {m n : ℕ}
    (ω : Fin m → ℝ × (Fin n → ℝ)) (i : Fin m) : ℝ :=
  (ω i).1

/-- Standard-Gaussian noise vector in row `i`. -/
def canonicalNoise {m n : ℕ}
    (ω : Fin m → ℝ × (Fin n → ℝ)) (i : Fin m) : Fin n → ℝ :=
  (ω i).2

/-- Observed point `θᵢ μ + gᵢ` in row `i`. -/
def canonicalPoint {m n : ℕ} (mean : Fin n → ℝ)
    (ω : Fin m → ℝ × (Fin n → ℝ)) (i : Fin m) : Fin n → ℝ :=
  mixtureMap mean (ω i)

theorem measurable_mixtureMap {n : ℕ} (mean : Fin n → ℝ) :
    Measurable (mixtureMap mean) := by
  unfold mixtureMap
  fun_prop

theorem measurable_canonicalPoint {m n : ℕ} (mean : Fin n → ℝ)
    (i : Fin m) : Measurable (fun ω ↦ canonicalPoint mean ω i) := by
  exact (measurable_mixtureMap mean).comp (measurable_pi_apply i)

/-- Coordinate rows of the canonical product sample are independent. -/
theorem canonicalRows_iIndep (m n : ℕ) :
    iIndepFun
      (fun i : Fin m ↦ fun ω : Fin m → ℝ × (Fin n → ℝ) ↦ ω i)
      (latentNoiseSampleMeasure m n) := by
  unfold latentNoiseSampleMeasure
  simpa using
    (iIndepFun_pi
      (μ := fun _ : Fin m ↦ latentNoiseObservationMeasure n)
      (X := fun _ : Fin m ↦ id)
      (fun _ ↦ aemeasurable_id))

/-- Each coordinate row has the common latent-sign/noise law. -/
theorem canonicalRow_hasLaw (m n : ℕ) (i : Fin m) :
    HasLaw (fun ω : Fin m → ℝ × (Fin n → ℝ) ↦ ω i)
      (latentNoiseObservationMeasure n) (latentNoiseSampleMeasure m n) := by
  exact ⟨(measurable_pi_apply i).aemeasurable,
    (measurePreserving_eval
      (μ := fun _ : Fin m ↦ latentNoiseObservationMeasure n) i).map_eq⟩

/-- The generated point in every row has exactly the symmetric Gaussian-
mixture law. -/
theorem canonicalPoint_hasLaw (m n : ℕ) (mean : Fin n → ℝ) (i : Fin m) :
    HasLaw (fun ω ↦ canonicalPoint mean ω i)
      (gaussianMixtureMeasure mean) (latentNoiseSampleMeasure m n) := by
  have hmap : HasLaw (mixtureMap mean) (gaussianMixtureMeasure mean)
      (latentNoiseObservationMeasure n) := by
    refine ⟨(measurable_mixtureMap mean).aemeasurable, ?_⟩
    rfl
  simpa [canonicalPoint, Function.comp_def] using
    hmap.fun_comp (canonicalRow_hasLaw m n i)

/-- The observed point rows remain independent after applying the mixture map
row by row. -/
theorem canonicalPoints_iIndep (m n : ℕ) (mean : Fin n → ℝ) :
    iIndepFun (fun i ↦ fun ω ↦ canonicalPoint mean ω i)
      (latentNoiseSampleMeasure m n) := by
  have h := (canonicalRows_iIndep m n).comp
    (fun _i z ↦ mixtureMap mean z) (fun _i ↦ measurable_mixtureMap mean)
  simpa [canonicalPoint, Function.comp_def] using h

end NumStability.HDP.Vector.GaussianMixture
