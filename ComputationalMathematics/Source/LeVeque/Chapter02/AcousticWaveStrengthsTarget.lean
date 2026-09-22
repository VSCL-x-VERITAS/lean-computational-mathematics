/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# Acoustic wave strengths
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.67): the two acoustic wave strengths determined by initial
pressure and velocity data. -/
def acousticWaveStrengthsTarget : Prop :=
  ∀ (density soundSpeed pressure velocity : ℝ),
    0 < acousticImpedance density soundSpeed →
      acousticWaveStrengths density soundSpeed pressure velocity =
        ![(-pressure + acousticImpedance density soundSpeed * velocity) /
            (2 * acousticImpedance density soundSpeed),
          (pressure + acousticImpedance density soundSpeed * velocity) /
            (2 * acousticImpedance density soundSpeed)]

end NumStability.Leveque02Tracer
