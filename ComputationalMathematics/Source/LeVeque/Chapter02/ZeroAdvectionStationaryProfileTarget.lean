/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal

/-!
# Zero-velocity advection before diffusion

Proof-free target for the statement preceding Fick's law on printed page 20.
-/

namespace NumStability.Leveque02Tracer

/-- Zero advection speed makes the time derivative vanish, so the initial
profile is stationary before a diffusion term is introduced. -/
def zeroAdvectionStationaryProfileTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ),
    IsLinearAdvectionSolution q 0 →
      (∀ x t, HasDerivAt (fun τ => q x τ) 0 t) ∧
        (∀ x t, q x t = q x 0)

end NumStability.Leveque02Tracer
