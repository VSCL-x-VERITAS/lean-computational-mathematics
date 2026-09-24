import ComputationalMathematics.HDP.Vector.Covariance
import ComputationalMathematics.HDP.Vector.Isotropy

/-!
# Affine transformations of finite random-vector moments

This module gives source-independent mean and covariance transport for finite
real random vectors under deterministic affine maps.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Vector

/-- Apply a deterministic affine map coordinatewise to a finite random
vector. -/
def affineTransform {Ω : Type*} {n : ℕ} (m : Fin n → ℝ)
    (A : Matrix (Fin n) (Fin n) ℝ) (X : Fin n → Ω → ℝ) :
    Fin n → Ω → ℝ :=
  fun i ω => m i + ∑ j, A i j * X j ω

/-- Apply a deterministic linear map after centering a finite random vector. -/
def centeredLinearTransform {Ω : Type*} {n : ℕ} (m : Fin n → ℝ)
    (A : Matrix (Fin n) (Fin n) ℝ) (X : Fin n → Ω → ℝ) :
    Fin n → Ω → ℝ :=
  fun i ω => ∑ j, A i j * (X j ω - m j)

/-- A centered linear transform is an affine transform with the corresponding
translated offset. -/
theorem centeredLinearTransform_eq_affineTransform
    {Ω : Type*} {n : ℕ} (m : Fin n → ℝ)
    (A : Matrix (Fin n) (Fin n) ℝ) (X : Fin n → Ω → ℝ) :
    centeredLinearTransform m A X = affineTransform (-(A.mulVec m)) A X := by
  funext i ω
  simp only [centeredLinearTransform, affineTransform, Pi.neg_apply,
    Matrix.mulVec, dotProduct, mul_sub, Finset.sum_sub_distrib]
  ring

/-- Mean vectors transform affinely. -/
theorem meanVector_affineTransform
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (m : Fin n → ℝ) (A : Matrix (Fin n) (Fin n) ℝ)
    (X : Fin n → Ω → ℝ) (hX : ∀ i, Integrable (X i) μ) :
    Covariance.meanVector μ (affineTransform m A X) =
      m + A.mulVec (Covariance.meanVector μ X) := by
  funext i
  change (∫ ω, m i + ∑ j, A i j * X j ω ∂μ) =
    m i + ∑ j, A i j * ∫ ω, X j ω ∂μ
  rw [integral_add (integrable_const _) (integrable_finset_sum _ fun j _ =>
    (hX j).const_mul _), integral_const, integral_finset_sum]
  · simp_rw [integral_const_mul]
    simp
  · intro j _
    exact (hX j).const_mul _

/-- Covariance matrices transform by congruence under deterministic affine
maps. -/
theorem covarianceMatrix_affineTransform
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (m : Fin n → ℝ) (A : Matrix (Fin n) (Fin n) ℝ)
    (X : Fin n → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ) :
    Covariance.covarianceMatrix μ (affineTransform m A X) =
      A * Covariance.covarianceMatrix μ X * A.transpose := by
  funext i j
  rw [Covariance.covarianceMatrix_apply]
  have hi : MemLp (fun ω => ∑ k, A i k * X k ω) 2 μ := by
    convert memLp_finset_sum' Finset.univ fun k _ => (hX k).const_mul (A i k) using 1
    ext ω
    simp
  have hj : MemLp (fun ω => ∑ k, A j k * X k ω) 2 μ := by
    convert memLp_finset_sum' Finset.univ fun k _ => (hX k).const_mul (A j k) using 1
    ext ω
    simp
  change cov[fun ω => m i + ∑ k, A i k * X k ω,
    fun ω => m j + ∑ k, A j k * X k ω; μ] = _
  rw [covariance_const_add_left (hi.integrable (by norm_num)) (m i),
    covariance_const_add_right (hj.integrable (by norm_num)) (m j),
    covariance_fun_sum_fun_sum]
  · simp_rw [covariance_const_mul_left, covariance_const_mul_right]
    simp only [Matrix.mul_apply, Matrix.transpose_apply,
      Covariance.covarianceMatrix_apply]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro l _
    rw [Finset.sum_mul]
    apply Finset.sum_congr rfl
    intro k _
    ring
  · intro k
    exact (hX k).const_mul _
  · intro k
    exact (hX k).const_mul _

/-- Centering before a deterministic linear map subtracts the input mean and
does not otherwise alter the affine moment transport formulas. -/
theorem mean_covariance_centeredLinearTransform
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (m : Fin n → ℝ) (A : Matrix (Fin n) (Fin n) ℝ)
    (X : Fin n → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ) :
    Covariance.meanVector μ (centeredLinearTransform m A X) =
        A.mulVec (Covariance.meanVector μ X - m) ∧
      Covariance.covarianceMatrix μ (centeredLinearTransform m A X) =
        A * Covariance.covarianceMatrix μ X * A.transpose := by
  rw [centeredLinearTransform_eq_affineTransform]
  constructor
  · rw [meanVector_affineTransform _ A X fun i => (hX i).integrable (by norm_num)]
    funext i
    simp only [Pi.add_apply, Pi.neg_apply, Pi.sub_apply, Matrix.mulVec,
      dotProduct, mul_sub, Finset.sum_sub_distrib]
    ring
  · exact covarianceMatrix_affineTransform _ A X hX

/-- Centered linear transforms preserve square integrability coordinatewise. -/
theorem centeredLinearTransform_memLp
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsFiniteMeasure μ]
    (m : Fin n → ℝ) (A : Matrix (Fin n) (Fin n) ℝ)
    (X : Fin n → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ) (i : Fin n) :
    MemLp (centeredLinearTransform m A X i) 2 μ := by
  change MemLp (fun ω => ∑ j, A i j * (X j ω - m j)) 2 μ
  have hY : ∀ j, MemLp (fun ω => A i j * (X j ω - m j)) 2 μ := by
    intro j
    exact ((hX j).sub (memLp_const _)).const_mul _
  convert memLp_finset_sum' Finset.univ (fun j _ => hY j) using 1
  ext ω
  simp

/-- An affine image of a centered isotropic vector has the prescribed affine
mean and covariance factor. -/
theorem mean_covariance_affineTransform_of_centered_isotropic
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (m : Fin n → ℝ) (A : Matrix (Fin n) (Fin n) ℝ)
    (X : Fin n → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ)
    (hMean : Covariance.meanVector μ X = 0)
    (hIso : Isotropy.IsIsotropic μ X) (hA : A.PosSemidef) :
    Covariance.meanVector μ (affineTransform m A X) = m ∧
      Covariance.covarianceMatrix μ (affineTransform m A X) = A * A := by
  constructor
  · rw [meanVector_affineTransform m A X fun i => (hX i).integrable (by norm_num),
      hMean]
    simp
  · rw [covarianceMatrix_affineTransform m A X hX,
      Covariance.covarianceMatrix_eq_secondMomentMatrix X hX hMean, hIso,
      Matrix.mul_one]
    have hAT : A.transpose = A := by
      simpa [Matrix.conjTranspose_eq_transpose_of_trivial] using hA.1
    rw [hAT]

/-- Whitening by the inverse of a positive-semidefinite covariance factor
produces a centered isotropic vector. -/
theorem centered_isotropic_centeredLinearTransform_inverse
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (m : Fin n → ℝ) (B : Matrix (Fin n) (Fin n) ℝ)
    (X : Fin n → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ)
    (hMean : Covariance.meanVector μ X = m)
    (hCov : Covariance.covarianceMatrix μ X = B * B)
    (hB : B.PosSemidef) (hBunit : IsUnit B) :
    Covariance.meanVector μ (centeredLinearTransform m B⁻¹ X) = 0 ∧
      Isotropy.IsIsotropic μ (centeredLinearTransform m B⁻¹ X) := by
  letI := hBunit.invertible
  have hMoments := mean_covariance_centeredLinearTransform m B⁻¹ X hX
  have hMeanWhite :
      Covariance.meanVector μ (centeredLinearTransform m B⁻¹ X) = 0 := by
    rw [hMoments.1, hMean]
    simp
  refine ⟨hMeanWhite, ?_⟩
  have hBT : B.transpose = B := by
    simpa [Matrix.conjTranspose_eq_transpose_of_trivial] using hB.1
  have hCovWhite :
      Covariance.covarianceMatrix μ (centeredLinearTransform m B⁻¹ X) = 1 := by
    rw [hMoments.2, hCov, Matrix.transpose_nonsing_inv, hBT]
    simp
  rw [Isotropy.IsIsotropic]
  rw [← Covariance.covarianceMatrix_eq_secondMomentMatrix
    (centeredLinearTransform m B⁻¹ X)
    (centeredLinearTransform_memLp m B⁻¹ X hX) hMeanWhite]
  exact hCovWhite

end NumStability.HDP.Vector
