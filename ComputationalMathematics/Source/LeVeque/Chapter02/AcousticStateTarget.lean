/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# Pressure--velocity acoustic state notation
-/

namespace NumStability.Leveque02Tracer

/-- The post-(2.50) acoustic state `q = (p,u)` has pressure first and velocity
second. -/
def acousticStateTarget : Prop :=
  ∀ (pressure velocity : ℝ → ℝ → ℝ) (x t : ℝ),
    linearAcousticsState pressure velocity x t = ![pressure x t, velocity x t]

end NumStability.Leveque02Tracer
