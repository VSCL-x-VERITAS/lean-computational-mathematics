import ComputationalMathematics.HDP.Vector.GaussianMixtureIdeal
import ComputationalMathematics.HDP.Vector.GaussianMixtureNoise

/-!
# Ordinary sign-weighted Gaussian noise laws

These laws use the actual independent-product latent model. They state no
author convention, source wrapper, clustering error rate or sample budget.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- Multiplying one independent standard-Gaussian row by its latent sign
preserves its joint standard-normal law. -/
theorem latentSignedNoise_hasLaw (n : ℕ) :
    HasLaw (fun z : ℝ × (Fin n → ℝ) ↦ fun j ↦ z.1 * z.2 j)
      (NumStability.standardGaussianVectorMeasure n)
      (latentNoiseObservationMeasure n) := by
  have hneg : (NumStability.standardGaussianVectorMeasure n).map
      (fun g : Fin n → ℝ ↦ fun j ↦ -g j) =
      NumStability.standardGaussianVectorMeasure n := by
    unfold NumStability.standardGaussianVectorMeasure
    rw [Measure.pi_map_pi (fun _ ↦ measurable_neg.aemeasurable)]
    simp only [gaussianReal_map_neg, neg_zero]
  refine ⟨(by fun_prop), ?_⟩
  change (rademacherPMF.toMeasure.prod
      (NumStability.standardGaussianVectorMeasure n)).map
      (fun z : ℝ × (Fin n → ℝ) ↦ fun j ↦ z.1 * z.2 j) = _
  ext A hA
  rw [Measure.map_apply (by fun_prop) hA,
    Measure.prod_apply (hA.preimage (by fun_prop))]
  change (∫⁻ s, (NumStability.standardGaussianVectorMeasure n)
      {g | (fun j ↦ s * g j) ∈ A} ∂rademacherPMF.toMeasure) =
    (NumStability.standardGaussianVectorMeasure n) A
  have heq : ∀ᵐ s ∂rademacherPMF.toMeasure,
      (NumStability.standardGaussianVectorMeasure n)
        {g | (fun j ↦ s * g j) ∈ A} =
      (NumStability.standardGaussianVectorMeasure n) A := by
    filter_upwards [rademacher_ae_eq_neg_one_or_one] with s hs
    rcases hs with rfl | rfl
    · have hh := congrArg (fun ν : Measure (Fin n → ℝ) ↦ ν A) hneg
      dsimp only at hh
      rw [Measure.map_apply (by fun_prop) hA] at hh
      simpa only [neg_one_mul] using hh
    · simp only [one_mul]
      rfl
  rw [lintegral_congr_ae heq]
  simp

/-- Every canonical sign-weighted noise row is jointly standard normal. -/
theorem canonicalSignedNoise_isStandardNormal {m n : ℕ} (i : Fin m) :
    NumStability.HDP.Vector.Gaussian.IsStandardNormal
      (latentNoiseSampleMeasure m n)
      (fun j ω ↦ canonicalLabel ω i * canonicalNoise ω i j) := by
  simpa only [NumStability.HDP.Vector.Gaussian.IsStandardNormal,
    Function.comp_def, canonicalLabel, canonicalNoise] using
    (latentSignedNoise_hasLaw n).fun_comp (canonicalRow_hasLaw m n i)

/-- Sign-weighted canonical noise rows remain mutually independent because
each is a measurable function of its own independent latent observation. -/
theorem canonicalSignedNoises_iIndep (m n : ℕ) :
    iIndepFun (fun i ↦ fun ω ↦ fun j ↦
      canonicalLabel ω i * canonicalNoise ω i j)
      (latentNoiseSampleMeasure m n) := by
  have h := (canonicalRows_iIndep m n).comp
    (fun _i (z : ℝ × (Fin n → ℝ)) ↦ fun j ↦ z.1 * z.2 j)
    (fun _i ↦ by fun_prop)
  simpa only [Function.comp_def, canonicalLabel, canonicalNoise] using h


/-- Each coordinate of the empirical average of canonical sign-weighted
Gaussian noise has exact variance reciprocal to the positive sample size. -/
theorem canonicalSignedNoise_average_coordinate_hasLaw {m n : ℕ}
    (hm : 0 < m) (j : Fin n) :
    HasLaw
      (fun ω : Fin m → ℝ × (Fin n → ℝ) ↦
        (m : ℝ)⁻¹ * ∑ i, canonicalLabel ω i * canonicalNoise ω i j)
      (gaussianReal 0 (Real.toNNReal ((m : ℝ)⁻¹)))
      (latentNoiseSampleMeasure m n) := by
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  let X : Fin m → (Fin m → ℝ × (Fin n → ℝ)) → ℝ :=
    fun i ω ↦ canonicalLabel ω i * canonicalNoise ω i j
  have hLaw : ∀ i, HasLaw (X i) (gaussianReal 0 1)
      (latentNoiseSampleMeasure m n) := by
    intro i
    exact (NumStability.HDP.Vector.Gaussian.isStandardNormal_iff_iIndepFun_hasLaw.mp
      (canonicalSignedNoise_isStandardNormal i)).2 j
  have hIndep : iIndepFun X (latentNoiseSampleMeasure m n) := by
    have h := (canonicalSignedNoises_iIndep m n).comp
      (fun _i g ↦ g j) (fun _i ↦ measurable_pi_apply j)
    simpa only [X, Function.comp_def] using h
  have hRaw := NumStability.HDP.Scalar.SubGaussian.independentGaussianWeightedSumLaw
    (fun _i : Fin m ↦ (m : ℝ)⁻¹) hLaw hIndep
  have hmR : (m : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hm)
  have hVar : (∑ _i : Fin m,
      Real.toNNReal (((m : ℝ)⁻¹) ^ 2) * (1 : NNReal)) =
      Real.toNNReal ((m : ℝ)⁻¹) := by
    apply NNReal.eq
    simp only [mul_one,
      Real.toNNReal_of_nonneg (sq_nonneg _),
      Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul,
      Real.toNNReal_of_nonneg (inv_nonneg.mpr (Nat.cast_nonneg m))]
    simp only [NNReal.coe_mul, NNReal.coe_natCast, NNReal.coe_mk]
    field_simp
  rw [hVar] at hRaw
  simpa only [X, Finset.mul_sum] using hRaw

end NumStability.HDP.Vector.GaussianMixture
