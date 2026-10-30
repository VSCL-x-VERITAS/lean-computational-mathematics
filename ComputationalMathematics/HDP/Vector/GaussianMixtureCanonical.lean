import ComputationalMathematics.HDP.Vector.GaussianMixture.Basic
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

/-- Finite joint label/noise rectangle probabilities expose the independence
within each row and between rows of the canonical Gaussian-mixture model. -/
theorem latentNoiseSampleMeasure_finite_rectangle (m n : ℕ) (S : Finset (Fin m))
    (L : Fin m → Set ℝ) (B : Fin m → Set (Fin n → ℝ))
    (hL : ∀ i ∈ S, MeasurableSet (L i)) (hB : ∀ i ∈ S, MeasurableSet (B i)) :
    latentNoiseSampleMeasure m n {ω | ∀ i ∈ S, (ω i).1 ∈ L i ∧ (ω i).2 ∈ B i} =
      ∏ i ∈ S, rademacherPMF.toMeasure (L i) *
        NumStability.standardGaussianVectorMeasure n (B i) := by
  have hsingle (i : Fin m) (hi : i ∈ S) :
      latentNoiseSampleMeasure m n ((fun ω ↦ ω i) ⁻¹' (L i ×ˢ B i)) =
        rademacherPMF.toMeasure (L i) *
          NumStability.standardGaussianVectorMeasure n (B i) := by
    rw [← Measure.map_apply (measurable_pi_apply i) ((hL i hi).prod (hB i hi)),
      (canonicalRow_hasLaw m n i).map_eq, latentNoiseObservationMeasure, Measure.prod_prod]
  have h := (canonicalRows_iIndep m n).measure_inter_preimage_eq_mul S
    (sets := fun i ↦ L i ×ˢ B i) (fun i hi ↦ (hL i hi).prod (hB i hi))
  calc
    _ = latentNoiseSampleMeasure m n (⋂ i ∈ S, (fun ω ↦ ω i) ⁻¹' (L i ×ˢ B i)) := by
      congr 1
      ext ω
      simp only [Set.mem_setOf_eq, Set.mem_iInter, Set.mem_preimage, Set.mem_prod]
    _ = _ := h
    _ = _ := Finset.prod_congr rfl hsingle

section

open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal BigOperators

/-- The first coordinate of one latent observation has the Rademacher law. -/
theorem latentSign_hasLaw (n : ℕ) :
    HasLaw (fun z : ℝ × (Fin n → ℝ) ↦ z.1)
      rademacherPMF.toMeasure (latentNoiseObservationMeasure n) := by
  exact MeasureTheory.measurePreserving_fst.hasLaw

end

section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators RealInnerProductSpace

/-- The real Rademacher law is concentrated on `{-1, 1}`. -/
theorem rademacher_ae_eq_neg_one_or_one :
    ∀ᵐ z ∂rademacherPMF.toMeasure, z = -1 ∨ z = 1 := by
  rw [show rademacherPMF.toMeasure =
      Measure.map rademacherValue fairBernoulliPMF.toMeasure by
    simpa [rademacherPMF] using
      (PMF.toMeasure_map rademacherValue fairBernoulliPMF
        (measurable_of_countable rademacherValue)).symm]
  apply (ae_map_iff
    (measurable_of_countable rademacherValue).aemeasurable
    ((measurableSet_singleton (-1 : ℝ)).union
      (measurableSet_singleton (1 : ℝ)))).2
  refine Filter.Eventually.of_forall ?_
  intro b
  change rademacherValue b = -1 ∨ rademacherValue b = 1
  cases b <;> simp [rademacherValue]

/-- Every canonical latent label has the Rademacher law. -/
theorem canonicalLabel_hasLaw (m n : ℕ) (i : Fin m) :
    HasLaw (fun ω : Fin m → ℝ × (Fin n → ℝ) ↦ canonicalLabel ω i)
      rademacherPMF.toMeasure (latentNoiseSampleMeasure m n) := by
  simpa [canonicalLabel] using
    (latentSign_hasLaw n).fun_comp (canonicalRow_hasLaw m n i)

/-- All labels in a finite canonical sample lie in `{-1,1}` almost surely. -/
theorem canonicalLabels_ae_eq_neg_one_or_one (m n : ℕ) :
    ∀ᵐ ω ∂latentNoiseSampleMeasure m n,
      ∀ i, canonicalLabel ω i = -1 ∨ canonicalLabel ω i = 1 := by
  rw [ae_all_iff]
  intro i
  exact ((canonicalLabel_hasLaw m n i).ae_iff (by fun_prop)).2
    rademacher_ae_eq_neg_one_or_one

end

end NumStability.HDP.Vector.GaussianMixture
