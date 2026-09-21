/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AutonomousFluxModel

/-!
# Proof-free target for LeVeque's autonomous-flux definition
-/

namespace NumStability.Leveque02Tracer

/-- Autonomous flux is exactly representability by a state-only function. -/
def autonomousFluxTarget : Prop :=
  ∀ (stateDomain spatialDomain temporalDomain : Set ℝ)
    (spaceTimeFlux : ℝ → ℝ → ℝ → ℝ),
    IsAutonomousFluxOn stateDomain spatialDomain temporalDomain spaceTimeFlux ↔
      ∃ flux : ℝ → ℝ,
        ∀ state ∈ stateDomain, ∀ x ∈ spatialDomain, ∀ t ∈ temporalDomain,
          spaceTimeFlux state x t = flux state

end NumStability.Leveque02Tracer
