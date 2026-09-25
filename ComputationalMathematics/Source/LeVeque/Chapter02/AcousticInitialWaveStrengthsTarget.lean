/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# Initial acoustic wave strengths
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.67): the amplitudes in the initial matrix equation (2.64)
equal the displayed formulas in the initial pressure and velocity profiles. -/
def acousticInitialWaveStrengthsTarget : Prop :=
  ∀ (density soundSpeed : ℝ)
      (initialPressure initialVelocity leftProfile rightProfile : ℝ → ℝ),
    0 < acousticImpedance density soundSpeed →
      (∀ x,
        (linearAcousticsEigenvectorMatrix density soundSpeed).mulVec
            ![leftProfile x, rightProfile x] =
          ![initialPressure x, initialVelocity x]) →
        ∀ x,
          leftProfile x =
              (-initialPressure x +
                  acousticImpedance density soundSpeed * initialVelocity x) /
                (2 * acousticImpedance density soundSpeed) ∧
            rightProfile x =
              (initialPressure x +
                  acousticImpedance density soundSpeed * initialVelocity x) /
                (2 * acousticImpedance density soundSpeed)

end NumStability.Leveque02Tracer
