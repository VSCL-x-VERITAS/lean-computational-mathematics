/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.IntegralFluxDerivativeLocalTarget

/-!
# LeVeque equation (2.8)

Mathlib's fundamental theorem of calculus rewrites the endpoint flux difference
as minus the integral of the actual spatial flux derivative. The audited target
keeps the time derivative attached to ordinary, locally defined mass integrals.
-/

namespace NumStability.Leveque02Tracer

/-- The integral conservation balance has the spatial flux-derivative form (2.8). -/
theorem integralFluxDerivative : integralFluxDerivativeLocalTarget := by
  intro q flux fluxDerivative a b t hab _hmass hcontinuous hderivative hintegrable
  have hFTC := intervalIntegral.integral_eq_sub_of_hasDerivAt_of_le
    hab hcontinuous hderivative hintegrable
  rw [hFTC, neg_sub]

end NumStability.Leveque02Tracer
