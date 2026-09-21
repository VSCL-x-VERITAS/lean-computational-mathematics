/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.IsentropicFlowModel

/-!
# Isentropic-flow target

The proof-free target connects the source-specific definition to the generic
Mathlib statement that the range of the entropy field is a subsingleton.
-/

namespace NumStability.Leveque02Tracer

/-- Constant entropy is equivalently a subsingleton entropy range. -/
def isIsentropicTarget : Prop :=
  ∀ (State : Type) (entropy : State → ℝ),
    IsIsentropic entropy ↔ (Set.range entropy).Subsingleton

end NumStability.Leveque02Tracer
