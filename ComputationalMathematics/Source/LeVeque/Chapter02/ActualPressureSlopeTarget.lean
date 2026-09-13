/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PressureSlopeModel

/-!
# The pressure slope condition with actual derivatives

The source condition is expressed using derivative existence and positivity
of its unique actual value at every positive density. This formulation does
not evaluate a totalized derivative operator at a nondifferentiable point.
-/

namespace NumStability.Leveque02Tracer

/-- The chosen pressure law is differentiable with positive actual slopes. -/
def actualPressureSlopeTarget : Prop :=
  ∀ pressureLaw : ℝ → ℝ,
    positivePressureSlope pressureLaw ↔
      ∀ density : ℝ, 0 < density →
        DifferentiableAt ℝ pressureLaw density ∧
        ∀ slope : ℝ, HasDerivAt pressureLaw slope density → 0 < slope

end NumStability.Leveque02Tracer
