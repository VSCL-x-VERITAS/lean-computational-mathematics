/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.InitialProfileTarget

/-!
# LeVeque's prescribed initial profile

Equation (2.15) identifies the initial-time slice with the prescribed profile.
Function extensionality gives the pointwise form of this condition.
-/

namespace NumStability.Leveque02Tracer

/-- Function equality and the pointwise initial-data condition in (2.15) agree. -/
theorem initialProfileDefinition : initialProfileTarget := by
  intro field initial initialTime
  exact funext_iff

end NumStability.Leveque02Tracer
