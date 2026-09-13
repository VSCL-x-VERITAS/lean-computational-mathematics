/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidJacobianModel

/-!
# The actual gas-flux Jacobian

The target requires an actual Frechet derivative and identifies its matrix in
conserved and physical coordinates. Pressure derivatives are explicit witnesses.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.45) identifies the actual derivative and its physical-coordinate matrix. -/
def fluidJacobianTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (density velocity pressureSlope : ℝ), density ≠ 0 →
    HasDerivAt pressureLaw pressureSlope density →
    fluidFluxJacobian (fluidConservedState density velocity) pressureSlope =
      !![0, 1; -velocity ^ 2 + pressureSlope, 2 * velocity] ∧
    ∃ derivative : (Fin 2 → ℝ) →L[ℝ] (Fin 2 → ℝ),
      HasFDerivAt (fluidStateFlux pressureLaw) derivative (fluidConservedState density velocity) ∧
      LinearMap.toMatrix' derivative.toLinearMap =
        fluidFluxJacobian (fluidConservedState density velocity) pressureSlope

end NumStability.Leveque02Tracer
