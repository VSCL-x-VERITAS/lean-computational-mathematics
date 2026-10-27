/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainAffineFronts

/-!
# Finite Riemann-chain spatial profile patterns

Nonstrict affine-front noninteraction gives spatial ordered patterns almost everywhere, allowing arbitrary initial and touching final front representatives.
-/

open MeasureTheory
namespace NumStability

/-- Nonstrictly separated intervals yield the ordered pattern almost
everywhere in space, allowing arbitrary representatives at their fronts. -/
theorem isOrderedFiniteRiemannChain_of_separated_intervals_ae_space
    {E : Type*} (states : ℕ → E) (profiles : ℕ → ℝ → E)
    (leftEdge rightEdge : ℕ → ℝ) (count : ℕ)
    (hinterval : ∀ j < count, leftEdge j ≤ rightEdge j)
    (hseparated : ∀ i j, i < j → j < count → rightEdge i ≤ leftEdge j)
    (hleft : ∀ j < count, ∀ x, x < leftEdge j → profiles j x = states j)
    (hright : ∀ j < count, ∀ x, rightEdge j < x → profiles j x = states (j + 1)) :
    ∀ᵐ x ∂volume, IsOrderedFiniteRiemannChain states (fun j => profiles j x) count := by
  have hfronts : ∀ j : ℕ, ∀ᵐ x ∂volume, x ≠ rightEdge j := fun j => volume.ae_ne _
  filter_upwards [ae_all_iff.mpr hfronts] with x hx
  apply isOrderedFiniteRiemannChain_of_separated_intervals states (fun j => profiles j x)
    leftEdge rightEdge count x hinterval hseparated
  · exact fun j hj h => hleft j hj x h
  · exact fun j hj h => hright j hj x (lt_of_le_of_ne h (Ne.symm (hx j)))

/-- Actual affine-front noninteraction gives the spatial profile pattern
at every time in the closed step, including touching final fronts. -/
theorem isOrderedFiniteRiemannChain_of_affine_fronts_ae_space
    {E : Type*} (states : ℕ → E) (fields : ℕ → ℝ → ℝ → E)
    (centers leftSpeed rightSpeed : ℕ → ℝ) (count : ℕ) (horizon time : ℝ)
    (hcenters : ∀ i j, i < j → j < count → centers i < centers j)
    (hspeeds : ∀ j < count, leftSpeed j ≤ rightSpeed j)
    (htime : time ∈ Set.Icc 0 horizon)
    (hinteraction : ∀ j, j + 1 < count →
      centers j + rightSpeed j * horizon ≤ centers (j + 1) + leftSpeed (j + 1) * horizon)
    (hleft : ∀ j < count, ∀ x,
      x < centers j + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ j < count, ∀ x,
      centers j + rightSpeed j * time < x → fields j x time = states (j + 1)) :
    ∀ᵐ x ∂volume, IsOrderedFiniteRiemannChain states (fun j => fields j x time) count := by
  have hhorizon : 0 ≤ horizon := htime.1.trans htime.2
  have hend := finite_intervals_pairwise_separated_of_adjacent
    (fun j => centers j + leftSpeed j * horizon)
    (fun j => centers j + rightSpeed j * horizon) count
    (fun j hj => by
      have := mul_le_mul_of_nonneg_right (hspeeds j hj) hhorizon
      dsimp only
      linarith) hinteraction
  apply isOrderedFiniteRiemannChain_of_separated_intervals_ae_space states
    (fun j x => fields j x time)
    (fun j => centers j + leftSpeed j * time)
    (fun j => centers j + rightSpeed j * time) count
  · intro j hj
    have := mul_le_mul_of_nonneg_right (hspeeds j hj) htime.1
    linarith
  · intro i j hij hj
    by_cases ht : time = horizon
    · subst time
      exact hend i j hij hj
    · exact (affine_front_gap_before_horizon _ _ _ _ _ _ (hcenters i j hij hj)
        (hend i j hij hj) ⟨htime.1, lt_of_le_of_ne htime.2 ht⟩).le
  · exact hleft
  · exact hright

end NumStability
