import ComputationalMathematics.HDP.Vector.GaussianMixtureNoise

/-!
# Operational Gaussian mixture probability and moment certificate

Reusable mathematics transported from preserved runtime assets.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- Operational probability and moment facts for the existing model, valid
for every finite sample size and dimension, including zero. -/
def OperationalCanonicalGaussianModelCertificate (m n : ℕ) : Prop :=
  let γ := NumStability.standardGaussianVectorMeasure n
  let ν := latentNoiseObservationMeasure n
  let μ := latentNoiseSampleMeasure m n
  (gaussianReal 0 1) Set.univ = 1 ∧
  gaussianReal 0 1 = volume.withDensity
    (fun x : ℝ ↦ ENNReal.ofReal
      ((Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(x ^ 2) / 2))) ∧
  (∫ x : ℝ, (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(x ^ 2) / 2)) = 1 ∧
  (∀ t : ℝ, Integrable (fun x : ℝ ↦ Real.exp (t * x)) (gaussianReal 0 1) ∧
    (∫ x : ℝ, Real.exp (t * x) ∂gaussianReal 0 1) = Real.exp (t ^ 2 / 2)) ∧
  γ Set.univ = 1 ∧
  (∀ B : Fin n → Set ℝ,
    γ (Set.pi Set.univ B) = ∏ j : Fin n, gaussianReal 0 1 (B j)) ∧
  (∀ j : Fin n, γ.map (fun x : Fin n → ℝ ↦ x j) = gaussianReal 0 1) ∧
  iIndepFun (fun j : Fin n ↦ fun x : Fin n → ℝ ↦ x j) γ ∧
  (∀ j : Fin n, MemLp (fun x : Fin n → ℝ ↦ x j) 2 γ) ∧
  (∫ x : Fin n → ℝ, x ∂γ) = 0 ∧
  (∀ i j : Fin n, cov[fun x : Fin n → ℝ ↦ x i, fun x : Fin n → ℝ ↦ x j; γ] =
    if i = j then 1 else 0) ∧
  ν Set.univ = 1 ∧
  (∀ (L : Set ℝ) (B : Set (Fin n → ℝ)),
    ν (L ×ˢ B) = rademacherPMF.toMeasure L * γ B) ∧
  ν.map (fun z : ℝ × (Fin n → ℝ) ↦ z.1) = rademacherPMF.toMeasure ∧
  ν.map (fun z : ℝ × (Fin n → ℝ) ↦ z.2) = γ ∧
  μ Set.univ = 1 ∧
  (∀ i : Fin m, μ.map (fun ω : Fin m → ℝ × (Fin n → ℝ) ↦ ω i) = ν) ∧
  iIndepFun (fun i : Fin m ↦ fun ω : Fin m → ℝ × (Fin n → ℝ) ↦ ω i) μ ∧
  (∀ (i : Fin m) (j : Fin n),
    μ.map (fun ω ↦ canonicalNoise ω i j) = gaussianReal 0 1) ∧
  iIndepFun (fun ij : Fin m × Fin n ↦ fun ω ↦ canonicalNoise ω ij.1 ij.2) μ ∧
  ∀ (i : Fin m) (j : Fin n),
    Integrable (fun ω ↦ canonicalNoise ω i j) μ ∧
      (∫ ω, canonicalNoise ω i j ∂μ) = 0

/-- Exact producer assembly, with no new Gaussian probability argument. -/
theorem operationalCanonicalGaussianModelCertificate (m n : ℕ) :
    OperationalCanonicalGaussianModelCertificate m n := by
  dsimp only [OperationalCanonicalGaussianModelCertificate]
  refine ⟨measure_univ, ?_, ?_, ?_,
    NumStability.standardGaussianVectorMeasure_univ n,
    (fun B ↦ Measure.pi_pi (fun _ : Fin n ↦ gaussianReal 0 1) B),
    (fun j ↦ (NumStability.standardGaussianVectorCoordinate_hasLaw n j).map_eq),
    NumStability.standardGaussianVectorCoordinates_iIndep n,
    NumStability.standardGaussianVectorCoordinate_memLp_two n,
    NumStability.standardGaussianVectorMeasure_mean n,
    NumStability.standardGaussianVectorCoordinate_covariance n,
    measure_univ, (fun L B ↦ Measure.prod_prod L B),
    (latentSign_hasLaw n).map_eq, (latentNoise_isStandardNormal n).map_eq,
    ?_, (fun i ↦ (canonicalRow_hasLaw m n i).map_eq),
    canonicalRows_iIndep m n,
    (fun i j ↦ (canonicalNoise_coordinate_hasLaw i j).map_eq),
    canonicalNoiseEntries_iIndep m n,
    (fun i j ↦ (canonicalNoise_coordinate_subGaussian_centered i j).2)⟩
  · rw [gaussianReal_of_var_ne_zero 0 one_ne_zero]
    congr 1
    funext x
    simp only [gaussianPDF, gaussianPDFReal, NNReal.coe_one, mul_one, sub_zero]
  · simpa only [gaussianPDFReal, NNReal.coe_one, mul_one, sub_zero] using
      integral_gaussianPDFReal_eq_one 0 one_ne_zero
  · intro t
    exact ⟨integrable_exp_mul_gaussianReal t,
      NumStability.HDP.Scalar.SubGaussian.standardNormalMGF t⟩
  · unfold latentNoiseSampleMeasure
    exact measure_univ

end NumStability.HDP.Vector.GaussianMixture

end
