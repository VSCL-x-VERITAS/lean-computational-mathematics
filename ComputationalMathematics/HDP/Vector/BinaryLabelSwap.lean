import ComputationalMathematics.HDP.Vector.SignRecovery

/-!
# Binary output-label permutations

The strict-positive/otherwise classifier is not equivariant under score
negation at zero.  This module separates a genuine exchange of output labels
from negating a score vector and connects the exact classifier to the
symmetric sign-disagreement bound.
-/

namespace NumStability.HDP.Vector.SignRecovery

/-- Exchange the names of the two communities. -/
def swapBinaryCommunity {n : ℕ} (community : Fin n → Fin 2) : Fin n → Fin 2 :=
  fun i ↦ if community i = 0 then 1 else 0

/-- Errors after a genuine exchange of the two output labels are controlled
by the symmetric sign-disagreement set for the negated score.  The inclusion
is intentionally conservative at zero coordinates. -/
theorem binaryThresholdMisclassifications_swap_subset_signDisagreements
    {n : ℕ} (community : Fin n → Fin 2) (u v : Fin n → ℝ)
    (hu : ∀ i, u i = if community i = 0 then 1 else -1) :
    binaryThresholdMisclassifications (swapBinaryCommunity community) v ⊆
      signDisagreements u (-v) := by
  intro i hi
  simp only [binaryThresholdMisclassifications, Finset.mem_filter,
    Finset.mem_univ, true_and] at hi
  simp only [signDisagreements, Finset.mem_filter, Finset.mem_univ, true_and]
  rw [hu i]
  by_cases h : community i = 0
  · simp [swapBinaryCommunity, h] at hi ⊢
    linarith
  · simp [swapBinaryCommunity, h] at hi ⊢
    exact hi

end NumStability.HDP.Vector.SignRecovery
