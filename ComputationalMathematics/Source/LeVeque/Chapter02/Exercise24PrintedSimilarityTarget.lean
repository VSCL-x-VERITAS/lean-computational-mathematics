/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidJacobianModel
import ComputationalMathematics.Source.LeVeque.Chapter02.StationaryAcousticsEigenvaluesTarget
import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Proof-free literal target: Exercise 2.4's stationary similarity request

The last clause of the printed exercise asks for similarity between the gas
Jacobian at arbitrary background velocity and the stationary acoustics matrix.
This target records that literal, universal assertion for refutation.
-/

namespace NumStability.Leveque02Tracer

/-- Literal unshifted similarity requested in the final sentence of
Exercise 2.4. It is false at nonzero background velocity. -/
def exercise24PrintedSimilarityTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (density velocity pressureSlope : ℝ),
    0 < density → 0 < pressureSlope →
    HasDerivAt pressureLaw pressureSlope density →
      let bulkModulus := density * pressureSlope
      let gas := fluidFluxJacobian
        (fluidConservedState density velocity) pressureSlope
      let stationary := linearAcousticsMatrix bulkModulus density
      ∃ (S SInv : Matrix (Fin 2) (Fin 2) ℝ),
        S * SInv = 1 ∧ SInv * S = 1 ∧
          gas = S * stationary * SInv

end NumStability.Leveque02Tracer
