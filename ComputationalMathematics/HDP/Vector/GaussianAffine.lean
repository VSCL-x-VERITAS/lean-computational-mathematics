import ComputationalMathematics.HDP.Vector.Gaussian
import ComputationalMathematics.HDP.Vector.Covariance
import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv
import Mathlib.MeasureTheory.Integral.Lebesgue.Map
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

/-!
# Affine Gaussian random vectors

This module packages the source-independent affine transport used to construct
finite general Gaussian laws from the canonical standard-Gaussian product law.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Vector.Gaussian

/-- The affine map used to transport a standard Gaussian vector to a general
finite Gaussian vector.  The matrix parameter is a covariance factor; its
product with its transpose is the resulting covariance matrix. -/
def affineGaussianMap {n : ℕ} (m : Fin n → ℝ)
    (A : Matrix (Fin n) (Fin n) ℝ) (z : Fin n → ℝ) : Fin n → ℝ :=
  m + Matrix.mulVec A z

/-- The finite-dimensional Gaussian affine map is measurable. -/
theorem measurable_affineGaussianMap {n : ℕ} (m : Fin n → ℝ)
    (A : Matrix (Fin n) (Fin n) ℝ) :
    Measurable (affineGaussianMap m A) := by
  apply measurable_pi_lambda
  intro i
  change Measurable (fun z : Fin n → ℝ => m i + ∑ j, A i j * z j)
  fun_prop

/-- The law obtained by applying an affine map to the canonical finite
standard-Gaussian product measure. -/
def affineGaussianVectorMeasure {n : ℕ} (m : Fin n → ℝ)
    (A : Matrix (Fin n) (Fin n) ℝ) : Measure (Fin n → ℝ) :=
  (NumStability.standardGaussianVectorMeasure n).map (affineGaussianMap m A)

/-- A random vector has an affine standard-Gaussian law when its joint law is
the corresponding affine transport of the canonical standard Gaussian. -/
def HasAffineStandardNormalLaw {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) (m : Fin n → ℝ)
    (A : Matrix (Fin n) (Fin n) ℝ) : Prop :=
  HasLaw (fun ω i => X i ω) (affineGaussianVectorMeasure m A) μ

/-- The standardization map associated with an invertible affine Gaussian
factor. -/
def standardizeAffineMap {n : ℕ} (m : Fin n → ℝ)
    (A : Matrix (Fin n) (Fin n) ℝ) (x : Fin n → ℝ) : Fin n → ℝ :=
  Matrix.mulVec A⁻¹ (x - m)

/-- Finite-dimensional affine Gaussian standardization is measurable. -/
theorem measurable_standardizeAffineMap {n : ℕ} (m : Fin n → ℝ)
    (A : Matrix (Fin n) (Fin n) ℝ) : Measurable (standardizeAffineMap m A) := by
  apply measurable_pi_lambda
  intro i
  change Measurable (fun x : Fin n → ℝ => ∑ j, A⁻¹ i j * (x j - m j))
  fun_prop

/-- Standardizing after an invertible affine map recovers the original
vector. -/
theorem standardizeAffineMap_affineGaussianMap {n : ℕ} (m : Fin n → ℝ)
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : IsUnit A) (z : Fin n → ℝ) :
    standardizeAffineMap m A (affineGaussianMap m A z) = z := by
  letI := hA.invertible
  simp only [standardizeAffineMap, affineGaussianMap, add_sub_cancel_left,
    Matrix.mulVec_mulVec, Matrix.inv_mul_of_invertible, Matrix.one_mulVec]

/-- Applying an invertible affine map after standardization recovers the
original vector. -/
theorem affineGaussianMap_standardizeAffineMap {n : ℕ} (m : Fin n → ℝ)
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : IsUnit A) (x : Fin n → ℝ) :
    affineGaussianMap m A (standardizeAffineMap m A x) = x := by
  letI := hA.invertible
  simp only [standardizeAffineMap, affineGaussianMap, Matrix.mulVec_mulVec,
    Matrix.mul_inv_of_invertible, Matrix.one_mulVec, add_sub_cancel]

/-- An invertible affine Gaussian map as a measurable equivalence, with the
standardization map as inverse. -/
def affineGaussianMeasurableEquiv {n : ℕ} (m : Fin n → ℝ)
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : IsUnit A) :
    (Fin n → ℝ) ≃ᵐ (Fin n → ℝ) where
  toFun := affineGaussianMap m A
  invFun := standardizeAffineMap m A
  left_inv := standardizeAffineMap_affineGaussianMap m A hA
  right_inv := affineGaussianMap_standardizeAffineMap m A hA
  measurable_toFun := measurable_affineGaussianMap m A
  measurable_invFun := measurable_standardizeAffineMap m A

/-- For an invertible factor, having the corresponding affine standard-normal
law is equivalent to the standardized vector having the canonical standard
normal law. -/
theorem hasAffineStandardNormalLaw_iff_standardized
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ} {m : Fin n → ℝ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : IsUnit A) :
    HasAffineStandardNormalLaw μ X m A ↔
      HasLaw (fun ω => standardizeAffineMap m A (fun i => X i ω))
        (NumStability.standardGaussianVectorMeasure n) μ := by
  constructor
  · intro hX
    have hInv : HasLaw (standardizeAffineMap m A)
        (NumStability.standardGaussianVectorMeasure n)
        (affineGaussianVectorMeasure m A) := by
      refine ⟨(measurable_standardizeAffineMap m A).aemeasurable, ?_⟩
      rw [affineGaussianVectorMeasure,
        Measure.map_map (measurable_standardizeAffineMap m A)
          (measurable_affineGaussianMap m A)]
      convert Measure.map_id
      funext z
      exact standardizeAffineMap_affineGaussianMap m A hA z
    exact hInv.fun_comp hX
  · intro hZ
    have hAff : HasLaw (affineGaussianMap m A)
        (affineGaussianVectorMeasure m A)
        (NumStability.standardGaussianVectorMeasure n) := by
      refine ⟨(measurable_affineGaussianMap m A).aemeasurable, rfl⟩
    have h := hAff.fun_comp hZ
    exact h.congr (Filter.Eventually.of_forall fun ω =>
      (affineGaussianMap_standardizeAffineMap m A hA (fun i => X i ω)).symm)

/-- A random vector with an affine standard-Gaussian law has the affine shift
as its coordinatewise mean. -/
theorem meanVector_eq_of_hasAffineStandardNormalLaw
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ} {m : Fin n → ℝ}
    {A : Matrix (Fin n) (Fin n) ℝ}
    (hX : HasAffineStandardNormalLaw μ X m A) :
    NumStability.HDP.Vector.Covariance.meanVector μ X = m := by
  funext i
  unfold NumStability.HDP.Vector.Covariance.meanVector
  have hLaw := hX.integral_comp
    (f := fun x : Fin n → ℝ => x i) (measurable_pi_apply i).aestronglyMeasurable
  change (∫ ω, X i ω ∂μ) = _ at hLaw
  rw [hLaw]
  unfold affineGaussianVectorMeasure
  rw [integral_map]
  · simp only [affineGaussianMap, Pi.add_apply, Matrix.mulVec]
    rw [integral_add]
    · have hz : ∀ j : Fin n,
          ∫ z, z j ∂NumStability.standardGaussianVectorMeasure n = 0 := by
        intro j
        rw [(NumStability.standardGaussianVectorCoordinate_hasLaw n j).integral_eq,
          integral_id_gaussianReal]
      simp only [dotProduct]
      rw [integral_const, integral_finset_sum]
      · simp_rw [integral_const_mul, hz, mul_zero, Finset.sum_const_zero, add_zero]
        simp
      · intro j _
        exact MeasureTheory.Integrable.const_mul
          ((NumStability.standardGaussianVectorCoordinate_memLp_two n j).integrable
            (by norm_num)) _
    · exact integrable_const _
    · exact integrable_finset_sum _ fun j _ =>
        MeasureTheory.Integrable.const_mul
          ((NumStability.standardGaussianVectorCoordinate_memLp_two n j).integrable
            (by norm_num)) _
  · exact (measurable_affineGaussianMap m A).aemeasurable
  · exact (measurable_pi_apply i).aestronglyMeasurable

/-- A random vector with an affine standard-Gaussian law has covariance
`A * Aᵀ`. -/
theorem covarianceMatrix_eq_mul_transpose_of_hasAffineStandardNormalLaw
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Fin n → Ω → ℝ} {m : Fin n → ℝ}
    {A : Matrix (Fin n) (Fin n) ℝ}
    (hX : HasAffineStandardNormalLaw μ X m A) :
    NumStability.HDP.Vector.Covariance.covarianceMatrix μ X =
      A * A.transpose := by
  funext i j
  rw [NumStability.HDP.Vector.Covariance.covarianceMatrix_apply]
  have hLaw := hX.covariance_fun_comp
    (f := fun x : Fin n → ℝ => x i) (g := fun x : Fin n → ℝ => x j)
    (measurable_pi_apply i).aemeasurable (measurable_pi_apply j).aemeasurable
  change cov[X i, X j; μ] = _ at hLaw
  rw [hLaw]
  unfold affineGaussianVectorMeasure
  rw [covariance_map_fun]
  · simp only [affineGaussianMap, Pi.add_apply, Matrix.mulVec, dotProduct]
    have hi : MemLp (fun z : Fin n → ℝ => ∑ k, A i k * z k) 2
        (NumStability.standardGaussianVectorMeasure n) := by
      convert (memLp_finset_sum' Finset.univ fun k _ =>
        (NumStability.standardGaussianVectorCoordinate_memLp_two n k).const_mul
          (A i k)) using 1
      ext z
      simp
    have hj : MemLp (fun z : Fin n → ℝ => ∑ k, A j k * z k) 2
        (NumStability.standardGaussianVectorMeasure n) := by
      convert (memLp_finset_sum' Finset.univ fun k _ =>
        (NumStability.standardGaussianVectorCoordinate_memLp_two n k).const_mul
          (A j k)) using 1
      ext z
      simp
    rw [covariance_const_add_left (hi.integrable (by norm_num)) (m i),
      covariance_const_add_right (hj.integrable (by norm_num)) (m j),
      covariance_fun_sum_fun_sum]
    · simp_rw [covariance_const_mul_left, covariance_const_mul_right,
        NumStability.standardGaussianVectorCoordinate_covariance]
      simp [Matrix.mul_apply]
    · intro k
      exact (NumStability.standardGaussianVectorCoordinate_memLp_two n k).const_mul _
    · intro k
      exact (NumStability.standardGaussianVectorCoordinate_memLp_two n k).const_mul _
  · exact (measurable_pi_apply i).aestronglyMeasurable
  · exact (measurable_pi_apply j).aestronglyMeasurable
  · exact (measurable_affineGaussianMap m A).aemeasurable

/-- Mapping a density through a measurable equivalence pulls the density back
through the inverse equivalence. -/
theorem map_withDensity_measurableEquiv
    {α β : Type*} [MeasurableSpace α] [MeasurableSpace β]
    (e : α ≃ᵐ β) (μ : Measure α) (f : α → ℝ≥0∞) (hf : Measurable f) :
    Measure.map e (μ.withDensity f) =
      (Measure.map e μ).withDensity (fun y => f (e.symm y)) := by
  ext s hs
  rw [Measure.map_apply e.measurable hs,
    withDensity_apply _ (e.measurable hs), withDensity_apply _ hs]
  symm
  simpa [Function.comp_def] using
    (setLIntegral_map (μ := μ) hs (hf.comp e.symm.measurable) e.measurable)

/-- The pushforward of Lebesgue volume through an invertible affine Gaussian
map is scaled by the reciprocal absolute determinant. -/
theorem map_affineGaussianMap_volume
    {n : ℕ} (m : Fin n → ℝ) (A : Matrix (Fin n) (Fin n) ℝ)
    (hA : IsUnit A) :
    Measure.map (affineGaussianMap m A) (volume : Measure (Fin n → ℝ)) =
      ENNReal.ofReal (abs (Matrix.det A)⁻¹) • volume := by
  letI := hA.invertible
  have hdet : Matrix.det A ≠ 0 := (Matrix.isUnit_det_of_invertible A).ne_zero
  have hfun :
      affineGaussianMap m A =
        (fun y : Fin n → ℝ => m + y) ∘ Matrix.toLin' A := by
    rfl
  rw [hfun, ← Measure.map_map (by fun_prop) (by fun_prop),
    Real.map_matrix_volume_pi_eq_smul_volume_pi hdet,
    Measure.map_smul, map_add_left_eq_self]

/-- Change of variables for a density transported by an invertible affine
Gaussian map. -/
theorem map_affineGaussianMap_withDensity
    {n : ℕ} (m : Fin n → ℝ) (A : Matrix (Fin n) (Fin n) ℝ)
    (hA : IsUnit A) (f : (Fin n → ℝ) → ℝ≥0∞) (hf : Measurable f) :
    Measure.map (affineGaussianMap m A)
        ((volume : Measure (Fin n → ℝ)).withDensity f) =
      (volume : Measure (Fin n → ℝ)).withDensity
        (fun x =>
          ENNReal.ofReal (abs (Matrix.det A)⁻¹) *
            f (standardizeAffineMap m A x)) := by
  let e := affineGaussianMeasurableEquiv m A hA
  have he := map_withDensity_measurableEquiv e
    (volume : Measure (Fin n → ℝ)) f hf
  change
    Measure.map (affineGaussianMap m A)
        ((volume : Measure (Fin n → ℝ)).withDensity f) =
      (Measure.map (affineGaussianMap m A)
        (volume : Measure (Fin n → ℝ))).withDensity
          (fun x => f (standardizeAffineMap m A x)) at he
  rw [map_affineGaussianMap_volume m A hA, withDensity_smul_measure] at he
  let g : (Fin n → ℝ) → ℝ≥0∞ :=
    fun x => f (standardizeAffineMap m A x)
  have hg : Measurable g :=
    hf.comp (measurable_standardizeAffineMap m A)
  have hd := withDensity_smul
    (μ := (volume : Measure (Fin n → ℝ)))
    (ENNReal.ofReal (abs (Matrix.det A)⁻¹)) hg
  calc
    Measure.map (affineGaussianMap m A)
        ((volume : Measure (Fin n → ℝ)).withDensity f) =
        ENNReal.ofReal (abs (Matrix.det A)⁻¹) •
          (volume : Measure (Fin n → ℝ)).withDensity g := by
            simpa [g] using he
    _ = (volume : Measure (Fin n → ℝ)).withDensity
          (ENNReal.ofReal (abs (Matrix.det A)⁻¹) • g) := hd.symm
    _ = (volume : Measure (Fin n → ℝ)).withDensity
          (fun x =>
            ENNReal.ofReal (abs (Matrix.det A)⁻¹) *
              f (standardizeAffineMap m A x)) := by
            rfl

/-- The product standard-Gaussian density after an invertible affine change
of variables. -/
def affineStandardGaussianDensity
    {n : ℕ} (m : Fin n → ℝ) (A : Matrix (Fin n) (Fin n) ℝ)
    (x : Fin n → ℝ) : ℝ :=
  abs (Matrix.det A)⁻¹ *
    ∏ i : Fin n, ProbabilityTheory.gaussianPDFReal 0 1
      (standardizeAffineMap m A x i)

/-- Standardizing through a positive semidefinite square root turns the sum
of coordinate squares into the covariance quadratic form. -/
theorem sum_standardize_sq_eq_covariance_quadratic
    {n : ℕ} (m x : Fin n → ℝ)
    (S B : Matrix (Fin n) (Fin n) ℝ)
    (hSunit : IsUnit S) (hBpos : B.PosSemidef) (hBB : B * B = S) :
    (∑ i : Fin n, (standardizeAffineMap m B x i) ^ 2) =
      (x - m) ⬝ᵥ Matrix.mulVec S⁻¹ (x - m) := by
  have hBBunit : IsUnit (B * B) := hBB.symm ▸ hSunit
  have hBunit : IsUnit B := isUnit_of_mul_isUnit_left hBBunit
  letI := hBunit.invertible
  let v : Fin n → ℝ := x - m
  let y : Fin n → ℝ := standardizeAffineMap m B x
  have hy : y = Matrix.mulVec B⁻¹ v := by
    rfl
  have hv : Matrix.mulVec B y = v := by
    rw [hy, Matrix.mulVec_mulVec, Matrix.mul_inv_of_invertible,
      Matrix.one_mulVec]
  have hSinvB : S⁻¹ * B = B⁻¹ := by
    rw [← hBB, Matrix.mul_inv_rev]
    simp [Matrix.mul_assoc]
  have hBt : B.transpose = B := by
    simpa [Matrix.conjTranspose_eq_transpose_of_trivial] using hBpos.1
  change (∑ i : Fin n, (y i) ^ 2) = v ⬝ᵥ Matrix.mulVec S⁻¹ v
  have hquad : v ⬝ᵥ Matrix.mulVec S⁻¹ v = y ⬝ᵥ y := by
    calc
      v ⬝ᵥ Matrix.mulVec S⁻¹ v =
          Matrix.mulVec B y ⬝ᵥ Matrix.mulVec S⁻¹ (Matrix.mulVec B y) := by rw [hv]
      _ = Matrix.mulVec B y ⬝ᵥ Matrix.mulVec B⁻¹ y := by
        rw [Matrix.mulVec_mulVec, hSinvB]
      _ = Matrix.vecMul y B.transpose ⬝ᵥ Matrix.mulVec B⁻¹ y := by
        rw [Matrix.vecMul_transpose]
      _ = y ⬝ᵥ Matrix.mulVec B.transpose (Matrix.mulVec B⁻¹ y) :=
        (Matrix.dotProduct_mulVec y B.transpose (Matrix.mulVec B⁻¹ y)).symm
      _ = y ⬝ᵥ y := by
        rw [hBt, Matrix.mulVec_mulVec, Matrix.mul_inv_of_invertible,
          Matrix.one_mulVec]
  rw [hquad]
  simp [dotProduct, pow_two]

/-- The Gaussian density with mean vector and invertible covariance matrix. -/
def covarianceGaussianDensity
    {n : ℕ} (m : Fin n → ℝ) (S : Matrix (Fin n) (Fin n) ℝ)
    (x : Fin n → ℝ) : ℝ :=
  (Real.sqrt (2 * Real.pi))⁻¹ ^ n *
    (Real.sqrt (Matrix.det S))⁻¹ *
      Real.exp (-((x - m) ⬝ᵥ Matrix.mulVec S⁻¹ (x - m)) / 2)

/-- For a positive semidefinite covariance square root, the affine form of
the density equals the covariance-matrix form. -/
theorem affineStandardGaussianDensity_eq_covarianceGaussianDensity
    {n : ℕ} (m x : Fin n → ℝ)
    (S B : Matrix (Fin n) (Fin n) ℝ)
    (hSunit : IsUnit S) (hBpos : B.PosSemidef) (hBB : B * B = S) :
    affineStandardGaussianDensity m B x =
      covarianceGaussianDensity m S x := by
  unfold affineStandardGaussianDensity covarianceGaussianDensity
  rw [standardGaussianProductDensity_eq,
    sum_standardize_sq_eq_covariance_quadratic m x S B hSunit hBpos hBB]
  have hdetB : 0 ≤ Matrix.det B := hBpos.det_nonneg
  have hdetS : Matrix.det S = (Matrix.det B) ^ 2 := by
    rw [← hBB, Matrix.det_mul, pow_two]
  have hsqrt : Real.sqrt (Matrix.det S) = Matrix.det B := by
    rw [hdetS, Real.sqrt_sq hdetB]
  rw [abs_inv, abs_of_nonneg hdetB, hsqrt]
  ring

end NumStability.HDP.Vector.Gaussian
