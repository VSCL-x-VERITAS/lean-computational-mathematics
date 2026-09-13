/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FickFluxTarget

/-!
# Fick flux formula

The source's constitutive flux formula is the defining value of the scalar
gradient-state model. Its physical interpretation is recorded in FickFluxModel.
-/

namespace NumStability.Leveque02Tracer

/-- The Fick flux model has the value displayed in equation (2.20). -/
theorem fickFluxFormula : fickFluxTarget := by
  intro coefficient gradient
  rfl

end NumStability.Leveque02Tracer
