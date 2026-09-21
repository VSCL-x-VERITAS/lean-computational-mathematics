/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Autonomous scalar fluxes
-/

namespace NumStability.Leveque02Tracer

/-- A scalar space-time flux is autonomous on selected state, spatial, and
temporal domains when it is represented there by a state-only flux function. -/
def IsAutonomousFluxOn (stateDomain spatialDomain temporalDomain : Set ℝ)
    (spaceTimeFlux : ℝ → ℝ → ℝ → ℝ) : Prop :=
  ∃ flux : ℝ → ℝ,
    ∀ state ∈ stateDomain, ∀ x ∈ spatialDomain, ∀ t ∈ temporalDomain,
      spaceTimeFlux state x t = flux state

end NumStability.Leveque02Tracer
