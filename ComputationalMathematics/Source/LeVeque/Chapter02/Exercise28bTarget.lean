/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise28aTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.GenericPSystemNotationTarget
import Mathlib.Analysis.Calculus.Deriv.Inv
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic

/-!
# Proof-free target: Exercise 2.8(b)

The isothermal pressure law is linearized at a positive constant specific
volume. The characteristic speeds of its p-system matrix are in mass-label
coordinates. A uniform particle map converts them to Eulerian speeds.
-/

namespace NumStability.Leveque02Tracer

/-- The first amplitude variation of the isothermal p-system flux has the
matrix `[[0,−1],[−a²/V₀²,0]]`. Its label-coordinate speeds convert to the
Eulerian speeds from Exercise 2.8(a). -/
def exercise28bTarget : Prop :=
  ∀ (a volumeBackground velocityBackground : ℝ),
    0 < volumeBackground →
    let pressureLaw : ℝ → ℝ := fun volume => a ^ 2 / volume
    let pressureSlope := -(a ^ 2 / volumeBackground ^ 2)
    let coefficient : Matrix (Fin 2) (Fin 2) ℝ :=
      !![0, -1; pressureSlope, 0]
    HasDerivAt pressureLaw pressureSlope volumeBackground ∧
      (∀ volumeVariation velocityVariation : ℝ,
        HasDerivAt
          (fun amplitude : ℝ =>
            -(velocityBackground + amplitude * velocityVariation))
          (-velocityVariation) 0 ∧
        HasDerivAt
          (fun amplitude : ℝ =>
            pressureLaw (volumeBackground + amplitude * volumeVariation))
          (pressureSlope * volumeVariation) 0) ∧
      (∀ (volumeVariation velocityVariation : ℝ → ℝ → ℝ)
          (label time volumeTime volumeSpace velocityTime velocitySpace : ℝ),
        HasDerivAt (volumeVariation label) volumeTime time →
        HasDerivAt (fun ξ => volumeVariation ξ time) volumeSpace label →
        HasDerivAt (velocityVariation label) velocityTime time →
        HasDerivAt (fun ξ => velocityVariation ξ time) velocitySpace label →
        HasDerivAt
          (fun amplitude : ℝ =>
            deriv (fun τ =>
              volumeBackground + amplitude * volumeVariation label τ) time -
            deriv (fun ξ =>
              velocityBackground + amplitude * velocityVariation ξ time) label)
          (volumeTime - velocitySpace) 0 ∧
        HasDerivAt
          (fun amplitude : ℝ =>
            deriv (fun τ =>
              velocityBackground + amplitude * velocityVariation label τ) time +
            deriv (fun ξ =>
              pressureLaw (volumeBackground +
                amplitude * volumeVariation ξ time)) label)
          (velocityTime + pressureSlope * volumeSpace) 0) ∧
      (∀ variationTime variationSpace : Fin 2 → ℝ,
        variationTime + coefficient.mulVec variationSpace = 0 ↔
          variationTime 0 - variationSpace 1 = 0 ∧
            variationTime 1 -
              (a ^ 2 / volumeBackground ^ 2) * variationSpace 0 = 0) ∧
      (∀ eigenvalue : ℝ,
        Matrix.det (coefficient - eigenvalue •
          (1 : Matrix (Fin 2) (Fin 2) ℝ)) = 0 ↔
          eigenvalue = -a / volumeBackground ∨
            eigenvalue = a / volumeBackground) ∧
      (∀ referenceLocation label labelSpeed : ℝ,
        HasDerivAt
          (fun time : ℝ => referenceLocation +
            volumeBackground * (label + labelSpeed * time) +
              velocityBackground * time)
          (velocityBackground + volumeBackground * labelSpeed) 0) ∧
      velocityBackground + volumeBackground * (-a / volumeBackground) =
        velocityBackground - a ∧
      velocityBackground + volumeBackground * (a / volumeBackground) =
        velocityBackground + a

end NumStability.Leveque02Tracer
