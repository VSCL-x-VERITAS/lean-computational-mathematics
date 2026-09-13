/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.WithinDomains

/-!
# Conservation laws on relative domains

Actual partial derivative witnesses describe a conservation residual on
spatial and temporal slices. For constant scalar multiplication as the flux,
the conservation equation is equivalent to linear advection whenever the
state has a spatial derivative on a uniquely differentiable spatial domain.
-/

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Selected derivative witnesses satisfy a conservation law on relative slices. -/
def IsConservationLawSolutionWithinAt (q : ℝ → ℝ → E) (flux : E → E) (x t : ℝ)
    (spaceDomain timeDomain : Set ℝ) : Prop :=
  ∃ qt fluxDerivative : E,
    HasDerivWithinAt (fun τ => q x τ) qt timeDomain t ∧
    HasDerivWithinAt (fun ξ => flux (q ξ t)) fluxDerivative spaceDomain x ∧
    qt + fluxDerivative = 0

/-- A constant scalar flux gives precisely the relative linear-advection equation. -/
theorem conservationLaw_const_smul_iff_linearAdvectionWithinAt
    {q : ℝ → ℝ → E} {speed x t : ℝ} {qx : E} {spaceDomain timeDomain : Set ℝ}
    (hspace : UniqueDiffWithinAt ℝ spaceDomain x)
    (hqx : HasDerivWithinAt (fun ξ => q ξ t) qx spaceDomain x) :
    IsConservationLawSolutionWithinAt q (fun state => speed • state) x t
      spaceDomain timeDomain ↔
      IsLinearAdvectionSolutionWithinAt q speed x t spaceDomain timeDomain := by
  constructor
  · rintro ⟨qt, fluxDerivative, hqt, hflux, hzero⟩
    have hlinear : HasDerivWithinAt (fun ξ => speed • q ξ t) (speed • qx)
        spaceDomain x := hqx.const_smul speed
    have hvalue : fluxDerivative = speed • qx := hspace.eq_deriv _ hflux hlinear
    exact ⟨qt, qx, hqt, hqx, hvalue ▸ hzero⟩
  · rintro ⟨qt, qx', hqt, hqx', hzero⟩
    exact ⟨qt, speed • qx', hqt, hqx'.const_smul speed, hzero⟩

end NumStability
