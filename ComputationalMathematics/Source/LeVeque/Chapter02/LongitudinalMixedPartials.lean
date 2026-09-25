/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LongitudinalMixedPartialsTarget

/-!
# LeVeque equation (2.92): longitudinal mixed partials

The mixed partials of material location are assumed to commute, as invoked
by the source. The two displayed identities then give the strain-velocity
compatibility equation.
-/

namespace NumStability.Leveque02Tracer

/-- The strain time derivative and velocity space derivative are the two
mixed partials displayed in (2.92), and agree when those partials commute. -/
theorem longitudinalMixedPartials : longitudinalMixedPartialsTarget := by
  intro X x t Xxt Xtx _ _ hspaceTime htimeSpace hcomm
  have hstrain : HasDerivAt (fun τ => longitudinalStrain X x τ) Xxt t := by
    simpa [longitudinalStrain] using hspaceTime.sub_const (1 : ℝ)
  have hvelocity : HasDerivAt
      (fun ξ => longitudinalMaterialVelocity X ξ t) Xtx x := by
    simpa [longitudinalMaterialVelocity] using htimeSpace
  refine ⟨hstrain, hvelocity, hstrain.deriv, hvelocity.deriv, ?_⟩
  exact (hstrain.deriv).trans (hcomm.trans hvelocity.deriv.symm)

end NumStability.Leveque02Tracer
