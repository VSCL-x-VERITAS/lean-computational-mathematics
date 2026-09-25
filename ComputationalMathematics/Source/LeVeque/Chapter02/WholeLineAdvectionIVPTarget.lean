/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AdvectionCauchyTarget

/-!
# Whole-line advection initial-value problem

Classical existence for differentiable data is paired with a separate formula
and conditional uniqueness statement for an arbitrary scalar initial profile.
The latter does not assert classical existence for rough initial data.
This module contains only proof-free targets for source review.
-/

namespace NumStability.Leveque02Tracer

/-- Every classical forward solution with a prescribed scalar trace has the
translated formula, even when the trace is not separately assumed smooth. -/
def wholeLineAdvectionFormulaTarget : Prop :=
  ∀ (initial : ℝ → ℝ) (velocity initialTime : ℝ),
    let solution : ℝ → ℝ → ℝ :=
      fun x t => initial (x - velocity * (t - initialTime))
    (∀ x, solution x initialTime = initial x) ∧
    (∀ field : ℝ → ℝ → ℝ,
      ContinuousOn (Function.uncurry field) (Set.prod Set.univ (Set.Ici initialTime)) →
      DifferentiableOn ℝ (Function.uncurry field) (Set.prod Set.univ (Set.Ioi initialTime)) →
      (∀ x t, initialTime < t → IsLinearAdvectionSolutionWithinAt field velocity x t
        Set.univ (Set.Ioi initialTime)) →
      (∀ x, field x initialTime = initial x) →
      ∀ x t, initialTime ≤ t → field x t = solution x t)

/-- Classical existence for differentiable initial profiles, together with
the characteristic formula for any admissible scalar classical solution. -/
def wholeLineAdvectionIVPTarget : Prop :=
  advectionCauchyTarget ∧ wholeLineAdvectionFormulaTarget

end NumStability.Leveque02Tracer
