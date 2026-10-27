/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BilateralRiemannChain
import Mathlib.Algebra.Order.Archimedean.Basic
import Mathlib.Data.Real.Archimedean
import Mathlib.Tactic.Linarith

/-!
# Uniform finite windows for lattice Riemann profiles

Positive lattice spacing and a uniform cone-speed bound imply constant exterior tails uniformly on each compact forward box. No global conservation law is assumed.
-/

namespace NumStability

theorem riemannChainWindow_exists_uniform_cones
    {E : Type*} (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (origin width bound horizon left right : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (_hhorizon : 0 ≤ horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width - bound * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + bound * time < x → fields j x time = states (j + 1)) :
    ∃ radius : ℕ, ∀ x ∈ Set.Icc left right, ∀ time ∈ Set.Icc 0 horizon,
      IsRiemannChainWindow states (fun j => fields j x time) radius := by
  obtain ⟨radius, hn⟩ := exists_nat_gt
    ((|left - origin| + |right - origin| + bound * horizon) / width)
  have hn' := (div_lt_iff₀ hwidth).mp hn
  refine ⟨radius, ?_⟩
  intro x hx time ht
  have hbt := mul_le_mul_of_nonneg_left ht.2 hbound
  refine ⟨?_, ?_⟩
  · intro j hj
    apply hright j x time ht
    have hj' : (j : ℝ) < -(radius : ℝ) := by exact_mod_cast hj
    have hjw := mul_lt_mul_of_pos_right hj' hwidth
    have ha := neg_le_abs (left - origin)
    have hb := abs_nonneg (right - origin)
    nlinarith [hx.1]
  · intro j hj
    apply hleft j x time ht
    have hj' : (radius : ℝ) ≤ (j : ℝ) := by exact_mod_cast hj
    have hjw := mul_le_mul_of_nonneg_right hj' hwidth.le
    have ha := le_abs_self (right - origin)
    have hb := abs_nonneg (left - origin)
    nlinarith [hx.2]

theorem riemannChain_pointwise_finite_of_uniform_cones
    {E : Type*} (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (origin width bound horizon : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hhorizon : 0 ≤ horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width - bound * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + bound * time < x → fields j x time = states (j + 1)) :
    ∀ x time, time ∈ Set.Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states (fun j => fields j x time) radius := by
  intro x time ht
  obtain ⟨radius, hradius⟩ := riemannChainWindow_exists_uniform_cones states fields
    origin width bound horizon x x hwidth hbound hhorizon hleft hright
  exact ⟨radius, hradius x ⟨le_refl _, le_refl _⟩ time ht⟩

/-- Uniform speed bounds turn asymmetric affine-front states into common exterior cones. -/
theorem riemannChain_uniform_cones_of_affine_fronts
    {E : Type*} (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width bound horizon : ℝ)
    (hspeeds : ∀ j, -bound ≤ leftSpeed j ∧ rightSpeed j ≤ bound)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + rightSpeed j * time < x → fields j x time = states (j + 1)) :
    (∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width - bound * time → fields j x time = states j) ∧
    (∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + bound * time < x → fields j x time = states (j + 1)) := by
  constructor
  · intro j x time ht hx
    apply hleft j x time ht
    have := mul_le_mul_of_nonneg_right (hspeeds j).1 ht.1
    nlinarith
  · intro j x time ht hx
    apply hright j x time ht
    have := mul_le_mul_of_nonneg_right (hspeeds j).2 ht.1
    nlinarith

end NumStability
