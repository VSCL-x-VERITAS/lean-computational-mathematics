/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidJacobianModel
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import Mathlib.Analysis.SpecialFunctions.Pow.Continuity
import Mathlib.Analysis.SpecialFunctions.Pow.Deriv
import Mathlib.LinearAlgebra.Eigenspace.Matrix

/-!
# Proof-free target for LeVeque equation (2.82) and its Example 2.1 scope

The pointwise sound-speed formula and the positive-density power-law vacuum
limit have different hypotheses. In particular, the limiting assertion needs
an exponent above one and makes no evaluation of the gas Jacobian at vacuum.
-/

namespace NumStability.Leveque02Tracer

/-- Positive pressure slope gives sound speed `√P'(ρ)`, the two real distinct
gas-Jacobian speeds, and pointwise strict hyperbolicity. For a positive
power-law coefficient and exponent above one, the sound speed tends to zero
as positive density approaches vacuum. -/
def isentropicSoundSpeedTarget : Prop :=
  (∀ (pressureLaw : ℝ → ℝ) (density velocity pressureSlope : ℝ),
    0 < density → 0 < pressureSlope →
    HasDerivAt pressureLaw pressureSlope density →
    let soundSpeed := Real.sqrt pressureSlope
    let jacobian := fluidFluxJacobian (fluidConservedState density velocity) pressureSlope
    0 < soundSpeed ∧
      Module.End.HasEigenvalue (Matrix.toLin' jacobian) (velocity - soundSpeed) ∧
      Module.End.HasEigenvalue (Matrix.toLin' jacobian) (velocity + soundSpeed) ∧
      velocity - soundSpeed < velocity + soundSpeed ∧
      IsRealHyperbolicMatrix jacobian) ∧
  (∀ (coefficient exponent : ℝ), 0 < coefficient → 1 < exponent →
    (∀ density : ℝ, 0 < density →
      HasDerivAt (fun r : ℝ => coefficient * r ^ exponent)
        (coefficient * (exponent * density ^ (exponent - 1))) density) ∧
    Filter.Tendsto
      (fun density : ℝ => Real.sqrt
        (coefficient * (exponent * density ^ (exponent - 1))))
      (nhdsWithin (0 : ℝ) (Set.Ioi 0)) (nhds 0))

end NumStability.Leveque02Tracer
