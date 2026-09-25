/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.VariableVelocityCharacteristicExistenceTarget

/-!
# Local existence of variable-velocity characteristics

The source leaves the regularity of the velocity implicit. This theorem gives
a local characteristic under an explicit continuously differentiable hypothesis.
-/

namespace NumStability.Leveque02Tracer

/-- A continuously differentiable velocity has a local characteristic through
the prescribed initial point. -/
theorem variableVelocityCharacteristicExistence :
    variableVelocityCharacteristicExistenceTarget := by
  intro velocity initialPoint hvelocity
  simpa [variableVelocityCharacteristicExistenceTarget] using
    hvelocity.exists_forall_mem_closedBall_exists_eq_forall_mem_Ioo_hasDerivAt₀ 0

end NumStability.Leveque02Tracer
