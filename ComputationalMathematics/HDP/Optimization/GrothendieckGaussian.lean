import ComputationalMathematics.HDP.Vector.LinearMarginals

/-!
# Gaussian realization of finite bilinear forms

This module packages the expectation identity used in the probabilistic proof
of Grothendieck's inequality: standard-Gaussian linear marginals reproduce the
Euclidean inner products of their coefficient vectors.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Optimization

/-- The expectation of a finite coefficient-weighted product of standard-
Gaussian linear marginals is the same coefficient-weighted Euclidean dot
product. -/
theorem integral_standardGaussian_bilinear_sum
    {d m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ)
    (u : Fin m → Fin d → ℝ) (v : Fin n → Fin d → ℝ) :
    (∫ g : Fin d → ℝ,
        ∑ i, ∑ j, A i j *
          NumStability.HDP.Vector.linearMarginal (fun k x ↦ x k) (u i) g *
          NumStability.HDP.Vector.linearMarginal (fun k x ↦ x k) (v j) g
        ∂NumStability.standardGaussianVectorMeasure d) =
      ∑ i, ∑ j, A i j * ∑ k, u i k * v j k := by
  have hpair (i : Fin m) (j : Fin n) :
      (∫ g : Fin d → ℝ,
          NumStability.HDP.Vector.linearMarginal (fun k x ↦ x k) (u i) g *
            NumStability.HDP.Vector.linearMarginal (fun k x ↦ x k) (v j) g
          ∂NumStability.standardGaussianVectorMeasure d) =
        ∑ k, u i k * v j k := by
    exact
      NumStability.HDP.Vector.Gaussian.integral_linearMarginal_mul_linearMarginal_of_isStandardNormal
        (by simpa using
          (ProbabilityTheory.HasLaw.id
            (μ := NumStability.standardGaussianVectorMeasure d)))
        (u i) (v j)
  rw [integral_finset_sum]
  · apply Finset.sum_congr rfl
    intro i _
    rw [integral_finset_sum]
    · apply Finset.sum_congr rfl
      intro j _
      rw [show (fun g : Fin d → ℝ =>
          A i j * NumStability.HDP.Vector.linearMarginal (fun k x ↦ x k) (u i) g *
            NumStability.HDP.Vector.linearMarginal (fun k x ↦ x k) (v j) g) =
          (fun g => A i j *
            (NumStability.HDP.Vector.linearMarginal (fun k x ↦ x k) (u i) g *
             NumStability.HDP.Vector.linearMarginal (fun k x ↦ x k) (v j) g)) by
              funext g; ring,
        integral_const_mul, hpair]
    · intro j _
      have hu : MemLp
          (NumStability.HDP.Vector.linearMarginal (fun k (x : Fin d → ℝ) ↦ x k) (u i)) 2
          (NumStability.standardGaussianVectorMeasure d) := by
        unfold NumStability.HDP.Vector.linearMarginal
        apply memLp_finset_sum
        intro k _
        exact (NumStability.standardGaussianVectorCoordinate_memLp_two d k).mul_const _
      have hv : MemLp
          (NumStability.HDP.Vector.linearMarginal (fun k (x : Fin d → ℝ) ↦ x k) (v j)) 2
          (NumStability.standardGaussianVectorMeasure d) := by
        unfold NumStability.HDP.Vector.linearMarginal
        apply memLp_finset_sum
        intro k _
        exact (NumStability.standardGaussianVectorCoordinate_memLp_two d k).mul_const _
      simpa only [mul_assoc] using (hu.integrable_mul hv).const_mul (A i j)
  · intro i _
    apply integrable_finset_sum
    intro j _
    have hu : MemLp
        (NumStability.HDP.Vector.linearMarginal (fun k (x : Fin d → ℝ) ↦ x k) (u i)) 2
        (NumStability.standardGaussianVectorMeasure d) := by
      unfold NumStability.HDP.Vector.linearMarginal
      apply memLp_finset_sum
      intro k _
      exact (NumStability.standardGaussianVectorCoordinate_memLp_two d k).mul_const _
    have hv : MemLp
        (NumStability.HDP.Vector.linearMarginal (fun k (x : Fin d → ℝ) ↦ x k) (v j)) 2
        (NumStability.standardGaussianVectorMeasure d) := by
      unfold NumStability.HDP.Vector.linearMarginal
      apply memLp_finset_sum
      intro k _
      exact (NumStability.standardGaussianVectorCoordinate_memLp_two d k).mul_const _
    simpa only [mul_assoc] using (hu.integrable_mul hv).const_mul (A i j)

end NumStability.HDP.Optimization
