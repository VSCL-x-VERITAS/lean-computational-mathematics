/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainFrontGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainRectangleAE

/-!
# Finite Riemann chains with asymmetric affine fronts

Actual adjacent-wave noninteraction with arbitrary signed asymmetric speeds constructs local nonlinear-vector conservation; strict initial gaps permit free representatives where fronts meet at the horizon.
-/

open MeasureTheory
namespace NumStability

/-- An initially strict affine gap stays strict before a nonnegative
endpoint gap, with no absolute speed or half-Courant restriction. -/
theorem affine_front_gap_before_horizon (a b u v horizon time : ℝ)
    (hinitial : a < b) (hfinal : a + u * horizon ≤ b + v * horizon)
    (htime : time ∈ Set.Ico 0 horizon) : a + u * time < b + v * time := by
  by_cases huv : u ≤ v
  · have := mul_le_mul_of_nonneg_right huv htime.1
    linarith
  · have hpositive : 0 < u - v := sub_pos.mpr (lt_of_not_ge huv)
    have := mul_lt_mul_of_pos_left htime.2 hpositive
    nlinarith

/-- Adjacent ordered intervals suffice for every ordered pair. -/
theorem finite_intervals_pairwise_separated_of_adjacent
    (leftEdge rightEdge : ℕ → ℝ) (count : ℕ)
    (hinterval : ∀ j < count, leftEdge j ≤ rightEdge j)
    (hadjacent : ∀ j, j + 1 < count → rightEdge j ≤ leftEdge (j + 1)) :
    ∀ i j, i < j → j < count → rightEdge i ≤ leftEdge j := by
  intro i j hij hj
  have hle : i + 1 ≤ j := by omega
  induction j, hle using Nat.le_induction with
  | base => exact hadjacent i hj
  | succ j hij ih =>
    exact (ih (by omega) (by omega)).trans ((hinterval j (by omega)).trans (hadjacent j hj))

/-- Actual adjacent wave noninteraction at the horizon constructs the
ordered profile pattern before that horizon for asymmetric wave speeds. -/
theorem isOrderedFiniteRiemannChain_of_affine_fronts_before_horizon
    {E : Type*} (states profiles : ℕ → E) (centers leftSpeed rightSpeed : ℕ → ℝ)
    (count : ℕ) (horizon time x : ℝ)
    (hcenters : ∀ i j, i < j → j < count → centers i < centers j)
    (hspeeds : ∀ j < count, leftSpeed j ≤ rightSpeed j)
    (htime : time ∈ Set.Ico 0 horizon)
    (hinteraction : ∀ j, j + 1 < count →
      centers j + rightSpeed j * horizon ≤ centers (j + 1) + leftSpeed (j + 1) * horizon)
    (hleft : ∀ j < count, x < centers j + leftSpeed j * time → profiles j = states j)
    (hright : ∀ j < count, centers j + rightSpeed j * time < x →
      profiles j = states (j + 1)) :
    IsOrderedFiniteRiemannChain states profiles count := by
  have hhorizon : 0 ≤ horizon := htime.1.trans htime.2.le
  have hend := finite_intervals_pairwise_separated_of_adjacent
    (fun j => centers j + leftSpeed j * horizon)
    (fun j => centers j + rightSpeed j * horizon) count
    (fun j hj => by
      have := mul_le_mul_of_nonneg_right (hspeeds j hj) hhorizon
      dsimp only
      linarith)
    hinteraction
  apply isOrderedFiniteRiemannChain_of_strictly_separated_intervals states profiles
    (fun j => centers j + leftSpeed j * time)
    (fun j => centers j + rightSpeed j * time) count x
  · intro i j hij hj
    exact affine_front_gap_before_horizon _ _ _ _ _ _ (hcenters i j hij hj)
      (hend i j hij hj) htime
  · exact hleft
  · exact hright

/-- The actual noninteraction condition gives the profile pattern almost
everywhere in time even when fronts meet at the final horizon. -/
theorem isOrderedFiniteRiemannChain_of_affine_fronts_ae_time
    {E : Type*} (states : ℕ → E) (fields : ℕ → ℝ → ℝ → E)
    (centers leftSpeed rightSpeed : ℕ → ℝ) (count : ℕ) (horizon x : ℝ)
    (hcenters : ∀ i j, i < j → j < count → centers i < centers j)
    (hspeeds : ∀ j < count, leftSpeed j ≤ rightSpeed j)
    (hinteraction : ∀ j, j + 1 < count →
      centers j + rightSpeed j * horizon ≤ centers (j + 1) + leftSpeed (j + 1) * horizon)
    (hleft : ∀ j < count, ∀ time ∈ Set.Icc 0 horizon,
      x < centers j + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ j < count, ∀ time ∈ Set.Icc 0 horizon,
      centers j + rightSpeed j * time < x → fields j x time = states (j + 1)) :
    ∀ᵐ time ∂volume, time ∈ Set.Icc 0 horizon →
      IsOrderedFiniteRiemannChain states (fun j => fields j x time) count := by
  filter_upwards [volume.ae_ne horizon] with time hne ht
  exact isOrderedFiniteRiemannChain_of_affine_fronts_before_horizon states
    (fun j => fields j x time) centers leftSpeed rightSpeed count horizon time x
    hcenters hspeeds ⟨ht.1, lt_of_le_of_ne ht.2 hne⟩ hinteraction
    (fun j hj => hleft j hj time ht) (fun j hj => hright j hj time ht)

/-- Constructed local conservation from actual asymmetric wave
noninteraction, without specifying any wave-front representatives. -/
theorem finiteRiemannChain_rectangleReferenceOn_of_affine_fronts
    {m : ℕ} (states : ℕ → Fin m → ℝ) (fields : ℕ → ℝ → ℝ → Fin m → ℝ)
    (centers leftSpeed rightSpeed : ℕ → ℝ) (count : ℕ)
    (flux : (Fin m → ℝ) → Fin m → ℝ) (left right horizon : ℝ)
    (hhorizon : 0 ≤ horizon)
    (hcenters : ∀ i j, i < j → j < count → centers i < centers j)
    (hspeeds : ∀ j < count, leftSpeed j ≤ rightSpeed j)
    (hinteraction : ∀ j, j + 1 < count →
      centers j + rightSpeed j * horizon ≤ centers (j + 1) + leftSpeed (j + 1) * horizon)
    (hfields : ∀ j < count, LocalConservationLaw.RectangleReferenceOn
      (fields j) flux left right horizon)
    (hleft : ∀ j < count, ∀ x ∈ Set.Icc left right, ∀ time ∈ Set.Icc 0 horizon,
      x < centers j + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ j < count, ∀ x ∈ Set.Icc left right, ∀ time ∈ Set.Icc 0 horizon,
      centers j + rightSpeed j * time < x → fields j x time = states (j + 1)) :
    LocalConservationLaw.RectangleReferenceOn
      (fun x time => finiteRiemannChainAssembly states (fun j => fields j x time) count)
      flux left right horizon := by
  apply finiteRiemannChain_rectangleReferenceOn_of_flux_eq_ae_time states fields count
    flux left right horizon hhorizon hfields
  intro x hx
  have hpattern := isOrderedFiniteRiemannChain_of_affine_fronts_ae_time states fields
    centers leftSpeed rightSpeed count horizon x hcenters hspeeds hinteraction
    (fun j hj time ht => hleft j hj x hx time ht)
    (fun j hj time ht => hright j hj x hx time ht)
  filter_upwards [hpattern] with time hp ht
  rcases hp ht with ⟨k, hk, hbefore, hafter⟩ | ⟨k, hk, hbefore, hafter⟩
  · exact finiteRiemannChainAssembly_map_eq_of_state flux states (fun j => fields j x time)
      count k hk hbefore hafter
  · exact finiteRiemannChainAssembly_map_eq_of_profile flux states (fun j => fields j x time)
      count k hk hbefore hafter

end NumStability
