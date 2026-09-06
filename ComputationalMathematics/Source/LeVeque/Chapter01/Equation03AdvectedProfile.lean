/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation03

/-!
# LeVeque Chapter 1, Equation (1.3): global scope

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 1 (raw PDF page 23), equations (1.2)-(1.3). This declaration keeps
the source's arbitrary-profile propagation statement separate from the
regularity required by its classical PDE reading.
-/

namespace NumStability

/-- Equation (1.3), with its two regularity scopes made explicit: every scalar
profile is transported unchanged, and a globally differentiable profile is a
classical solution of the scalar advection equation at every point. -/
theorem leveque01_equation03_advectedProfile
    (profile : ℝ → ℝ) (speed : ℝ) :
    (∀ x t, travelingWave profile speed (x + speed * t) t = profile x) ∧
      (Differentiable ℝ profile →
        IsLinearAdvectionSolution (travelingWave profile speed) speed) := by
  constructor
  · exact leveque01_equation03_profilePropagates profile speed
  · exact travelingWave_isLinearAdvectionSolution speed

end NumStability
