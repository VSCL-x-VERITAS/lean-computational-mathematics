/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainWindow
import Mathlib.Data.Real.Basic
import Mathlib.Order.Interval.Set.Basic

/-!
# Bilateral Riemann chains through compatible finite windows

Integer-indexed profiles with constant exterior tails give a value independent of the chosen finite window. The evolution uses that value on its specified time interval and the background state outside it.
-/

namespace NumStability

def integerRiemannChainWindow {E : Type*} [AddCommGroup E]
    (states profiles : ℤ → E) (radius : ℕ) : E :=
  finiteRiemannChainAssembly (fun j => states ((j : ℤ) - radius))
    (fun j => profiles ((j : ℤ) - radius)) (2 * radius)

def IsRiemannChainWindow {E : Type*} (states profiles : ℤ → E) (radius : ℕ) : Prop :=
  (∀ j : ℤ, j < -(radius : ℤ) → profiles j = states (j + 1)) ∧
  (∀ j : ℤ, (radius : ℤ) ≤ j → profiles j = states j)

theorem integerRiemannChainWindow_eq_of_le {E : Type*} [AddCommGroup E]
    (states profiles : ℤ → E) (small large : ℕ) (hle : small ≤ large)
    (hsmall : IsRiemannChainWindow states profiles small) :
    integerRiemannChainWindow states profiles large =
      integerRiemannChainWindow states profiles small := by
  have h := finiteRiemannChainAssembly_eq_window
    (fun j => states ((j : ℤ) - large)) (fun j => profiles ((j : ℤ) - large))
    (large - small) (2 * small) (2 * large) (by omega)
    (by
      intro j hj
      have hp := hsmall.1 ((j : ℤ) - large) (by omega)
      simpa only [Nat.cast_add, Nat.cast_one, sub_add_eq_add_sub] using hp)
    (by
      intro j hj htotal
      exact hsmall.2 ((j : ℤ) - large) (by omega))
  unfold integerRiemannChainWindow
  rw [h]
  have hstates : (fun j : ℕ => states ((↑(large - small + j) : ℤ) - large)) =
      (fun j : ℕ => states ((j : ℤ) - small)) := by
    funext j
    congr 1
    simp only [Nat.cast_add, Nat.cast_sub hle]
    omega
  have hprofiles : (fun j : ℕ => profiles ((↑(large - small + j) : ℤ) - large)) =
      (fun j : ℕ => profiles ((j : ℤ) - small)) := by
    funext j
    congr 1
    simp only [Nat.cast_add, Nat.cast_sub hle]
    omega
  rw [hstates, hprofiles]

theorem integerRiemannChainWindow_eq {E : Type*} [AddCommGroup E]
    (states profiles : ℤ → E) (first second : ℕ)
    (hfirst : IsRiemannChainWindow states profiles first)
    (hsecond : IsRiemannChainWindow states profiles second) :
    integerRiemannChainWindow states profiles first =
      integerRiemannChainWindow states profiles second := by
  rcases le_total first second with h | h
  · exact (integerRiemannChainWindow_eq_of_le states profiles first second h hfirst).symm
  · exact integerRiemannChainWindow_eq_of_le states profiles second first h hsecond

noncomputable def bilateralRiemannChainAssembly {E : Type*} [AddCommGroup E]
    (states profiles : ℤ → E) (hfinite : ∃ radius, IsRiemannChainWindow states profiles radius) : E :=
  integerRiemannChainWindow states profiles (Classical.choose hfinite)

theorem bilateralRiemannChainAssembly_eq_window {E : Type*} [AddCommGroup E]
    (states profiles : ℤ → E) (hfinite : ∃ radius, IsRiemannChainWindow states profiles radius)
    (radius : ℕ) (hradius : IsRiemannChainWindow states profiles radius) :
    bilateralRiemannChainAssembly states profiles hfinite =
      integerRiemannChainWindow states profiles radius :=
  integerRiemannChainWindow_eq states profiles _ radius (Classical.choose_spec hfinite) hradius

noncomputable def bilateralRiemannChainEvolution {E : Type*} [AddCommGroup E]
    (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E) (horizon : ℝ)
    (hfinite : ∀ x time, time ∈ Set.Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states (fun j => fields j x time) radius)
    (x time : ℝ) : E :=
  if ht : time ∈ Set.Icc 0 horizon then
    bilateralRiemannChainAssembly states (fun j => fields j x time) (hfinite x time ht)
  else states 0

theorem bilateralRiemannChainEvolution_eq_window {E : Type*} [AddCommGroup E]
    (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E) (horizon : ℝ)
    (hfinite : ∀ x time, time ∈ Set.Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states (fun j => fields j x time) radius)
    (x time : ℝ) (htime : time ∈ Set.Icc 0 horizon) (radius : ℕ)
    (hradius : IsRiemannChainWindow states (fun j => fields j x time) radius) :
    bilateralRiemannChainEvolution states fields horizon hfinite x time =
      integerRiemannChainWindow states (fun j => fields j x time) radius := by
  simp only [bilateralRiemannChainEvolution, dif_pos htime]
  exact bilateralRiemannChainAssembly_eq_window _ _ _ radius hradius

/-- Increasing the radius preserves constant exterior tails. -/
theorem IsRiemannChainWindow.mono {E : Type*} {states profiles : ℤ → E}
    {small large : ℕ} (h : IsRiemannChainWindow states profiles small) (hle : small ≤ large) :
    IsRiemannChainWindow states profiles large := by
  exact ⟨fun j hj => h.1 j (by omega), fun j hj => h.2 j (by omega)⟩

end NumStability
