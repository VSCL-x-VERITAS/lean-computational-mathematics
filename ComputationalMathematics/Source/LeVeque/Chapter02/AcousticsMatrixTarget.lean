/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidJacobianModel

/-!
# The constant acoustics matrix in conserved coordinates

Identify the actual gas-flux derivative at the fixed density/momentum
background. The matrix is independent of space and time.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.46) identifies the constant matrix at the background conserved state. -/
def acousticsMatrixTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (densityBackground velocityBackground pressureSlope : ℝ),
    densityBackground ≠ 0 → HasDerivAt pressureLaw pressureSlope densityBackground →
    ∃ derivative : (Fin 2 → ℝ) →L[ℝ] (Fin 2 → ℝ),
      HasFDerivAt (fluidStateFlux pressureLaw) derivative
        (fluidConservedState densityBackground velocityBackground) ∧
      LinearMap.toMatrix' derivative.toLinearMap =
        !![0, 1; -velocityBackground ^ 2 + pressureSlope, 2 * velocityBackground]

end NumStability.Leveque02Tracer
