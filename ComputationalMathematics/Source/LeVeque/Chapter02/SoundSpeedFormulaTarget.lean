/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Sqrt

/-!
# Acoustic sound-speed formula
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.55) introduces the positive acoustic speed determined by the
positive bulk modulus and background density. -/
def soundSpeedFormulaTarget : Prop :=
  ∀ (bulkModulus density : ℝ), 0 < bulkModulus → 0 < density →
    ∃ soundSpeed : ℝ,
      soundSpeed = Real.sqrt (bulkModulus / density) ∧ 0 < soundSpeed

end NumStability.Leveque02Tracer
