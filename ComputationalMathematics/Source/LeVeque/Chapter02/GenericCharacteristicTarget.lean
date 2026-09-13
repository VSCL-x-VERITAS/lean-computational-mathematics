/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection

/-!
# Characteristic values in arbitrary value spaces

The existing traveling-wave representation supports any value type. This
proof-free generalization retains LeVeque's real spatial and temporal
coordinates while allowing scalar, vector, or discrete profile values.
Specialization to real values gives the source's scalar characteristic
identity. Independent audit must verify that correspondence and the added
codomain scope before a source wrapper is supplied.
-/

namespace NumStability.Leveque02Tracer

/-- Translated profiles keep their value along the corresponding straight ray. -/
def genericCharacteristicValueTarget : Prop :=
  ∀ (E : Type) (profile : ℝ → E) (velocity origin t : ℝ),
    travelingWave profile velocity (origin + velocity * t) t = profile origin

end NumStability.Leveque02Tracer
