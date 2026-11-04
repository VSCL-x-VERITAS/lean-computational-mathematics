import ComputationalMathematics.HDP.Metric.CoveringCardinalEncoding
import Mathlib.Analysis.InnerProductSpace.PiL2

/-!
# Vershynin Chapter 4, positive-radius Euclidean covering value

Definition 4.2.2 and Section 4.2.1 give the smallest cardinality of a complete
internal net at a positive radius. The explicit cardinal decoding retains that
minimum throughout finite-dimensional Euclidean space, including cases without
a finite net. The separate unrestricted source API remains available.
-/

open Set
open scoped NNReal

namespace NumStability.HDP.Contract

/-- Decode the extended-natural covering number as the literal least
cardinality of the complete internal Euclidean norm-net family. -/
def HDP04EuclideanPositiveCoveringValue : Prop :=
  ∀ (n : ℕ) (K : Set (EuclideanSpace ℝ (Fin n))) (ε : ℝ≥0), 0 < ε →
    (_root_.Metric.coveringNumber ε K : Cardinal) =
      sInf {c : Cardinal |
        ∃ N : Set (EuclideanSpace ℝ (Fin n)), N ⊆ K ∧
          (∀ x ∈ K, ∃ y ∈ N, ‖x - y‖ ≤ (ε : ℝ)) ∧ c = Cardinal.mk N}

/-- Reuse the existing positive-radius countable-domain inverse and the
norm-distance identity; there is no new minimum or net construction. -/
theorem hdp_04_euclidean_positive_covering_value :
    HDP04EuclideanPositiveCoveringValue := by
  intro n K ε hε
  rw [← NumStability.HDP.Metric.internalCoveringCardinal_eq_ofENat_coveringNumber K hε]
  simp only [NumStability.HDP.Metric.internalCoveringCardinal,
    NumStability.HDP.Metric.internalCoverCardinals, dist_eq_norm]

end NumStability.HDP.Contract
