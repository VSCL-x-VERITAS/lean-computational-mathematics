/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.StrainRotationModel
import Mathlib.LinearAlgebra.Matrix.Notation

/-!
# Proof-free target for the P-wave in LeVeque Example 2.2

The traveling profile is used only for its planar displacement and
infinitesimal strain. No elasticity PDE solution is asserted.
-/

namespace NumStability.Leveque02Tracer

/-- An x-directed longitudinal profile has only its extensional strain
component potentially nonzero. -/
def example22PWaveTarget : Prop :=
  ∀ (waveform : ℝ → ℝ) (compressionSpeed x y t slope : ℝ),
    HasDerivAt waveform slope (x - compressionSpeed * t) →
      let X : ℝ → ℝ → ℝ → ℝ :=
        fun ξ _ τ => ξ + waveform (ξ - compressionSpeed * τ)
      let Y : ℝ → ℝ → ℝ → ℝ := fun _ η _ => η
      materialDisplacement X Y x y t =
        (waveform (x - compressionSpeed * t), 0) ∧
      infinitesimalStrain (displacementGradient X Y x y t) =
        !![slope, 0; 0, 0]

end NumStability.Leveque02Tracer
