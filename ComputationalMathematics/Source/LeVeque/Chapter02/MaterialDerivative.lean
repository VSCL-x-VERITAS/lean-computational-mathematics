/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.MaterialDerivative
import ComputationalMathematics.Source.LeVeque.Chapter02.MaterialDerivativeTarget

/-!
# LeVeque's material derivative

The operator following (2.18) gives the actual rate seen by a moving particle.
This correspondence does not require a conservation equation.
-/

namespace NumStability.Leveque02Tracer

/-- The material derivative is time partial plus velocity times space partial. -/
theorem materialDerivative : materialDerivativeTarget := by
  intro E _ _ q velocity curve F qt qx t spaceDomain timeDomain characteristicTimes
    htime hcurveDomain hspaceUnique htimeUnique hF ht hx hcurve
  exact materialDerivative_hasDerivWithinAt htime hcurveDomain hspaceUnique htimeUnique
    hF ht hx hcurve

end NumStability.Leveque02Tracer
