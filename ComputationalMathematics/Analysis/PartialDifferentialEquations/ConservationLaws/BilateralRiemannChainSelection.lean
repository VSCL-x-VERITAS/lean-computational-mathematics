/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BilateralRiemannChain
import Mathlib.Algebra.Order.Archimedean.Basic

/-!
# Selecting profiles and states in a bilateral Riemann chain

When profiles on either side of an integer interface have reached their
endpoint states, the bilateral assembly selects the remaining profile or
constant state. The selection follows from the existing finite-chain identities.
-/

namespace NumStability

theorem bilateralRiemannChainAssembly_eq_profile
    {E : Type*} [AddCommGroup E] (states profiles : ℤ → E)
    (hfinite : ∃ radius, IsRiemannChainWindow states profiles radius) (cell : ℤ)
    (hbefore : ∀ j < cell, profiles j = states (j + 1))
    (hafter : ∀ j, cell < j → profiles j = states j) :
    bilateralRiemannChainAssembly states profiles hfinite = profiles cell := by
  have hfiniteCopy := hfinite
  obtain ⟨small, hs⟩ := hfiniteCopy
  obtain ⟨extra, he⟩ := exists_nat_gt (max (-cell) (cell + 1))
  let radius := max small extra
  have hsmall : small ≤ radius := Nat.le_max_left _ _
  have hextra : extra ≤ radius := Nat.le_max_right _ _
  have hlow := (le_max_left (-cell) (cell + 1)).trans_lt he
  have hupp := (le_max_right (-cell) (cell + 1)).trans_lt he
  have hnonnegative : 0 ≤ cell + (radius : ℤ) := by omega
  let k := (cell + (radius : ℤ)).toNat
  have hk : (k : ℤ) = cell + (radius : ℤ) := Int.toNat_of_nonneg hnonnegative
  rw [bilateralRiemannChainAssembly_eq_window states profiles hfinite radius (hs.mono hsmall)]
  unfold integerRiemannChainWindow
  have hp := finiteRiemannChainAssembly_eq_profile
    (fun j : ℕ => states ((j : ℤ) - radius))
    (fun j : ℕ => profiles ((j : ℤ) - radius)) (2 * radius) k (by omega)
    (by
      intro j hj
      have hi : (j : ℤ) - radius < cell := by omega
      simpa only [Nat.cast_add, Nat.cast_one, sub_add_eq_add_sub] using hbefore _ hi)
    (by
      intro j hj hjcount
      exact hafter _ (by omega))
  have hk' : (k : ℤ) - radius = cell := by omega
  simpa only [hk'] using hp

theorem bilateralRiemannChainAssembly_eq_state
    {E : Type*} [AddCommGroup E] (states profiles : ℤ → E)
    (hfinite : ∃ radius, IsRiemannChainWindow states profiles radius) (cell : ℤ)
    (hbefore : ∀ j < cell, profiles j = states (j + 1))
    (hafter : ∀ j, cell ≤ j → profiles j = states j) :
    bilateralRiemannChainAssembly states profiles hfinite = states cell := by
  have hfiniteCopy := hfinite
  obtain ⟨small, hs⟩ := hfiniteCopy
  obtain ⟨extra, he⟩ := exists_nat_gt (max (-cell) (cell + 1))
  let radius := max small extra
  have hsmall : small ≤ radius := Nat.le_max_left _ _
  have hextra : extra ≤ radius := Nat.le_max_right _ _
  have hlow := (le_max_left (-cell) (cell + 1)).trans_lt he
  have hupp := (le_max_right (-cell) (cell + 1)).trans_lt he
  have hnonnegative : 0 ≤ cell + (radius : ℤ) := by omega
  let k := (cell + (radius : ℤ)).toNat
  have hk : (k : ℤ) = cell + (radius : ℤ) := Int.toNat_of_nonneg hnonnegative
  rw [bilateralRiemannChainAssembly_eq_window states profiles hfinite radius (hs.mono hsmall)]
  unfold integerRiemannChainWindow
  have hp := finiteRiemannChainAssembly_eq_state
    (fun j : ℕ => states ((j : ℤ) - radius))
    (fun j : ℕ => profiles ((j : ℤ) - radius)) (2 * radius) k (by omega)
    (by
      intro j hj
      have hi : (j : ℤ) - radius < cell := by omega
      simpa only [Nat.cast_add, Nat.cast_one, sub_add_eq_add_sub] using hbefore _ hi)
    (by
      intro j hj hjcount
      exact hafter _ (by omega))
  have hk' : (k : ℤ) - radius = cell := by omega
  simpa only [hk'] using hp

theorem bilateralRiemannChainEvolution_eq_profile
    {E : Type*} [AddCommGroup E] (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (horizon : ℝ)
    (hfinite : ∀ x time, time ∈ Set.Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states (fun j => fields j x time) radius)
    (x time : ℝ) (htime : time ∈ Set.Icc 0 horizon) (cell : ℤ)
    (hbefore : ∀ j < cell, fields j x time = states (j + 1))
    (hafter : ∀ j, cell < j → fields j x time = states j) :
    bilateralRiemannChainEvolution states fields horizon hfinite x time = fields cell x time := by
  simp only [bilateralRiemannChainEvolution, dif_pos htime]
  exact bilateralRiemannChainAssembly_eq_profile states _ _ cell hbefore hafter

theorem bilateralRiemannChainEvolution_eq_state
    {E : Type*} [AddCommGroup E] (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (horizon : ℝ)
    (hfinite : ∀ x time, time ∈ Set.Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states (fun j => fields j x time) radius)
    (x time : ℝ) (htime : time ∈ Set.Icc 0 horizon) (cell : ℤ)
    (hbefore : ∀ j < cell, fields j x time = states (j + 1))
    (hafter : ∀ j, cell ≤ j → fields j x time = states j) :
    bilateralRiemannChainEvolution states fields horizon hfinite x time = states cell := by
  simp only [bilateralRiemannChainEvolution, dif_pos htime]
  exact bilateralRiemannChainAssembly_eq_state states _ _ cell hbefore hafter

end NumStability
