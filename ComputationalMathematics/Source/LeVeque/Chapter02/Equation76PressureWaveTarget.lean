/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcousticsWaveEquation

/-!
# LeVeque Chapter 2, Equation (2.76): acoustic pressure wave equation

Proof-free statement for the pressure equation obtained by eliminating the
velocity from the stationary constant-coefficient acoustic system.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.76), with the second derivatives and mixed-partial equality
needed for the displayed differentiation made explicit. -/
def equation76PressureWaveTarget : Prop :=
  ∀ {bulkModulus density : ℝ}
      (system : LinearAcousticsSolution bulkModulus density),
    0 < bulkModulus → 0 < density →
      ∀ (x t ptt pxx uxt utx : ℝ),
        HasDerivAt
            (fun τ => partialTimeDerivative system.pressure x τ) ptt t →
          HasDerivAt
              (fun τ => partialSpaceDerivative system.velocity x τ) uxt t →
            HasDerivAt
                (fun ξ => partialTimeDerivative system.velocity ξ t) utx x →
              HasDerivAt
                  (fun ξ => partialSpaceDerivative system.pressure ξ t) pxx x →
                uxt = utx →
                  ptt = (Real.sqrt (bulkModulus / density)) ^ 2 * pxx

end NumStability.Leveque02Tracer
