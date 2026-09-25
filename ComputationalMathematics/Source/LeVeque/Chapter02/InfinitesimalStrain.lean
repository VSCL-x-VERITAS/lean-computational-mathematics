/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.InfinitesimalStrainTarget

/-!
# LeVeque equation (2.87): symmetric strain matrix
-/

namespace NumStability.Leveque02Tracer

/-- The symmetric strain has diagonal displacement derivatives and equal
off-diagonal shear components. -/
theorem infinitesimalStrainFormula : infinitesimalStrainTarget := by
  intro X Y x y t hXx hXy hYx hYy
  dsimp only
  let G := displacementGradient X Y x y t
  change infinitesimalStrain G =
    !![G 0 0, (G 0 1 + G 1 0) / 2;
       (G 0 1 + G 1 0) / 2, G 1 1]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [infinitesimalStrain, Matrix.smul_apply,
      Matrix.add_apply, Matrix.transpose_apply] <;> ring

end NumStability.Leveque02Tracer
