/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellDivergenceModel

/-!
# Proof-free target for LeVeque equation (2.111)
-/

namespace NumStability.Leveque02Tracer

/-- The charge-free electric-displacement constraint `div D = 0` is exactly
the sum of its three Cartesian diagonal spatial partials. -/
def electricGaussTarget : Prop :=
  ∀ (electricDisplacement : MaxwellField)
    (position : MaxwellVector) (time : ℝ),
    IsMaxwellDivergenceFreeAt electricDisplacement position time ↔
      (∀ component,
        HasDerivAt
          (fun s => electricDisplacement
            (Function.update position component s) time component)
          (maxwellSpatialPartial electricDisplacement component component
            position time)
          (position component)) ∧
      maxwellSpatialPartial electricDisplacement 0 0 position time +
        maxwellSpatialPartial electricDisplacement 1 1 position time +
        maxwellSpatialPartial electricDisplacement 2 2 position time = 0

end NumStability.Leveque02Tracer
