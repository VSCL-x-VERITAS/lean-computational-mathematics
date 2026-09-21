/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ReferenceLocationTarget

/-!
# Current material location
-/

namespace NumStability.Leveque02Tracer

/-- The planar reference-to-current map has the displayed coordinate value. -/
theorem currentMaterialLocationFormula : currentMaterialLocationTarget := by
  intro X Y x y t
  rfl

end NumStability.Leveque02Tracer
