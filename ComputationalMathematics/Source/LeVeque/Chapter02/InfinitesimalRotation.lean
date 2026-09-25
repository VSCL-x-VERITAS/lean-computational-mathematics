/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.InfinitesimalRotationTarget

/-!
# LeVeque equation (2.88): skew rotation matrix
-/

namespace NumStability.Leveque02Tracer

/-- The infinitesimal rotation has zero diagonal and opposite
off-diagonal components. -/
theorem infinitesimalRotationFormula : infinitesimalRotationTarget := by
  intro X Y x y t hXx hXy hYx hYy
  dsimp only
  let G := displacementGradient X Y x y t
  change infinitesimalRotation G =
    !![0, (G 0 1 - G 1 0) / 2;
       -((G 0 1 - G 1 0) / 2), 0]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [infinitesimalRotation, Matrix.smul_apply,
      Matrix.sub_apply, Matrix.transpose_apply] <;> ring

end NumStability.Leveque02Tracer
