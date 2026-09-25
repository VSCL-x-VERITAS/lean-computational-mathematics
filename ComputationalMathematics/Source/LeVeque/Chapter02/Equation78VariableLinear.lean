/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Equation78VariableLinearTarget

/-!
# LeVeque Chapter 2, Equation (2.78): variable-coefficient linear system
-/

namespace NumStability.Leveque02Tracer

/-- The integrated variable-linear equation has precisely the displayed
classical solution relation, with coefficient dependent on space only. -/
theorem equation78VariableLinear : equation78VariableLinearTarget := by
  intro ι _ coefficient q x t
  simp [FirstOrderEquation.IsClassicalSolutionAt,
    FirstOrderEquation.variableLinear, FirstOrderEquation.residual]

end NumStability.Leveque02Tracer
