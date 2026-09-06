/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection

/-!
# LeVeque Chapter 1, Equation (1.3)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 1 (raw PDF page 23), equations (1.2)-(1.3). This is the classical,
differentiable reading of the translated-profile solution claim.
-/

namespace NumStability

/-- Equation (1.3): an arbitrary profile is transported unchanged along the
characteristic `x + speed * t`, with no regularity assumption. -/
theorem leveque01_equation03_profilePropagates
    {E : Type*} (profile : ℝ → E) (speed x t : ℝ) :
    travelingWave profile speed (x + speed * t) t = profile x :=
  travelingWave_at_translated_point profile speed x t

/-- Equations (1.2)-(1.3): a differentiable scalar profile translated at
constant speed is a classical solution of the scalar advection equation. -/
theorem leveque01_equation03_scalarAdvection
    {profile : ℝ → ℝ} {profile' speed x t : ℝ}
    (hprofile : HasDerivAt profile profile' (x - speed * t)) :
    IsLinearAdvectionSolutionAt
      (travelingWave profile speed) speed x t :=
  travelingWave_isLinearAdvectionSolutionAt speed x t hprofile

end NumStability
