/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.WithinDomains

/-!
# The whole-line advection initial-value problem

The explicit translated field attains the initial profile and solves advection
for later times. Uniqueness is asserted only on the forward-time domain among
classical fields continuous up to the initial time. No derivative at the
initial-time boundary is required of a competing solution.

This is a proof-free target for independent statement-faithfulness review.
-/

namespace NumStability.Leveque02Tracer

/-- Translation gives the unique forward classical solution with prescribed initial data. -/
def advectionCauchyTarget : Prop :=
  ∀ (E : Type) [NormedAddCommGroup E] [NormedSpace ℝ E]
      (initial : ℝ → E) (velocity initialTime : ℝ),
    Differentiable ℝ initial →
    let solution : ℝ → ℝ → E := fun x t => initial (x - velocity * (t - initialTime))
    ContinuousOn (Function.uncurry solution) (Set.prod Set.univ (Set.Ici initialTime)) ∧
    DifferentiableOn ℝ (Function.uncurry solution) (Set.prod Set.univ (Set.Ioi initialTime)) ∧
    (∀ x, solution x initialTime = initial x) ∧
    (∀ x t, initialTime < t → IsLinearAdvectionSolutionWithinAt solution velocity x t
      Set.univ (Set.Ioi initialTime)) ∧
    (∀ field : ℝ → ℝ → E,
      ContinuousOn (Function.uncurry field) (Set.prod Set.univ (Set.Ici initialTime)) →
      DifferentiableOn ℝ (Function.uncurry field) (Set.prod Set.univ (Set.Ioi initialTime)) →
      (∀ x t, initialTime < t → IsLinearAdvectionSolutionWithinAt field velocity x t
        Set.univ (Set.Ioi initialTime)) →
      (∀ x, field x initialTime = initial x) →
      ∀ x t, initialTime ≤ t → field x t = solution x t)

end NumStability.Leveque02Tracer
