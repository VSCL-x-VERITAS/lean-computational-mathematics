/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidJacobianModel
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity

/-!
# LeVeque Chapter 2: PositivePressureSlopeNecessaryTarget

Target for pressure-slope necessity in the Euler eigensystem.
-/

namespace NumStability.Leveque02Tracer

/-- At positive density, a complete real eigenbasis for the actual gas-flux
Jacobian exists exactly at positive pressure slope. The zero-slope case is
separately stated to expose the defective repeated eigenvalue. -/
def positivePressureSlopeNecessaryTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (density velocity pressureSlope : ℝ),
    0 < density → HasDerivAt pressureLaw pressureSlope density →
    let A := fluidFluxJacobian (fluidConservedState density velocity) pressureSlope
    (IsRealHyperbolicMatrix A ↔ 0 < pressureSlope) ∧
      (pressureSlope = 0 → ¬ IsRealHyperbolicMatrix A)

end NumStability.Leveque02Tracer
