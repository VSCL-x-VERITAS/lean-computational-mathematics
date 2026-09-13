/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.WithinDomains
import ComputationalMathematics.Source.LeVeque.Chapter02.AdvectionWithinProfileTarget

/-!
# LeVeque's translated advection profile on explicit domains

The source's smooth classical instances are included in the domain-aware
transport theorem. On more general sets the conclusion selects derivative
witnesses satisfying the equation; it does not assert uniqueness of every
possible within-derivative value.
-/

namespace NumStability.Leveque02Tracer

/-- The audited domain-aware strengthening of the forward assertion in (2.13). -/
theorem advectionWithinProfile : advectionWithinProfileTarget := by
  intro profile profileDerivative velocity x t spaceDomain timeDomain profileDomain
    _hx _ht hspace htime hprofile
  simpa only [IsLinearAdvectionSolutionWithinAt, smul_eq_mul] using
    travelingWave_isLinearAdvectionSolutionWithinAt velocity x t
      spaceDomain timeDomain profileDomain hspace htime hprofile

end NumStability.Leveque02Tracer
