/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Equation79ConservativeVariableLinearTarget

/-!
# LeVeque Chapter 2, Equation (2.79): conservative variable-coefficient system
-/

namespace NumStability.Leveque02Tracer

/-- The spatially dependent linear flux has exactly the displayed classical
conservation equation. -/
theorem equation79ConservativeVariableLinear :
    equation79ConservativeVariableLinearTarget := by
  intro ι _ coefficient
  refine ⟨fun x state => (coefficient x).mulVec state, ?_, ?_⟩
  · intro x state
    rfl
  · intro q x t
    rfl

end NumStability.Leveque02Tracer
