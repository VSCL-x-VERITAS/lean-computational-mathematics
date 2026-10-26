/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.UniformAdvection

/-!
# LeVeque Chapter 4: domain of dependence for constant advection

The traveling-wave solution at `(X,T)` reads exactly the initial profile
at `X-speed*T`. A set of initial positions determines this value for
all initial profiles exactly when it contains that backtraced point.
-/

namespace NumStability

/-- An initial-data set determines the constant-advection solution at
one space-time point for all scalar initial profiles. -/
def DeterminesLeveque04AdvectionAt
    (speed X T : ℝ) (initialSet : Set ℝ) : Prop :=
  ∀ f g : ℝ → ℝ,
    (∀ y ∈ initialSet, f y = g y) →
      travelingWave f speed X T = travelingWave g speed X T

/-- The exact translated solution has the value of the initial
profile at the backtraced characteristic foot. -/
theorem leveque04_advectionValue
    (q : ℝ → ℝ → ℝ) (speed X T : ℝ)
    (htransport : IsUniformAdvection q speed) :
    q X T = q (X - speed * T) 0 := by
  have heq := (isUniformAdvection_iff_eq_travelingWave q speed).mp htransport
  rw [heq]
  simp only [travelingWave, mul_zero, sub_zero]

/-- The exact dependence set is the singleton backtraced point. -/
theorem leveque04_advectionDomain
    (speed X T : ℝ) (initialSet : Set ℝ) :
    DeterminesLeveque04AdvectionAt speed X T initialSet ↔
      X - speed * T ∈ initialSet := by
  constructor
  · intro h
    by_contra hmissing
    let point := X - speed * T
    change point ∉ initialSet at hmissing
    let f : ℝ → ℝ := fun _ => 0
    let g : ℝ → ℝ := fun y => if y = point then 1 else 0
    have hagree : ∀ y ∈ initialSet, f y = g y := by
      intro y hy
      have hne : y ≠ point := by
        intro heq
        exact hmissing (heq ▸ hy)
      simp [f, g, hne]
    have heq := h f g hagree
    have hcontra : (0 : ℝ) = 1 := by
      simpa only [travelingWave, f, g, point, ite_true] using heq
    norm_num at hcontra
  · intro hpoint f g hagree
    simpa only [travelingWave] using hagree (X - speed * T) hpoint

/-- In particular, the singleton containing the backtraced point
determines the value of every transported initial profile. -/
theorem leveque04_advectionDomain_singleton (speed X T : ℝ) :
    DeterminesLeveque04AdvectionAt speed X T
      {X - speed * T} := by
  exact (leveque04_advectionDomain speed X T _).2 (Set.mem_singleton _)

end NumStability
