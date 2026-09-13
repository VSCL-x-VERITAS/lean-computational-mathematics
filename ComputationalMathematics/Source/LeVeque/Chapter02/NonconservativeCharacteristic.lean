/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.NonconservativeCharacteristics
import ComputationalMathematics.Source.LeVeque.Chapter02.NonconservativeCharacteristicTarget

/-!
# LeVeque's nonconservative characteristic constancy

The assertion following (2.19) follows from the actual material derivative
and continuous extension from the interior of each characteristic segment.
-/

namespace NumStability.Leveque02Tracer

/-- A solution of nonconservative advection stays constant along its particle characteristics. -/
theorem nonconservativeCharacteristic : nonconservativeCharacteristicTarget := by
  intro E _ _ q velocity curve F qt qx a b spaceDomain timeDomain hab hcurveDomain
    hcontinuous hderivatives
  exact nonconservativeTransport_characteristic_eq hab hcurveDomain hcontinuous hderivatives

end NumStability.Leveque02Tracer
