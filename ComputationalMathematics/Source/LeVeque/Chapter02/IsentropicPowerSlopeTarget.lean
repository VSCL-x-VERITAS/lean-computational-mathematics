/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.IsentropicPressureModel
import ComputationalMathematics.Source.LeVeque.Chapter02.PressureSlopeModel
import Mathlib.Analysis.SpecialFunctions.Pow.Deriv

/-!
# Positive slope of the isentropic power law

The source says the power law (2.35) has the positive-derivative property
(2.37) while describing its parameters only as constants. The physically
positive coefficient and exponent are explicit here; without a sign condition
the derivative need not be positive.
-/

namespace NumStability.Leveque02Tracer

/-- Positive gas parameters make the source's positive-density power law a
strictly increasing pressure model in the actual-derivative sense. -/
def isentropicPowerSlopeTarget : Prop :=
  ∀ (coefficient exponent : ℝ), 0 < coefficient → 0 < exponent →
    (∀ density : Set.Ioi (0 : ℝ),
      isentropicPressureLaw coefficient exponent density =
        coefficient * (density : ℝ) ^ exponent) ∧
    positivePressureSlope (fun density : ℝ => coefficient * density ^ exponent)

end NumStability.Leveque02Tracer
