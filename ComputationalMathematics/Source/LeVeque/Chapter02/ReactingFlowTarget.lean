/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BalanceLaw
import Mathlib.Data.Fin.VecNotation

/-!
# Two-species radioactive conversion in a common flow

The first species loses concentration at rate alpha times its concentration,
and the second gains that same amount. Their advective flux has the common
constant velocity. The target identifies the actual vector balance law with
the two displayed component equations (2.29).
-/

namespace NumStability.Leveque02Tracer

/-- Constant-speed balance with radioactive conversion gives the two species equations. -/
def reactingFlowTarget : Prop :=
  ∀ (q : ℝ → ℝ → (Fin 2 → ℝ)) (spatialDerivative : Fin 2 → ℝ)
    (velocity decayRate x t : ℝ),
    HasDerivAt (fun ξ => q ξ t) spatialDerivative x →
    (IsBalanceLawSolutionAt q (fun state => velocity • state)
        ![-decayRate * q x t 0, decayRate * q x t 0] x t ↔
      ∃ timeDerivative : Fin 2 → ℝ,
        HasDerivAt (fun τ => q x τ) timeDerivative t ∧
        timeDerivative 0 + velocity * spatialDerivative 0 = -decayRate * q x t 0 ∧
        timeDerivative 1 + velocity * spatialDerivative 1 = decayRate * q x t 0)

end NumStability.Leveque02Tracer
