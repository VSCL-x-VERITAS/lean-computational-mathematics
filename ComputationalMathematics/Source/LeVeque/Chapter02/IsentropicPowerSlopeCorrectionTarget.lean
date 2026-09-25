/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.IsentropicPowerSlope

/-!
# LeVeque Chapter 2: IsentropicPowerSlopeCorrectionTarget

Target and counterexample for the printed pressure-slope assertion.
-/

namespace NumStability.Leveque02Tracer

/-- The power-law pressure slope is positive at every positive density exactly
when the product of the coefficient and exponent is positive. The printed
unqualified assertion has a zero-coefficient counterexample. -/
def isentropicPowerSlopeCorrectionTarget : Prop :=
  (∀ (coefficient exponent : ℝ),
    positivePressureSlope (fun density : ℝ => coefficient * density ^ exponent) ↔
      0 < coefficient * exponent) ∧
  ¬ positivePressureSlope (fun density : ℝ => (0 : ℝ) * density ^ (2 : ℝ))

end NumStability.Leveque02Tracer
