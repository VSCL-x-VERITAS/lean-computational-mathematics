import ComputationalMathematics.HDP.Vector.GaussianMixtureBinaryPartition

/-!
# Pair relations and exact binary partition agreement

Ordinary mathematics for signed labels and arbitrary predicate outputs.
No author error predicate, selector, event convention or source claim is chosen.
-/

noncomputable section

namespace NumStability.HDP.Vector.GaussianMixture

/-- A binary output with the same pair relation as signed labels agrees with
one global label orientation, including an empty index domain. -/
theorem exists_binary_label_orientation_of_pairwise_agreement {ι : Type*}
    (labels : ι → ℝ) (output : ι → Prop)
    (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (hpair : ∀ i j, (output i ↔ output j) ↔ labels i = labels j) :
    ∃ firstLabel : ℝ, (firstLabel = -1 ∨ firstLabel = 1) ∧
      ∀ i, output i ↔ labels i = firstLabel := by
  classical
  by_cases hhas : Nonempty ι
  · obtain ⟨a⟩ := hhas
    by_cases ha : output a
    · refine ⟨labels a, hlabels a, ?_⟩
      intro i
      simpa only [ha, iff_true] using hpair i a
    · refine ⟨-labels a, ?_, ?_⟩
      · rcases hlabels a with hlabel | hlabel <;> simp [hlabel]
      · intro i
        have hrel : (¬ output i) ↔ labels i = labels a := by
          simpa only [ha, iff_false] using hpair i a
        rcases hlabels a with haLabel | haLabel <;>
          rcases hlabels i with hiLabel | hiLabel <;>
            norm_num [haLabel, hiLabel] at hrel ⊢ <;> tauto
  · refine ⟨1, Or.inr rfl, ?_⟩
    intro i
    exact (hhas ⟨i⟩).elim

/-- Pairwise agreement of binary labels gives zero mismatches after one global
orientation, hence every nonnegative real error budget. -/
theorem makesAtMostBinaryPartitionErrorsUpToSwap_of_pairwise_agreement
    {m : ℕ} (labels : Fin m → ℝ) (output : Fin m → Prop)
    (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (hpair : ∀ i j, (output i ↔ output j) ↔ labels i = labels j)
    {budget : ℝ} (hbudget : 0 ≤ budget) :
    MakesAtMostBinaryPartitionErrorsUpToSwap labels output budget := by
  obtain ⟨firstLabel, hfirst, hcorrect⟩ :=
    exists_binary_label_orientation_of_pairwise_agreement labels output hlabels hpair
  refine ⟨firstLabel, hfirst, ?_⟩
  have hempty : {i | ¬ (output i ↔ labels i = firstLabel)} = (∅ : Set (Fin m)) := by
    ext i
    simp [hcorrect i]
  simpa only [hempty, Set.ncard_empty, Nat.cast_zero] using hbudget

/-- For a nonnegative budget below one, the existing binary mismatch predicate
is equivalent to equality of all pair relations. -/
theorem binaryPartitionErrors_lt_one_iff_pairwise_agreement
    {m : ℕ} (labels : Fin m → ℝ) (output : Fin m → Prop)
    (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    {budget : ℝ} (hbudget_nonneg : 0 ≤ budget) (hbudget_lt_one : budget < 1) :
    MakesAtMostBinaryPartitionErrorsUpToSwap labels output budget ↔
      ∀ i j, (output i ↔ output j) ↔ labels i = labels j := by
  constructor
  · intro h i j
    exact sameCluster_iff_labels_eq_of_binaryPartitionErrors_lt_one
      labels output hlabels hbudget_lt_one h i j
  · intro h
    exact makesAtMostBinaryPartitionErrorsUpToSwap_of_pairwise_agreement
      labels output hlabels h hbudget_nonneg

end NumStability.HDP.Vector.GaussianMixture
