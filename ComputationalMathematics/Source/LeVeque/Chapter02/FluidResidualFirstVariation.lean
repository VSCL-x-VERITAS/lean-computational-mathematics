/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidResidualFirstVariationTarget

/-!
# LeVeque equation (2.44) as a first variation

Differentiate the full nonlinear time-plus-flux residual of
`q₀ + ε • q̃` at zero amplitude. This result characterizes the linearized
equation and makes no claim that a finite disturbance exactly solves it.
-/

namespace NumStability.Leveque02Tracer

/-- The first residual variation is the fixed-background linear acoustic
operator, and its vanishing is equation (2.44). -/
theorem fluidResidualFirstVariation : fluidResidualFirstVariationTarget := by
  intro pressureLaw densityBackground velocityBackground fluxDerivative
    perturbation x t perturbationTime perturbationSpace _hDensity
    htime hspace hcontinuous hflux
  dsimp only
  have hbackground : HasFDerivAt (fluidStateFlux pressureLaw)
      (fluxDerivative (fluidConservedState densityBackground velocityBackground))
      (fluidConservedState densityBackground velocityBackground) := by
    simpa only [zero_smul, add_zero] using hflux.self_of_nhds
  have hvariation := NumStability.amplitudeConservationResidual_hasDerivAt
    (fluidConservedState densityBackground velocityBackground)
    (fluidStateFlux pressureLaw) fluxDerivative perturbation x t
    perturbationTime perturbationSpace htime hspace hcontinuous hflux
  have hzero := NumStability.amplitudeConservationResidual_zeroVariation_iff
    (fluidConservedState densityBackground velocityBackground)
    (fluidStateFlux pressureLaw) fluxDerivative perturbation x t
    perturbationTime perturbationSpace htime hspace hcontinuous hflux
  refine ⟨hbackground, hvariation, ?_⟩
  simpa only [LinearMap.toMatrix'_mulVec, ContinuousLinearMap.coe_coe] using hzero

end NumStability.Leveque02Tracer
