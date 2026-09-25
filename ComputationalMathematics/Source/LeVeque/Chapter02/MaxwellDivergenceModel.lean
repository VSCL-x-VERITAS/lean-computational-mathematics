/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellAmpereModel

/-!
# Cartesian divergence for Maxwell fields

Only the three diagonal spatial partials are needed for divergence.
-/

namespace NumStability.Leveque02Tracer

/-- The spatial divergence of a three-component field at a space-time point. -/
noncomputable def maxwellDivergence
    (field : MaxwellField) (position : MaxwellVector) (time : ℝ) : ℝ :=
  maxwellSpatialPartial field 0 0 position time +
    maxwellSpatialPartial field 1 1 position time +
    maxwellSpatialPartial field 2 2 position time

/-- A pointwise divergence-free Maxwell field with genuine derivatives in
the three component-coordinate pairs used by the divergence. -/
def IsMaxwellDivergenceFreeAt
    (field : MaxwellField) (position : MaxwellVector) (time : ℝ) : Prop :=
  (∀ component,
      HasDerivAt
        (fun s => field (Function.update position component s) time component)
        (maxwellSpatialPartial field component component position time)
        (position component)) ∧
  maxwellDivergence field position time = 0

end NumStability.Leveque02Tracer
