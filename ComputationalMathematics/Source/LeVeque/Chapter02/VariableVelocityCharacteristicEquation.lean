/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.VariableVelocityCharacteristicEquationTarget

/-!
# LeVeque equation (2.17): variable-velocity characteristic equation

The source uses the ordinary derivative along a characteristic. On a time
domain with unique within-domain derivatives, its derivative predicate is
equivalent to the displayed derivative equation. Local existence is handled
separately by `variableVelocityCharacteristicExistence`.
-/

namespace NumStability.Leveque02Tracer

/-- A supplied differentiable characteristic satisfying the ODE derivative
predicate has the derivative value displayed in equation (2.17). -/
theorem variableVelocityCharacteristicEquation :
    variableVelocityCharacteristicEquationTarget := by
  intro velocity curve initialPoint timeDomain _ hinitial hunique hcurve
  refine ⟨hinitial, ?_⟩
  intro t ht
  exact (hcurve t ht).derivWithin (hunique t ht)

end NumStability.Leveque02Tracer
