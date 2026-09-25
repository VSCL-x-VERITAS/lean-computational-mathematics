/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.StrainRotationModel

/-!
# LeVeque equation (2.86): symmetric and skew parts of the gradient
-/

namespace NumStability.Leveque02Tracer

/-- The displacement gradient is the sum of its symmetric strain and skew
rotation parts, as defined in the following two displayed equations. -/
def strainRotationDecompositionTarget : Prop :=
  ∀ (X Y : ℝ → ℝ → ℝ → ℝ) (x y t : ℝ),
    DifferentiableAt ℝ (fun ξ => X ξ y t) x →
    DifferentiableAt ℝ (fun η => X x η t) y →
    DifferentiableAt ℝ (fun ξ => Y ξ y t) x →
    DifferentiableAt ℝ (fun η => Y x η t) y →
    let G := displacementGradient X Y x y t
    G = infinitesimalStrain G + infinitesimalRotation G ∧
      (infinitesimalStrain G).transpose = infinitesimalStrain G ∧
      (infinitesimalRotation G).transpose = -infinitesimalRotation G

end NumStability.Leveque02Tracer
