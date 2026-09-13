/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.WithinDomains
import Mathlib.Analysis.Calculus.ContDiff.Basic

/-!
# Scalar classical advection initial-value problem

The translated scalar C1 profile gives the forward C1 solution, unique among
scalar C1 solutions in the open forward domain that are continuous up to the
initial time. This proof-free target does not quantify over vector-valued
states or merely differentiable profiles with discontinuous derivatives.
-/

namespace NumStability.Leveque02Tracer

/-- The scalar classical whole-line Cauchy solution is the translated initial profile. -/
def scalarAdvectionCauchyTarget : Prop :=
  ∀ (initial : ℝ → ℝ) (velocity initialTime : ℝ),
    ContDiff ℝ 1 initial →
    let solution : ℝ → ℝ → ℝ := fun x t => initial (x - velocity * (t - initialTime))
    ContinuousOn (Function.uncurry solution) (Set.prod Set.univ (Set.Ici initialTime)) ∧
    ContDiffOn ℝ 1 (Function.uncurry solution) (Set.prod Set.univ (Set.Ioi initialTime)) ∧
    (∀ x, solution x initialTime = initial x) ∧
    (∀ x t, initialTime < t → IsLinearAdvectionSolutionWithinAt solution velocity x t
      Set.univ (Set.Ioi initialTime)) ∧
    (∀ field : ℝ → ℝ → ℝ,
      ContinuousOn (Function.uncurry field) (Set.prod Set.univ (Set.Ici initialTime)) →
      ContDiffOn ℝ 1 (Function.uncurry field) (Set.prod Set.univ (Set.Ioi initialTime)) →
      (∀ x t, initialTime < t → IsLinearAdvectionSolutionWithinAt field velocity x t
        Set.univ (Set.Ioi initialTime)) →
      (∀ x, field x initialTime = initial x) →
      ∀ x t, initialTime ≤ t → field x t = solution x t)

end NumStability.Leveque02Tracer
