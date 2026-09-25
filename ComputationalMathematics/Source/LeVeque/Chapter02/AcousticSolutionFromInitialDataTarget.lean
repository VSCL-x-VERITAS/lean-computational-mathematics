/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# Acoustic solution from initial pressure and velocity
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.68): the same state represented by the two acoustic waves
has the displayed pressure and velocity formulas in its time-zero trace. -/
def acousticSolutionFromInitialDataTarget : Prop :=
  ∀ (density soundSpeed : ℝ) (pressure velocity : ℝ → ℝ → ℝ)
      (leftProfile rightProfile : ℝ → ℝ),
    0 < acousticImpedance density soundSpeed →
      (∀ x t,
        linearAcousticsState pressure velocity x t =
          leftProfile (x + soundSpeed * t) •
              linearAcousticsLeftEigenvector density soundSpeed +
            rightProfile (x - soundSpeed * t) •
              linearAcousticsRightEigenvector density soundSpeed) →
        ∀ x t,
          pressure x t =
              (pressure (x + soundSpeed * t) 0 +
                  pressure (x - soundSpeed * t) 0) / 2 -
                acousticImpedance density soundSpeed / 2 *
                  (velocity (x + soundSpeed * t) 0 -
                    velocity (x - soundSpeed * t) 0) ∧
            velocity x t =
              -(pressure (x + soundSpeed * t) 0 -
                    pressure (x - soundSpeed * t) 0) /
                  (2 * acousticImpedance density soundSpeed) +
                (velocity (x + soundSpeed * t) 0 +
                    velocity (x - soundSpeed * t) 0) / 2

end NumStability.Leveque02Tracer
