/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaterialDisplacementTarget

/-!
# LeVeque equation (2.83): planar displacement components
-/

namespace NumStability.Leveque02Tracer

/-- The displacement from reference to current position is the coordinate difference. -/
theorem materialDisplacementFormula : materialDisplacementTarget := by
  intro X Y x y t
  rfl

end NumStability.Leveque02Tracer
