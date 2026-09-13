/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.IsentropicPressureModel

/-!
# Isentropic pressure evaluated along the density field

This is the specified real-power constitutive equation on the model domain.
The empirical example and the later slope condition are separate claims.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.35) evaluates the specified real-power law along the density field. -/
def isentropicPressureTarget : Prop :=
  ∀ (coefficient exponent : ℝ) (spaceTimeDomain : Set (ℝ × ℝ))
    (density : spaceTimeDomain → Set.Ioi (0 : ℝ)) (location : spaceTimeDomain),
    pressureOnDomains (Set.Ioi 0) spaceTimeDomain
      (isentropicPressureLaw coefficient exponent) density location =
        coefficient * (density location : ℝ) ^ exponent

end NumStability.Leveque02Tracer
