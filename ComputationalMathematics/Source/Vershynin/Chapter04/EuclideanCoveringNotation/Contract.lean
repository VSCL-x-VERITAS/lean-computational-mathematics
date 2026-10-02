import ComputationalMathematics.HDP.Metric.Euclidean

/-!
# Vershynin Chapter 4, Euclidean covering-number notation

Source contract for omitting the understood Euclidean metric from covering
number notation.
-/

open Set
open scoped NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Section 4.2.1: in `ℝⁿ`, suppressing the understood
Euclidean metric does not change the admissible internal covers.  Thus the
abbreviation `N(K, ε)` and the metric notation `N(K, d, ε)` minimize over
the same center sets with the same cardinalities. -/
theorem hdp_04_euclidean_covering_notation {n : ℕ}
    (K : Set (EuclideanSpace ℝ (Fin n))) (ε : ℝ≥0) (_hε : 0 < ε) :
    NumStability.HDP.Metric.euclideanCoveringNumber K ε =
        (⨅ C : Set (EuclideanSpace ℝ (Fin n)),
          ⨅ (_hCK : C ⊆ K), ⨅ (_hCcover : _root_.Metric.IsCover ε K C), C.encard) ∧
      ∀ N : Set (EuclideanSpace ℝ (Fin n)), N ⊆ K →
        ((∀ ⦃x⦄, x ∈ K → ∃ y ∈ N, ‖x - y‖ ≤ (ε : ℝ)) ↔
          ∀ ⦃x⦄, x ∈ K → ∃ y ∈ N, dist x y ≤ (ε : ℝ)) := by
  refine ⟨rfl, ?_⟩
  intro N _hNK
  simp only [dist_eq_norm]

end NumStability.HDP.Contract
