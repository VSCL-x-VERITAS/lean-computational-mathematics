/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMassLabelTarget

/-!
# LeVeque equation (2.102): initial-density particle labels
-/

namespace NumStability.Leveque02Tracer

/-- The label definition is exactly the oriented initial-density integral. -/
theorem lagrangianMassLabelFormula : lagrangianMassLabelTarget := by
  intro initialDensity referenceLocation x _
  rfl

end NumStability.Leveque02Tracer
