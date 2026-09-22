/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# Acoustic impedance
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.59): the positive acoustic impedance is the product of the
background density and sound speed. -/
def acousticImpedanceTarget : Prop :=
  ∀ (density soundSpeed : ℝ), 0 < density → 0 < soundSpeed →
    ∃ impedance : ℝ,
      impedance = acousticImpedance density soundSpeed ∧
        impedance = density * soundSpeed ∧ 0 < impedance

end NumStability.Leveque02Tracer
