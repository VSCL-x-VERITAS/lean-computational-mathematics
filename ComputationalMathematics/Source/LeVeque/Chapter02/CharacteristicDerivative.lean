/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.WithinCharacteristics
import ComputationalMathematics.Source.LeVeque.Chapter02.CharacteristicDerivativeTarget

/-!
# LeVeque equation (2.14)

The audited target retains the actual chain rule and advection derivatives on
compatible domains. Its classical scalar specialization is the source claim.
-/

namespace NumStability.Leveque02Tracer

/-- A characteristic of an advection solution has zero within-derivative. -/
theorem characteristicDerivative : characteristicDerivativeTarget := by
  intro E _ _ field jointDerivative velocity origin t spaceDomain timeDomain
    characteristicTimes htime hcurveDomain hspaceUnique htimeUnique hF hpde
  exact linearAdvection_hasDerivWithinAt_characteristic htime hcurveDomain
    hspaceUnique htimeUnique hF hpde

end NumStability.Leveque02Tracer
