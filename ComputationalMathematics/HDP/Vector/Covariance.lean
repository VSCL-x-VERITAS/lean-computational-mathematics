import Mathlib.Probability.Moments.Variance
import Mathlib.Analysis.Matrix.PosDef

/-!
# Covariance matrices of finite random vectors

This module packages Mathlib's scalar covariance coordinatewise.  It keeps the
random vector in coordinate form, matching the other finite-vector foundations
in `ComputationalMathematics.HDP.Vector`.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Vector.Covariance

/-- The coordinatewise mean of a finite real random vector. -/
def meanVector {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) : Fin n → ℝ :=
  fun i => ∫ ω, X i ω ∂μ

/-- The matrix of uncentered second moments. -/
def secondMomentMatrix {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) : Matrix (Fin n) (Fin n) ℝ :=
  fun i j => ∫ ω, X i ω * X j ω ∂μ

/-- The second-moment matrix of a square-integrable finite real random vector
is positive semidefinite. -/
theorem secondMomentMatrix_posSemidef
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} (X : Fin n → Ω → ℝ)
    (hX : ∀ i, MemLp (X i) 2 μ) :
    (secondMomentMatrix μ X).PosSemidef := by
  rw [Matrix.posSemidef_iff_dotProduct_mulVec]
  constructor
  · apply Matrix.IsHermitian.ext
    intro i j
    simp [secondMomentMatrix, mul_comm]
  · intro x
    have hprod : ∀ i j, Integrable (fun ω => X i ω * X j ω) μ := by
      intro i j
      exact (hX i).integrable_mul (hX j)
    have hscaled : ∀ i j,
        Integrable (fun ω => x i * (X i ω * X j ω) * x j) μ := by
      intro i j
      exact ((hprod i j).const_mul (x i)).mul_const (x j)
    calc
      star x ⬝ᵥ (secondMomentMatrix μ X).mulVec x =
          ∑ i, ∑ j, ∫ ω, x i * (X i ω * X j ω) * x j ∂μ := by
            simp only [dotProduct, Matrix.mulVec, secondMomentMatrix]
            simp only [star_trivial]
            apply Finset.sum_congr rfl
            intro i _
            rw [Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro j _
            rw [integral_mul_const, integral_const_mul]
            ring
      _ = ∫ ω, ∑ i, ∑ j, x i * (X i ω * X j ω) * x j ∂μ := by
            rw [integral_finset_sum]
            · congr 1
              funext i
              rw [integral_finset_sum]
              intro j _
              exact hscaled i j
            · intro i _
              exact integrable_finset_sum _ (fun j _ => hscaled i j)
      _ = ∫ ω, (∑ i, x i * X i ω) ^ 2 ∂μ := by
            congr 1
            funext ω
            rw [pow_two, Finset.sum_mul]
            apply Finset.sum_congr rfl
            intro i _
            rw [Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro j _
            ring
      _ ≥ 0 := integral_nonneg (fun ω => sq_nonneg _)

/-- The covariance matrix, assembled coordinatewise from Mathlib's scalar covariance.

The definition is irreducible so source-facing statements retain the matrix
object instead of normalizing immediately to scalar covariance.  Its public
entrywise API is `covarianceMatrix_apply` and
`covarianceMatrix_eq_centeredOuter` below. -/
@[irreducible] def covarianceMatrix {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) : Matrix (Fin n) (Fin n) ℝ :=
  fun i j => covariance (X i) (X j) μ

/-- The covariance matrix is the expected centered outer product. -/
theorem covarianceMatrix_eq_centeredOuter
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) :
    covarianceMatrix μ X = fun i j =>
      ∫ ω, (X i ω - meanVector μ X i) * (X j ω - meanVector μ X j) ∂μ := by
  unfold covarianceMatrix meanVector
  rfl

@[simp]
theorem covarianceMatrix_apply
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) (i j : Fin n) :
    covarianceMatrix μ X i j = covariance (X i) (X j) μ := by
  unfold covarianceMatrix
  rfl

/-- On a probability space, covariance is the second moment minus the outer product of means. -/
theorem covarianceMatrix_eq_secondMoment_sub_outer
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ] (X : Fin n → Ω → ℝ)
    (hX : ∀ i, MemLp (X i) 2 μ) :
    covarianceMatrix μ X = fun i j =>
      secondMomentMatrix μ X i j - meanVector μ X i * meanVector μ X j := by
  funext i j
  rw [covarianceMatrix_apply]
  exact covariance_eq_sub (hX i) (hX j)

/-- A centered finite random vector has covariance matrix equal to its second-moment matrix. -/
theorem covarianceMatrix_eq_secondMomentMatrix
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ] (X : Fin n → Ω → ℝ)
    (hX : ∀ i, MemLp (X i) 2 μ) (hMean : meanVector μ X = 0) :
    covarianceMatrix μ X = secondMomentMatrix μ X := by
  rw [covarianceMatrix_eq_secondMoment_sub_outer X hX]
  funext i j
  have hi := congrFun hMean i
  simp [hi]

end NumStability.HDP.Vector.Covariance
