import ComputationalMathematics.HDP.Vector.BinaryLabelSwap

/-!
# From symmetric sign error to binary threshold classification

The existing normal and swapped-label inclusions transfer a sign-error bound
to the actual strict-positive/otherwise classifier. Zero coordinates remain
in scope; score negation is not identified with a label swap at zero.
-/

namespace NumStability.HDP.Vector.SignRecovery

/-- An orientation with bounded symmetric sign error supplies a bounded
classification error after an optional exchange of the two community labels. -/
theorem exists_swap_card_binaryThresholdMisclassifications_le_of_sign_disagreements
    {n : ℕ} (community : Fin n → Fin 2) (u v : Fin n → ℝ) (B : ℝ)
    (hu : ∀ i, u i = if community i = 0 then 1 else -1)
    (hsign : ∃ θ : ℝ, (θ = -1 ∨ θ = 1) ∧
      ((signDisagreements u (θ • v)).card : ℝ) ≤ B) :
    ∃ swapped : Bool,
      ((binaryThresholdMisclassifications
        (if swapped then swapBinaryCommunity community else community) v).card : ℝ) ≤ B := by
  obtain ⟨θ, hθ, hbound⟩ := hsign
  rcases hθ with rfl | rfl
  · refine ⟨true, ?_⟩
    change ((binaryThresholdMisclassifications (swapBinaryCommunity community) v).card : ℝ) ≤ B
    have hcard :
        ((binaryThresholdMisclassifications (swapBinaryCommunity community) v).card : ℝ) ≤
          ((signDisagreements u (-v)).card : ℝ) := by
      exact_mod_cast Finset.card_le_card
        (binaryThresholdMisclassifications_swap_subset_signDisagreements community u v hu)
    exact hcard.trans (by simpa only [neg_one_smul] using hbound)
  · refine ⟨false, ?_⟩
    change ((binaryThresholdMisclassifications community v).card : ℝ) ≤ B
    have hcard : ((binaryThresholdMisclassifications community v).card : ℝ) ≤
        ((signDisagreements u v).card : ℝ) := by
      exact_mod_cast Finset.card_le_card
        (binaryThresholdMisclassifications_subset_signDisagreements community u v hu)
    exact hcard.trans (by simpa only [one_smul] using hbound)

/-- Failure under both genuine label names implies failure under both sign
orientations. This implication also retains zero scores. -/
theorem forall_signs_card_signDisagreements_gt_of_forall_label_swaps
    {n : ℕ} (community : Fin n → Fin 2) (u v : Fin n → ℝ) (B : ℝ)
    (hu : ∀ i, u i = if community i = 0 then 1 else -1)
    (hbad : ∀ swapped : Bool,
      B < ((binaryThresholdMisclassifications
        (if swapped then swapBinaryCommunity community else community) v).card : ℝ)) :
    ∀ θ : ℝ, (θ = -1 ∨ θ = 1) →
      B < ((signDisagreements u (θ • v)).card : ℝ) := by
  intro θ hθ
  by_contra hnot
  obtain ⟨swapped, hbound⟩ :=
    exists_swap_card_binaryThresholdMisclassifications_le_of_sign_disagreements
      community u v B hu ⟨θ, hθ, le_of_not_gt hnot⟩
  exact (not_lt_of_ge hbound) (hbad swapped)

end NumStability.HDP.Vector.SignRecovery
