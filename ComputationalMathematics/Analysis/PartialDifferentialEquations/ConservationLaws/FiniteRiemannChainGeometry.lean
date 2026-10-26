/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainRectangle

/-!
# Finite Riemann-chain signal cone geometry

Separated half-open signal cones give ordered finite profile patterns and construct local nonlinear conservation under nonstrict uniform CFL.
-/

namespace NumStability

/-- Ordered half-open wave intervals give the endpoint pattern of a finite chain.
The right endpoint is included in the constant right region, allowing adjacent
cones to touch under a nonstrict CFL bound. -/
theorem isOrderedFiniteRiemannChain_of_separated_intervals
    {E : Type*} (states profiles : ℕ → E) (leftEdge rightEdge : ℕ → ℝ)
    (count : ℕ) (x : ℝ)
    (hinterval : ∀ j < count, leftEdge j ≤ rightEdge j)
    (hseparated : ∀ i j, i < j → j < count → rightEdge i ≤ leftEdge j)
    (hleft : ∀ j < count, x < leftEdge j → profiles j = states j)
    (hright : ∀ j < count, rightEdge j ≤ x → profiles j = states (j + 1)) :
    IsOrderedFiniteRiemannChain states profiles count := by
  induction count with
  | zero =>
    exact Or.inl ⟨0, le_rfl, by omega, by omega⟩
  | succ n ih =>
    by_cases hx : x < leftEdge n
    · have hp := ih (fun j hj => hinterval j (by omega))
        (fun i j hij hj => hseparated i j hij (by omega))
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
        exact hright j (by omega) ((hseparated j n hj (by omega)).trans hxn)
      by_cases hxr : rightEdge n ≤ x
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

/-- A uniform-mesh half-Courant bound orders cones throughout the forward
step, including equality at touching cone edges. -/
theorem isOrderedFiniteRiemannChain_of_uniform_cones
    {E : Type*} (states profiles : ℕ → E) (count : ℕ)
    (width bound horizon x time : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (htime : time ∈ Set.Icc 0 horizon) (hcfl : 2 * bound * horizon ≤ width)
    (hleft : ∀ j < count, x < (j : ℝ) * width - bound * time → profiles j = states j)
    (hright : ∀ j < count, (j : ℝ) * width + bound * time ≤ x →
      profiles j = states (j + 1)) :
    IsOrderedFiniteRiemannChain states profiles count := by
  apply isOrderedFiniteRiemannChain_of_separated_intervals states profiles
    (fun j => (j : ℝ) * width - bound * time)
    (fun j => (j : ℝ) * width + bound * time) count x
  · intro j _
    have := mul_nonneg hbound htime.1
    linarith
  · intro i j hij _
    have hij' : (i : ℝ) + 1 ≤ (j : ℝ) := by
      exact_mod_cast (Nat.succ_le_iff.mpr hij)
    have hgap := mul_le_mul_of_nonneg_right hij' hwidth.le
    have hbt := mul_le_mul_of_nonneg_left htime.2 hbound
    nlinarith
  · exact hleft
  · exact hright

/-- Individual local Riemann profiles with uniform signal cones construct
a conserving evolution under the nonstrict half-Courant bound. -/
theorem finiteRiemannChain_rectangleReferenceOn_of_uniform_cones
    {m : ℕ} (states : ℕ → Fin m → ℝ) (fields : ℕ → ℝ → ℝ → Fin m → ℝ)
    (count : ℕ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (left right width bound horizon : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hhorizon : 0 ≤ horizon)
    (hcfl : 2 * bound * horizon ≤ width)
    (hfields : ∀ j < count, LocalConservationLaw.RectangleReferenceOn
      (fields j) flux left right horizon)
    (hleft : ∀ j < count, ∀ x ∈ Set.Icc left right, ∀ t ∈ Set.Icc 0 horizon,
      x < (j : ℝ) * width - bound * t → fields j x t = states j)
    (hright : ∀ j < count, ∀ x ∈ Set.Icc left right, ∀ t ∈ Set.Icc 0 horizon,
      (j : ℝ) * width + bound * t ≤ x → fields j x t = states (j + 1)) :
    LocalConservationLaw.RectangleReferenceOn
      (fun x t => finiteRiemannChainAssembly states (fun j => fields j x t) count)
      flux left right horizon := by
  apply finiteRiemannChain_rectangleReferenceOn_of_ordered_profiles states fields count
    flux left right horizon hhorizon hfields
  intro x hx t ht
  exact isOrderedFiniteRiemannChain_of_uniform_cones states (fun j => fields j x t)
    count width bound horizon x t hwidth hbound ht hcfl
    (fun j hj => hleft j hj x hx t ht) (fun j hj => hright j hj x hx t ht)

end NumStability
