import ComputationalMathematics.HDP.Metric.BoundedEuclideanCoverPacking

/-!
# Qualified bounded Euclidean selection of Lemma 4.2.8

This alias records only the selected bounded, positive-dimensional real
Euclidean case of Vershynin’s Lemma 4.2.8. The set may be empty, infinite,
or nonclosed; all optimized counts are attained finite natural numbers.
It does not supply correspondence for the unrestricted metric-space claim,
an unrestricted infinity convention, or the source’s proof account.
-/

open scoped NNReal ENNReal

namespace NumStability.HDP.Contract

/-- The qualified bounded Euclidean numerical-extrema selection of
Vershynin, *High-Dimensional Probability*, Lemma 4.2.8. -/
theorem hdp_04_lemma_4_2_8_bounded_euclidean_numerical_extrema :
  ∀ n : ℕ, 0 < n →
    ∀ K : Set (EuclideanSpace ℝ (Fin n)), Bornology.IsBounded K →
      ∀ ε : ℝ≥0, 0 < ε →
        ∃ (coverCount packCount doublePackCount : ℕ)
          (C P Q : Set (EuclideanSpace ℝ (Fin n))),
          C ⊆ K ∧ C.Finite ∧ Metric.IsCover ε K C ∧
          C.encard = (coverCount : ℕ∞) ∧
          Metric.coveringNumber ε K = (coverCount : ℕ∞) ∧
          P ⊆ K ∧ P.Finite ∧ Metric.IsSeparated (ε : ℝ≥0∞) P ∧
          P.encard = (packCount : ℕ∞) ∧
          Metric.packingNumber ε K = (packCount : ℕ∞) ∧
          Q ⊆ K ∧ Q.Finite ∧ Metric.IsSeparated ((2 * ε : ℝ≥0) : ℝ≥0∞) Q ∧
          Q.encard = (doublePackCount : ℕ∞) ∧
          Metric.packingNumber (2 * ε) K = (doublePackCount : ℕ∞) ∧
          doublePackCount ≤ coverCount ∧ coverCount ≤ packCount :=
  NumStability.HDP.Metric.exists_euclidean_cover_packing_extrema

end NumStability.HDP.Contract
