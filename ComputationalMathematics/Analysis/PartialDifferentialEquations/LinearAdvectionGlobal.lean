/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection

/-!
# Global constant-coefficient linear advection solutions

Global solution predicates and traveling-wave solutions for
`q_t + a q_x = 0`.
-/

namespace NumStability

section LinearAdvection

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- A function satisfies `q_t + speed q_x = 0` at every point. -/
def IsLinearAdvectionSolution
    (q : ℝ → ℝ → E) (speed : ℝ) : Prop :=
  ∀ x t, IsLinearAdvectionSolutionAt q speed x t

/-- A globally differentiable translated profile solves linear advection at
every point. -/
theorem travelingWave_isLinearAdvectionSolution
    {profile : ℝ → E} (speed : ℝ)
    (hprofile : Differentiable ℝ profile) :
    IsLinearAdvectionSolution
      (travelingWave profile speed) speed := by
  intro x t
  exact travelingWave_isLinearAdvectionSolutionAt speed x t
    (hprofile (x - speed * t)).hasDerivAt

end LinearAdvection

end NumStability
