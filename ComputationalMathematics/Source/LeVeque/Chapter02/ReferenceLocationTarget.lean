/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ReferenceLocationModel

/-!
# Reference-to-current location correspondence

The target states the coordinate definition preceding equation (2.83).
-/

namespace NumStability.Leveque02Tracer

/-- The current location has coordinate fields `X(x,y,t)` and `Y(x,y,t)`. -/
def currentMaterialLocationTarget : Prop :=
  ∀ (X Y : ℝ → ℝ → ℝ → ℝ) (x y t : ℝ),
    currentMaterialLocation X Y x y t = (X x y t, Y x y t)

end NumStability.Leveque02Tracer
