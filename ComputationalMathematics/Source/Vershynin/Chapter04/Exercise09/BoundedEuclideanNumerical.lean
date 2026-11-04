import ComputationalMathematics.HDP.Metric.BoundedEuclideanExternalCovering

/-! # Exercise 4.2.9: qualified bounded Euclidean numerical minima

This alias records only the selected bounded subsets of positive-dimensional
real Euclidean space at positive radius. Empty, infinite and nonclosed bounded
sets are included. It makes no claim about the unrestricted metric-space
exercise or its unspecified global infinity convention.
-/

open scoped NNReal ENNReal

namespace NumStability.HDP.Contract

/-- The bounded positive-dimensional real Euclidean selection of Exercise 4.2.9,
with finite natural minima and actual ambient/internal center sets. -/
theorem hdp_04_exercise_4_2_9_bounded_euclidean_numerical_minima :
  ∀ n : ℕ, 0 < n →
    ∀ K : Set (EuclideanSpace ℝ (Fin n)), Bornology.IsBounded K →
      ∀ ε : ℝ≥0, 0 < ε →
        ∃ (externalCount internalCount halfExternalCount : ℕ)
          (E C H : Set (EuclideanSpace ℝ (Fin n))),
          E.Finite ∧ Metric.IsCover ε K E ∧
          E.encard = (externalCount : ℕ∞) ∧
          Metric.externalCoveringNumber ε K = (externalCount : ℕ∞) ∧
          C ⊆ K ∧ C.Finite ∧ Metric.IsCover ε K C ∧
          C.encard = (internalCount : ℕ∞) ∧
          Metric.coveringNumber ε K = (internalCount : ℕ∞) ∧
          H.Finite ∧ Metric.IsCover (ε / 2) K H ∧
          H.encard = (halfExternalCount : ℕ∞) ∧
          Metric.externalCoveringNumber (ε / 2) K = (halfExternalCount : ℕ∞) ∧
          externalCount ≤ internalCount ∧ internalCount ≤ halfExternalCount :=
  NumStability.HDP.Metric.exists_euclidean_external_covering_minima

end NumStability.HDP.Contract

