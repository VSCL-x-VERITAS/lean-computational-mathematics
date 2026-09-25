/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.StrainRotationModel
import Mathlib.LinearAlgebra.Matrix.Notation

/-!
# Proof-free target for the S-wave in LeVeque Example 2.2

The traveling profile is used only for its planar displacement and
infinitesimal strain. No elasticity PDE solution is asserted.
-/

namespace NumStability.Leveque02Tracer

/-- An x-directed transverse profile has equal shear strain entries and no
extensional strain. -/
def example22SWaveTarget : Prop :=
  ∀ (waveform : ℝ → ℝ) (shearSpeed x y t slope : ℝ),
    HasDerivAt waveform slope (x - shearSpeed * t) →
      let X : ℝ → ℝ → ℝ → ℝ := fun ξ _ _ => ξ
      let Y : ℝ → ℝ → ℝ → ℝ :=
        fun ξ η τ => η + waveform (ξ - shearSpeed * τ)
      materialDisplacement X Y x y t =
        (0, waveform (x - shearSpeed * t)) ∧
      infinitesimalStrain (displacementGradient X Y x y t) =
        !![0, slope / 2; slope / 2, 0]

end NumStability.Leveque02Tracer
