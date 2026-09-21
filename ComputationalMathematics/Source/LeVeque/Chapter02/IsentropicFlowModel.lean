/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Set.Image
import Mathlib.Data.Real.Basic

/-!
# Isentropic flow

The state type is left generic: this definition says only that the entropy
field has the same value at every pair of admissible states.
-/

namespace NumStability.Leveque02Tracer

/-- A flow is isentropic when its entropy field is constant. -/
def IsIsentropic {State : Type*} (entropy : State → ℝ) : Prop :=
  ∀ a b, entropy a = entropy b

end NumStability.Leveque02Tracer
