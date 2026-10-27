/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BilateralRiemannChainSelection
import Mathlib.Order.Monotone.Basic
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainAffineFronts

/-!
# Bilateral selection from separated wave fronts

Ordered adjacent separated fronts place every other profile in a constant
exterior state. The actual bilateral assembly therefore selects a local
profile inside its open fan and a reconstructed state in each open gap.
An initially strict affine gap remains nonnegative through endpoint contact.
-/

namespace NumStability

theorem affine_front_gap_on_closed_interval (a b u v horizon time : ℝ)
    (hinitial : a < b) (hfinal : a + u * horizon ≤ b + v * horizon)
    (htime : time ∈ Set.Icc 0 horizon) : a + u * time ≤ b + v * time := by
  rcases lt_or_eq_of_le htime.2 with hlt | rfl
  · exact (affine_front_gap_before_horizon a b u v horizon time hinitial hfinal ⟨htime.1, hlt⟩).le
  · exact hfinal


theorem integer_fronts_right_lt_of_left_lt
    (left right : ℤ → ℝ) (horder : ∀ j, left j ≤ right j)
    (hseparate : ∀ j, right j ≤ left (j + 1))
    (j cell : ℤ) (hj : j < cell) (x : ℝ) (hx : left cell < x) : right j < x := by
  have hmono : Monotone left := monotone_int_of_le_succ (fun k => (horder k).trans (hseparate k))
  exact ((hseparate j).trans (hmono (by omega))).trans_lt hx

theorem integer_fronts_lt_left_of_lt_right
    (left right : ℤ → ℝ) (horder : ∀ j, left j ≤ right j)
    (hseparate : ∀ j, right j ≤ left (j + 1))
    (cell j : ℤ) (hj : cell < j) (x : ℝ) (hx : x < right cell) : x < left j := by
  have hmono : Monotone left := monotone_int_of_le_succ (fun k => (horder k).trans (hseparate k))
  exact hx.trans_le ((hseparate cell).trans (hmono (by omega)))

theorem bilateralRiemannChainAssembly_eq_profile_of_ordered_fronts
    {E : Type*} [AddCommGroup E] (states profiles : ℤ → E)
    (hfinite : ∃ radius, IsRiemannChainWindow states profiles radius)
    (left right : ℤ → ℝ) (horder : ∀ j, left j ≤ right j)
    (hseparate : ∀ j, right j ≤ left (j + 1)) (x : ℝ)
    (hleft : ∀ j, x < left j → profiles j = states j)
    (hright : ∀ j, right j < x → profiles j = states (j + 1))
    (cell : ℤ) (hx : x ∈ Set.Ioo (left cell) (right cell)) :
    bilateralRiemannChainAssembly states profiles hfinite = profiles cell := by
  apply bilateralRiemannChainAssembly_eq_profile states profiles hfinite cell
  · intro j hj
    exact hright j (integer_fronts_right_lt_of_left_lt left right horder hseparate j cell hj x hx.1)
  · intro j hj
    exact hleft j (integer_fronts_lt_left_of_lt_right left right horder hseparate cell j hj x hx.2)

theorem bilateralRiemannChainAssembly_eq_state_of_ordered_fronts
    {E : Type*} [AddCommGroup E] (states profiles : ℤ → E)
    (hfinite : ∃ radius, IsRiemannChainWindow states profiles radius)
    (left right : ℤ → ℝ) (horder : ∀ j, left j ≤ right j)
    (hseparate : ∀ j, right j ≤ left (j + 1)) (x : ℝ)
    (hleft : ∀ j, x < left j → profiles j = states j)
    (hright : ∀ j, right j < x → profiles j = states (j + 1))
    (cell : ℤ) (hx : x ∈ Set.Ioo (right (cell - 1)) (left cell)) :
    bilateralRiemannChainAssembly states profiles hfinite = states cell := by
  have hmonoL : Monotone left := monotone_int_of_le_succ (fun k => (horder k).trans (hseparate k))
  have hmonoR : Monotone right := monotone_int_of_le_succ (fun k => (hseparate k).trans (horder (k + 1)))
  apply bilateralRiemannChainAssembly_eq_state states profiles hfinite cell
  · intro j hj
    exact hright j ((hmonoR (by omega)).trans_lt hx.1)
  · intro j hj
    exact hleft j (hx.2.trans_le (hmonoL hj))

end NumStability
