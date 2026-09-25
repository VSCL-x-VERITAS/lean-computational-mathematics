/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.StrainRotationModel
/-! A rigid translation has spatially constant displacement, hence zero strain. -/

namespace NumStability.Leveque02Tracer

/-- A translated material position `(x + a(t), y + b(t))` has displacement
`(a(t), b(t))`, zero spatial displacement gradient, and zero strain.
LeVeque Chapter 2, page 59 (raw PDF). -/
def rigidTranslationStrainTarget : Prop :=
  ∀ (a b : ℝ → ℝ) (x y t : ℝ),
    let X : ℝ → ℝ → ℝ → ℝ := fun ξ _ τ => ξ + a τ
    let Y : ℝ → ℝ → ℝ → ℝ := fun _ η τ => η + b τ
    materialDisplacement X Y x y t = (a t, b t) ∧
      displacementGradient X Y x y t = 0 ∧
      infinitesimalStrain (displacementGradient X Y x y t) = 0

end NumStability.Leveque02Tracer
