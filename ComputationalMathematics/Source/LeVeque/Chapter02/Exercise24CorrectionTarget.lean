/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise24PrintedSimilarityTarget
import Mathlib.LinearAlgebra.Eigenspace.Matrix

/-!
# Proof-free corrected target: Exercise 2.4

The gas Jacobian has the speeds in (2.57) and explicit right eigenvectors.
Its similarity to the stationary pressure-velocity matrix requires adding the
background-velocity scalar matrix before changing coordinates.
-/

namespace NumStability.Leveque02Tracer

/-- The two gas eigenpairs and the exact velocity-shifted similarity that
replaces Exercise 2.4's false unshifted request. -/
def exercise24CorrectionTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (density velocity pressureSlope : ℝ),
    0 < density → 0 < pressureSlope →
    HasDerivAt pressureLaw pressureSlope density →
      let speed := Real.sqrt pressureSlope
      let bulkModulus := density * pressureSlope
      let gas := fluidFluxJacobian
        (fluidConservedState density velocity) pressureSlope
      let stationary := linearAcousticsMatrix bulkModulus density
      let left : Fin 2 → ℝ := ![1, velocity - speed]
      let right : Fin 2 → ℝ := ![1, velocity + speed]
      let T : Matrix (Fin 2) (Fin 2) ℝ :=
        !![pressureSlope⁻¹, 0;
          velocity * pressureSlope⁻¹, density]
      let TInv : Matrix (Fin 2) (Fin 2) ℝ :=
        !![pressureSlope, 0; -velocity * density⁻¹, density⁻¹]
      0 < speed ∧
      gas = !![0, 1; -velocity ^ 2 + pressureSlope, 2 * velocity] ∧
      gas.mulVec left = (velocity - speed) • left ∧ left ≠ 0 ∧
      gas.mulVec right = (velocity + speed) • right ∧ right ≠ 0 ∧
      T * TInv = 1 ∧ TInv * T = 1 ∧
      gas = T * (stationary + velocity • (1 : Matrix (Fin 2) (Fin 2) ℝ)) * TInv

end NumStability.Leveque02Tracer
