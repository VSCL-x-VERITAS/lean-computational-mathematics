import ComputationalMathematics.Source.Vershynin.Chapter04.Definition04.Contract

/-!
# Definition 4.2.4 with the owner's positive-radius ENat convention

This proof-free target retains both the strict separation predicate and the
all-subset packing supremum on arbitrary metric spaces. The value convention
and positive source radius are explicit owner qualifications. The finite/top
clauses describe that representation; they are not additional printed theorems.
The original zero-inclusive wrapper remains a separate declaration.
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Complete owner-qualified parent and its finite/infinite value interpretation. -/
def definition424OwnerQualifiedPositiveTarget : Prop :=
  ∀ (T : Type*) [MetricSpace T] (K : Set T) (ε : ℝ≥0), 0 < ε →
    (∀ N : Set T, _root_.Metric.IsSeparated ε N ↔
      ∀ x ∈ N, ∀ y ∈ N, x ≠ y → (ε : ℝ) < dist x y) ∧
    (_root_.Metric.packingNumber ε K =
      ⨆ (S : Set T) (_ : S ⊆ K) (_ : _root_.Metric.IsSeparated ε S), S.encard) ∧
    (∀ m : ℕ, _root_.Metric.packingNumber ε K = (m : ℕ∞) →
      (∃ S : Set T, S ⊆ K ∧ S.Finite ∧ _root_.Metric.IsSeparated ε S ∧
        S.encard = (m : ℕ∞)) ∧
      (∀ Q : Set T, Q ⊆ K → _root_.Metric.IsSeparated ε Q →
        Q.Finite ∧ Q.encard ≤ (m : ℕ∞))) ∧
    (_root_.Metric.packingNumber ε K = ⊤ ↔
      ∀ m : ℕ, ∃ S : Set T, S ⊆ K ∧ S.Finite ∧ _root_.Metric.IsSeparated ε S ∧
        (m : ℕ∞) ≤ S.encard) ∧
    (_root_.Metric.packingNumber ε (∅ : Set T) = 0) ∧
    (K.Nonempty → (1 : ℕ∞) ≤ _root_.Metric.packingNumber ε K)

end NumStability.HDP.Contract
