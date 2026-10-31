import ComputationalMathematics.HDP.Metric.Packing

/-!
# Packing number of a non-separated pair

A reusable finite metric packing count, transported from the existing checked
runtime producer without a new proof.
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Metric

/-- A pair that fails strict separation has packing number one. -/
theorem packingNumber_pair_eq_one_of_not_isSeparated
    {T : Type*} [PseudoEMetricSpace T] (ε : ℝ≥0) (x y : T)
    (h : ¬ Metric.IsSeparated ε ({x, y} : Set T)) :
    Metric.packingNumber ε ({x, y} : Set T) = 1 := by
  apply le_antisymm
  · simp only [Metric.packingNumber, iSup_le_iff]
    intro C hC hsep
    rcases Set.subset_pair_iff_eq.mp hC with rfl | rfl | rfl | rfl
    · simp
    · simp
    · simp
    · exact (h hsep).elim
  · simpa using
      (Metric.IsSeparated.encard_le_packingNumber
        (A := ({x, y} : Set T)) (C := ({x} : Set T)) (ε := ε)
      (by simp) (by simp))

/-- If the full pair satisfies a property of center sets, the largest
`encard` among subsets satisfying that property is the pair's `encard`. -/
theorem iSup_encard_subsets_pair_eq_encard_of_property
    {T : Type*} (x y : T) (P : Set T → Prop)
    (hpair : P ({x, y} : Set T)) :
    (⨆ (C : Set T) (_ : C ⊆ ({x, y} : Set T)) (_ : P C), C.encard) =
      ({x, y} : Set T).encard := by
  apply le_antisymm
  · refine iSup_le fun C ↦ iSup_le fun hC ↦ iSup_le fun _ ↦ ?_
    exact Set.encard_le_encard hC
  · exact le_iSup_of_le ({x, y} : Set T)
      (le_iSup_of_le (Set.Subset.rfl)
        (le_iSup_of_le hpair le_rfl))

end NumStability.HDP.Metric
