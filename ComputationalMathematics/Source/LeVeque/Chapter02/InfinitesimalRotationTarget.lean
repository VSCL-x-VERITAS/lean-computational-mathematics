/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.StrainRotationModel

/-!
# LeVeque equation (2.88): infinitesimal rotation components
-/

namespace NumStability.Leveque02Tracer

/-- The skew part of an actual planar displacement gradient has zero diagonal
and opposite off-diagonal rotation components. -/
def infinitesimalRotationTarget : Prop :=
  ∀ (X Y : ℝ → ℝ → ℝ → ℝ) (x y t : ℝ),
    DifferentiableAt ℝ (fun ξ => X ξ y t) x →
    DifferentiableAt ℝ (fun η => X x η t) y →
    DifferentiableAt ℝ (fun ξ => Y ξ y t) x →
    DifferentiableAt ℝ (fun η => Y x η t) y →
      let G := displacementGradient X Y x y t
      infinitesimalRotation G =
        !![0, (G 0 1 - G 1 0) / 2;
           -((G 0 1 - G 1 0) / 2), 0]

end NumStability.Leveque02Tracer
