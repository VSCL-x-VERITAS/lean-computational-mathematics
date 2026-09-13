/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidJacobianModel

/-!
# Gas-flux Jacobian on supplied model domains

The admissible pressure-law family and each law-specific physical-state domain
are explicit. The target computes an actual derivative at a selected state.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.45) for a supplied admissible law and its physical-state domain. -/
def domainFluidJacobianTarget : Prop :=
  ∀ (admissiblePressureLaws : Set (ℝ → ℝ))
    (admissibleStates : admissiblePressureLaws → Set (ℝ × ℝ))
    (pressureLaw : admissiblePressureLaws) (state : admissibleStates pressureLaw)
    (pressureSlope : ℝ), state.val.1 ≠ 0 →
    HasDerivAt (pressureLaw : ℝ → ℝ) pressureSlope state.val.1 →
    fluidFluxJacobian (fluidConservedState state.val.1 state.val.2) pressureSlope =
      !![0, 1; -state.val.2 ^ 2 + pressureSlope, 2 * state.val.2] ∧
    ∃ derivative : (Fin 2 → ℝ) →L[ℝ] (Fin 2 → ℝ),
      HasFDerivAt (fluidStateFlux pressureLaw) derivative
        (fluidConservedState state.val.1 state.val.2) ∧
      LinearMap.toMatrix' derivative.toLinearMap =
        fluidFluxJacobian (fluidConservedState state.val.1 state.val.2) pressureSlope

end NumStability.Leveque02Tracer
