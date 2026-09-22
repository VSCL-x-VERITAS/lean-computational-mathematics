/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.ContDiff.Defs
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection

/-!
# Derivatives of a vector travelling profile
-/

namespace NumStability.Leveque02Tracer

/-- The chain-rule identities preceding equation (2.53). -/
def travelingProfileDerivativesTarget : Prop :=
  ∀ (m : ℕ), 0 < m → ∀ (profile : ℝ → (Fin m → ℝ))
      (profileDerivative : Fin m → ℝ) (speed x t : ℝ),
    ContDiff ℝ ⊤ profile →
      HasDerivAt profile profileDerivative (x - speed * t) →
        HasDerivAt (fun τ => travelingWave profile speed x τ)
            ((-speed) • profileDerivative) t ∧
          HasDerivAt (fun ξ => travelingWave profile speed ξ t)
            profileDerivative x

end NumStability.Leveque02Tracer
