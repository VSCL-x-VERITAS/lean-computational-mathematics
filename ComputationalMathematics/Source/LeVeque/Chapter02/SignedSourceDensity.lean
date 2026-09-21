/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.SignedSourceDensityTarget

/-!
# LeVeque's signed source-density definition

This wrapper records the local `(q,x,t)` dependence and the convention that a
negative source-density value denotes a sink.
-/

namespace NumStability.Leveque02Tracer

/-- The signed local source-density model has the evaluation and sink semantics
specified in Section 2.5. -/
theorem signedSourceDensityDefinition : signedSourceDensityTarget := by
  intro sourceDensity state position time hnegative
  exact hnegative

end NumStability.Leveque02Tracer
