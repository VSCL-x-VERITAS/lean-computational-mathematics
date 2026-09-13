/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PressureSlopeModel

/-!
# The pressure derivative assumption

The actual-derivative model condition is exactly the strict positivity
condition displayed in (2.37). Strict positivity of Mathlib's derivative
also rules out its zero value at a nondifferentiable point.
-/

namespace NumStability.Leveque02Tracer

/-- Actual positive pressure slopes express the printed derivative condition. -/
def pressureSlopeTarget : Prop :=
  ∀ pressureLaw : ℝ → ℝ,
    positivePressureSlope pressureLaw ↔
      ∀ density : ℝ, 0 < density → 0 < deriv pressureLaw density

end NumStability.Leveque02Tracer
