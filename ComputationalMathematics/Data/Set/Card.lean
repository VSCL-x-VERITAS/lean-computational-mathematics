import Mathlib.Data.Set.Card

/-!
# Finite admissible families without a greatest cardinality

For a family of finite sets, absence of a largest natural cardinality
implies absence of a largest exact cardinality.
-/

universe u

namespace NumStability.Set

/-- A family of finite sets with no largest natural cardinality has no
largest exact cardinality. -/
theorem cardinal_nonmaximum_of_finite_ncard_nonmaximum :
  ∀ (α : Type u) (admissible : Set α → Prop),
    (∀ S : Set α, admissible S → S.Finite) →
    (¬ ∃ S : Set α, admissible S ∧
      ∀ T : Set α, admissible T → T.ncard ≤ S.ncard) →
    ¬ ∃ S : Set α, admissible S ∧
      ∀ T : Set α, admissible T → Cardinal.mk T ≤ Cardinal.mk S := by
  intro α admissible hfinite hnonmaximum
  rintro ⟨S, hS, hgreatest⟩
  apply hnonmaximum
  refine ⟨S, hS, ?_⟩
  intro T hT
  have hcard := hgreatest T hT
  rw [← Set.cast_ncard (hfinite T hT), ← Set.cast_ncard (hfinite S hS)] at hcard
  exact Nat.cast_le.mp hcard

end NumStability.Set
