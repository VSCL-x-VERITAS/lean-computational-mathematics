/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.ContDiff.Defs
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection

/-!
# Vector travelling-wave ansatz
-/

namespace NumStability.Leveque02Tracer

/-- The travelling-wave ansatz preceding equation (2.53) is the translated
vector profile `q(x,t) = qbar(x-s*t)`. -/
def travelingProfileTarget : Prop :=
  ∀ (m : ℕ), 0 < m → ∀ (profile : ℝ → (Fin m → ℝ)) (speed x t : ℝ),
    ContDiff ℝ ⊤ profile →
      travelingWave profile speed x t = profile (x - speed * t)

end NumStability.Leveque02Tracer
