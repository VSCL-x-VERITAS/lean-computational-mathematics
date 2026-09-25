/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellAmpereModel

/-!
# Proof-free target for LeVeque equation (2.109)

The charge/current-free vector equation is unpacked into its three Cartesian
components. Lean indices `0,1,2` correspond to printed components `1,2,3`.
-/

namespace NumStability.Leveque02Tracer

/-- Under actual component derivatives, `Dₜ - ∇ × H = 0` is exactly its
three right-handed Cartesian component equations. -/
def maxwellAmpereTarget : Prop :=
  ∀ (electricDisplacement magneticField : MaxwellField)
    (position : MaxwellVector) (time : ℝ),
    IsMaxwellAmpereAt electricDisplacement magneticField position time ↔
      (∀ component,
        HasDerivAt (fun τ => electricDisplacement position τ component)
          (maxwellTimePartial electricDisplacement component position time) time) ∧
      (∀ component direction, MaxwellCurlUses component direction →
        HasDerivAt
          (fun s => magneticField (Function.update position direction s) time component)
          (maxwellSpatialPartial magneticField component direction position time)
          (position direction)) ∧
      (maxwellTimePartial electricDisplacement 0 position time -
        maxwellSpatialPartial magneticField 2 1 position time +
        maxwellSpatialPartial magneticField 1 2 position time = 0) ∧
      (maxwellTimePartial electricDisplacement 1 position time -
        maxwellSpatialPartial magneticField 0 2 position time +
        maxwellSpatialPartial magneticField 2 0 position time = 0) ∧
      (maxwellTimePartial electricDisplacement 2 position time -
        maxwellSpatialPartial magneticField 1 0 position time +
        maxwellSpatialPartial magneticField 0 1 position time = 0)

end NumStability.Leveque02Tracer
