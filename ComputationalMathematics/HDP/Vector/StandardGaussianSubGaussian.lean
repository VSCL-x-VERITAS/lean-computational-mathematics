import ComputationalMathematics.HDP.Vector.Gaussian
import ComputationalMathematics.HDP.Vector.SubGaussianDomination
import ComputationalMathematics.HDP.Scalar.SubGaussianDomination

/-!
# Standard Gaussian vectors are sub-Gaussian

This module packages the canonical product Gaussian law as a vector-level
sub-Gaussian example.  Every unit marginal is exactly `N(0,1)`, so the scalar
Gaussian `ψ₂` bound gives a dimension-free vector bound.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.Gaussian

open NumStability.HDP

/-- The coordinate process on the canonical product Gaussian measure is
standard normal. -/
theorem canonical_isStandardNormal (n : ℕ) :
    IsStandardNormal
      (NumStability.standardGaussianVectorMeasure n)
      (fun i x ↦ x i) := by
  simpa using
    (ProbabilityTheory.HasLaw.id
      (μ := NumStability.standardGaussianVectorMeasure n))

/-- A unit linear marginal of the canonical standard-Gaussian vector has
the one-dimensional standard normal law. -/
theorem unitWeightedGaussianLaw {n : ℕ}
    (u : Vector.SubGaussian.UnitDirection n) :
    HasLaw
      (fun x : Fin n → ℝ ↦ ∑ i, u.1 i * x i)
      (gaussianReal 0 1)
      (NumStability.standardGaussianVectorMeasure n) := by
  have h := Scalar.SubGaussian.independentGaussianWeightedSumLaw
    (μ := NumStability.standardGaussianVectorMeasure n)
    (X := fun i x ↦ x i) u.1
    (fun i ↦ NumStability.standardGaussianVectorCoordinate_hasLaw n i)
    (NumStability.standardGaussianVectorCoordinates_iIndep n)
  have hsquares : ∑ i : Fin n, u.1 i ^ 2 = 1 := by
    calc
      ∑ i : Fin n, u.1 i ^ 2 = NumStability.vecNorm2Sq u.1 := rfl
      _ = NumStability.vecNorm2 u.1 ^ 2 := (NumStability.vecNorm2_sq u.1).symm
      _ = 1 := by rw [u.2]; norm_num
  convert h using 1
  congr 2
  apply NNReal.eq
  simp [Real.toNNReal_of_nonneg (sq_nonneg _), hsquares]

/-- The canonical standard-Gaussian vector has vector `ψ₂` norm at most two,
uniformly in its dimension. -/
theorem standardGaussianVector_psiTwoNorm_le_two (n : ℕ) :
    Vector.SubGaussian.PsiTwoNorm
        (NumStability.standardGaussianVectorMeasure n)
        (fun i x ↦ x i) ≤ ENNReal.ofReal 2 := by
  unfold Vector.SubGaussian.PsiTwoNorm
  refine iSup_le ?_
  intro u
  have hmarg : Vector.linearMarginal (fun i (x : Fin n → ℝ) ↦ x i) u.1 =
      fun x : Fin n → ℝ ↦ ∑ i, u.1 i * x i := by
    funext x
    unfold Vector.linearMarginal
    apply Finset.sum_congr rfl
    intro i _
    ring
  rw [hmarg]
  rw [Scalar.SubGaussian.psiTwoNorm_eq_of_hasLaw (by fun_prop)
    (unitWeightedGaussianLaw u)]
  simpa [Scalar.SubGaussian.PsiTwoNorm] using
    Scalar.SubGaussian.gaussianPsiTwoGauge_le_two_mul.1

/-- Section 3.4.1's standard-Gaussian example: the canonical vector is
sub-Gaussian and has a dimension-free vector `ψ₂` bound. -/
theorem standardGaussianVector_isSubGaussian_psiTwoNorm_le_two (n : ℕ) :
    Vector.SubGaussian.IsSubGaussian
        (NumStability.standardGaussianVectorMeasure n)
        (fun i x ↦ x i) ∧
      Vector.SubGaussian.PsiTwoNorm
        (NumStability.standardGaussianVectorMeasure n)
        (fun i x ↦ x i) ≤ ENNReal.ofReal 2 := by
  have hle := standardGaussianVector_psiTwoNorm_le_two n
  exact ⟨Vector.SubGaussian.isSubGaussian_of_psiTwoNorm_lt_top
      (hle.trans_lt ENNReal.ofReal_lt_top), hle⟩

end NumStability.HDP.Vector.Gaussian
