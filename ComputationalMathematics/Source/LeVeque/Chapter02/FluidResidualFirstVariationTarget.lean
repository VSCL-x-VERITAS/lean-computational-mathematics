/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FirstVariation
import ComputationalMathematics.Source.LeVeque.Chapter02.FluidStateFluxModel
import Mathlib.LinearAlgebra.Matrix.ToLin

/-!
# First variation of the isentropic fluid conservation residual

The exact amplitude derivative below gives the mathematical meaning of
discarding higher-order terms in LeVeque (2.44). The pressure-law flux is the
one in (2.40), the background has positive density, and the derivative field
is required to be an actual derivative at nearby amplitude states. Vanishing
of the first residual variation, rather than the state decomposition alone,
is equivalent to the linearized equation.
-/

open Filter

namespace NumStability.Leveque02Tracer

/-- Equation (2.44) as the zero first variation of the actual nonlinear
conservation residual at a fixed positive-density fluid state. -/
def fluidResidualFirstVariationTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (densityBackground velocityBackground : ℝ)
    (fluxDerivative : (Fin 2 → ℝ) → ((Fin 2 → ℝ) →L[ℝ] (Fin 2 → ℝ)))
    (perturbation : ℝ → ℝ → (Fin 2 → ℝ)) (x t : ℝ)
    (perturbationTime perturbationSpace : Fin 2 → ℝ),
    0 < densityBackground →
    HasDerivAt (perturbation x) perturbationTime t →
    HasDerivAt (fun ξ => perturbation ξ t) perturbationSpace x →
    ContinuousAt (fun ε : ℝ =>
      fluxDerivative
        (fluidConservedState densityBackground velocityBackground +
          ε • perturbation x t) perturbationSpace) 0 →
    (∀ᶠ ε : ℝ in nhds (0 : ℝ),
      HasFDerivAt (fluidStateFlux pressureLaw)
        (fluxDerivative
          (fluidConservedState densityBackground velocityBackground +
            ε • perturbation x t))
        (fluidConservedState densityBackground velocityBackground +
          ε • perturbation x t)) →
    let background := fluidConservedState densityBackground velocityBackground
    let residual := NumStability.amplitudeConservationResidual
      background (fluidStateFlux pressureLaw) perturbation x t
    HasFDerivAt (fluidStateFlux pressureLaw)
      (fluxDerivative background) background ∧
    HasDerivAt residual
      (perturbationTime + fluxDerivative background perturbationSpace) 0 ∧
    (HasDerivAt residual 0 0 ↔
      perturbationTime +
        (LinearMap.toMatrix' (fluxDerivative background).toLinearMap).mulVec
          perturbationSpace = 0)

end NumStability.Leveque02Tracer
