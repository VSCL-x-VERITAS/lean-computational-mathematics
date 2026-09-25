/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellFaradayModel

/-!
# Proof-free target for LeVeque equation (2.110)

Lean component indices `0,1,2` correspond to the printed `1,2,3`.
-/

namespace NumStability.Leveque02Tracer

/-- The source-free Faraday vector equation and its three right-handed
Cartesian component equations agree on their exact derivative domain. -/
def maxwellFaradayTarget : Prop :=
  ∀ (magneticInduction electricField : MaxwellField)
    (position : MaxwellVector) (time : ℝ),
    IsMaxwellFaradayAt magneticInduction electricField position time ↔
      (∀ component,
        HasDerivAt (fun τ => magneticInduction position τ component)
          (maxwellTimePartial magneticInduction component position time) time) ∧
      (∀ component direction, MaxwellCurlUses component direction →
        HasDerivAt
          (fun s => electricField (Function.update position direction s) time component)
          (maxwellSpatialPartial electricField component direction position time)
          (position direction)) ∧
      (maxwellTimePartial magneticInduction 0 position time +
        maxwellSpatialPartial electricField 2 1 position time -
        maxwellSpatialPartial electricField 1 2 position time = 0) ∧
      (maxwellTimePartial magneticInduction 1 position time +
        maxwellSpatialPartial electricField 0 2 position time -
        maxwellSpatialPartial electricField 2 0 position time = 0) ∧
      (maxwellTimePartial magneticInduction 2 position time +
        maxwellSpatialPartial electricField 1 0 position time -
        maxwellSpatialPartial electricField 0 1 position time = 0)

end NumStability.Leveque02Tracer
