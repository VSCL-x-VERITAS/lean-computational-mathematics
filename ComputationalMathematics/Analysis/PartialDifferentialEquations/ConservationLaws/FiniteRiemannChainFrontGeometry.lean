/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainGeometry

open MeasureTheory
/-!
# Finite Riemann-chain front geometry

Strict separation before a nonstrict CFL horizon gives ordered profiles with arbitrary front values and an almost-everywhere temporal pattern at every face.
-/

namespace NumStability

/-- Strictly separated closed wave intervals allow arbitrary values on
the fronts: at most one local profile can be active at any point. -/
theorem isOrderedFiniteRiemannChain_of_strictly_separated_intervals
    {E : Type*} (states profiles : ℕ → E) (leftEdge rightEdge : ℕ → ℝ)
    (count : ℕ) (x : ℝ)
    (hseparated : ∀ i j, i < j → j < count → rightEdge i < leftEdge j)
    (hleft : ∀ j < count, x < leftEdge j → profiles j = states j)
    (hright : ∀ j < count, rightEdge j < x → profiles j = states (j + 1)) :
    IsOrderedFiniteRiemannChain states profiles count := by
  induction count with
  | zero => exact Or.inl ⟨0, le_rfl, by omega, by omega⟩
  | succ n ih =>
    by_cases hx : x < leftEdge n
    · have hp := ih (fun i j hij hj => hseparated i j hij (by omega))
        (fun j hj => hleft j (by omega)) (fun j hj => hright j (by omega))
      rcases hp with ⟨k, hk, hbefore, hafter⟩ | ⟨k, hk, hbefore, hafter⟩
      · left
        refine ⟨k, by omega, hbefore, ?_⟩
        intro j hj hjn
        by_cases hjn' : j < n
        · exact hafter j hj hjn'
        · have : j = n := by omega
          subst j
          exact hleft n (by omega) hx
      · right
        refine ⟨k, by omega, hbefore, ?_⟩
        intro j hj hjn
        by_cases hjn' : j < n
        · exact hafter j hj hjn'
        · have : j = n := by omega
          subst j
          exact hleft n (by omega) hx
    · have hxn : leftEdge n ≤ x := le_of_not_gt hx
      have hbefore : ∀ j < n, profiles j = states (j + 1) := by
        intro j hj
        exact hright j (by omega) ((hseparated j n hj (by omega)).trans_le hxn)
      by_cases hxr : rightEdge n < x
      · left
        refine ⟨n + 1, le_rfl, ?_, by omega⟩
        intro j hj
        by_cases hjn : j < n
        · exact hbefore j hjn
        · have : j = n := by omega
          subst j
          exact hright n (by omega) hxr
      · right
        exact ⟨n, by omega, hbefore, by omega⟩

/-- Before the last time of a nonstrict cone CFL step, the closed cones
are strictly separated, so their front representatives may be arbitrary. -/
theorem isOrderedFiniteRiemannChain_of_uniform_cones_before_horizon
    {E : Type*} (states profiles : ℕ → E) (count : ℕ)
    (width bound horizon x time : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (htime : time ∈ Set.Ico 0 horizon) (hcfl : 2 * bound * horizon ≤ width)
    (hleft : ∀ j < count, x < (j : ℝ) * width - bound * time → profiles j = states j)
    (hright : ∀ j < count, (j : ℝ) * width + bound * time < x →
      profiles j = states (j + 1)) :
    IsOrderedFiniteRiemannChain states profiles count := by
  have hcfl' : 2 * bound * time < width := by
    by_cases hb0 : bound = 0
    · subst bound
      simpa using hwidth
    · have hbpos : 0 < bound := lt_of_le_of_ne hbound (Ne.symm hb0)
      have hbt := mul_lt_mul_of_pos_left htime.2 hbpos
      nlinarith
  apply isOrderedFiniteRiemannChain_of_strictly_separated_intervals states profiles
    (fun j => (j : ℝ) * width - bound * time)
    (fun j => (j : ℝ) * width + bound * time) count x
  · intro i j hij _
    have hcast : (i : ℝ) + 1 ≤ (j : ℝ) := by exact_mod_cast (Nat.succ_le_iff.mpr hij)
    have hgap := mul_le_mul_of_nonneg_right hcast hwidth.le
    nlinarith
  · exact hleft
  · exact hright

/-- Nonstrict cone CFL gives the profile pattern almost everywhere in
time at each face, without choosing values at any wave front. -/
theorem isOrderedFiniteRiemannChain_of_uniform_cones_ae_time
    {E : Type*} (states : ℕ → E) (fields : ℕ → ℝ → ℝ → E) (count : ℕ)
    (width bound horizon x : ℝ) (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hcfl : 2 * bound * horizon ≤ width)
    (hleft : ∀ j < count, ∀ τ ∈ Set.Icc 0 horizon,
      x < (j : ℝ) * width - bound * τ → fields j x τ = states j)
    (hright : ∀ j < count, ∀ τ ∈ Set.Icc 0 horizon,
      (j : ℝ) * width + bound * τ < x → fields j x τ = states (j + 1)) :
    ∀ᵐ τ ∂volume, τ ∈ Set.Icc 0 horizon →
      IsOrderedFiniteRiemannChain states (fun j => fields j x τ) count := by
  filter_upwards [volume.ae_ne horizon] with τ hne ht
  exact isOrderedFiniteRiemannChain_of_uniform_cones_before_horizon states
    (fun j => fields j x τ) count width bound horizon x τ hwidth hbound
    ⟨ht.1, lt_of_le_of_ne ht.2 hne⟩ hcfl
    (fun j hj => hleft j hj τ ht) (fun j hj => hright j hj τ ht)

end NumStability
