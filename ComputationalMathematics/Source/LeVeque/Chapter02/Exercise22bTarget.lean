/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.IsentropicSoundSpeedTarget
import Mathlib.LinearAlgebra.Eigenspace.Matrix

/-!
# Proof-free target: Exercise 2.2(b)

The quasilinear coefficient below is the pressure-velocity matrix of (2.122).
The conservative coefficient is the flux Jacobian of (2.38). Both are
evaluated at the same positive-density state and actual pressure slope.
-/

namespace NumStability.Leveque02Tracer

/-- The pressure-velocity coefficient in the nonlinear primitive gas system. -/
noncomputable def primitiveGasCoefficient (density velocity pressureSlope : ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  !![velocity, density * pressureSlope; density⁻¹, velocity]

/-- If `P'(ρ)>0`, the primitive system (2.122) is strictly hyperbolic with
exactly the two real speeds of the conservative gas Jacobian (2.38). -/
def exercise22bTarget : Prop :=
  ∀ (pressureLaw densityFromPressure : ℝ → ℝ)
    (density velocity pressureSlope : ℝ),
    0 < density → 0 < pressureSlope →
    HasDerivAt pressureLaw pressureSlope density →
    densityFromPressure (pressureLaw density) = density →
      let speed := Real.sqrt pressureSlope
      let primitive := primitiveGasCoefficient density velocity pressureSlope
      let conservative := fluidFluxJacobian
        (fluidConservedState density velocity) pressureSlope
      0 < speed ∧
      velocity - speed < velocity + speed ∧
      IsRealHyperbolicMatrix primitive ∧
      IsRealHyperbolicMatrix conservative ∧
      Module.End.HasEigenvalue (Matrix.toLin' primitive) (velocity - speed) ∧
      Module.End.HasEigenvalue (Matrix.toLin' primitive) (velocity + speed) ∧
      Module.End.HasEigenvalue (Matrix.toLin' conservative) (velocity - speed) ∧
      Module.End.HasEigenvalue (Matrix.toLin' conservative) (velocity + speed)

end NumStability.Leveque02Tracer
