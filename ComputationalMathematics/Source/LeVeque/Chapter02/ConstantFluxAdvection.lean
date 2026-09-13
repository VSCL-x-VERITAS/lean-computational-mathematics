/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.WithinDomains
import ComputationalMathematics.Source.LeVeque.Chapter02.ConstantFluxAdvectionTarget

/-!
# LeVeque equation (2.12)

The audited target relates the actual derivatives of a constant flux to the
advection equation. Its real-valued classical specialization is the source's
constant-velocity reformulation of the differential conservation law.
-/

namespace NumStability.Leveque02Tracer

/-- Constant-velocity flux converts the conservation equation to advection. -/
theorem constantFluxAdvection : constantFluxAdvectionTarget := by
  intro E _ _ field velocity x t spatialDerivative spaceDomain timeDomain _hx _ht hspace hqx
  exact conservationLaw_const_smul_iff_linearAdvectionWithinAt hspace hqx

end NumStability.Leveque02Tracer
