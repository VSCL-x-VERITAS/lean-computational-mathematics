/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaterialDisplacementModel

/-!
# LeVeque equation (2.83): displacement components
-/

namespace NumStability.Leveque02Tracer

/-- The displacement components are the current coordinates minus the reference coordinates. -/
def materialDisplacementTarget : Prop :=
  ∀ (X Y : ℝ → ℝ → ℝ → ℝ) (x y t : ℝ),
    materialDisplacement X Y x y t = (X x y t - x, Y x y t - y)

end NumStability.Leveque02Tracer
