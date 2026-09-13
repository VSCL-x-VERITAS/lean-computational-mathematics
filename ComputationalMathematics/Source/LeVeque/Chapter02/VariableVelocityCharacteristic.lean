/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.VariableVelocityCharacteristics
import ComputationalMathematics.Source.LeVeque.Chapter02.VariableVelocityCharacteristicTarget

/-!
# LeVeque's conservative variable-velocity characteristic identity

Equation (2.18) follows from the actual chain and product rules on the physical
domain. The independently audited target permits arbitrary real normed values.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.18): the density rate along a characteristic is minus velocity divergence times density. -/
theorem variableVelocityCharacteristic : variableVelocityCharacteristicTarget := by
  intro E _ _ q velocity curve F velocityDerivative t spaceDomain timeDomain characteristicTimes
    htime hcurveDomain hspaceUnique htimeUnique hF hvelocity hcurve hpde
  exact conservativeTransport_hasDerivWithinAt_characteristic htime hcurveDomain
    hspaceUnique htimeUnique hF hvelocity hcurve hpde

end NumStability.Leveque02Tracer
