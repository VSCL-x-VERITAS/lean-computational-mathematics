/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.StrainRotationDecompositionTarget

/-!
# LeVeque equation (2.86): strain and rotation decomposition
-/

namespace NumStability.Leveque02Tracer

/-- Every planar displacement gradient splits into symmetric strain and skew rotation. -/
theorem strainRotationDecomposition : strainRotationDecompositionTarget := by
  intro X Y x y t hXx hXy hYx hYy
  dsimp only
  let G := displacementGradient X Y x y t
  change G = infinitesimalStrain G + infinitesimalRotation G ∧
    (infinitesimalStrain G).transpose = infinitesimalStrain G ∧
    (infinitesimalRotation G).transpose = -infinitesimalRotation G
  constructor
  · ext i j
    simp [infinitesimalStrain, infinitesimalRotation, Matrix.add_apply,
      Matrix.sub_apply, Matrix.smul_apply]
    ring
  constructor
  · simp [infinitesimalStrain, Matrix.transpose_smul, Matrix.transpose_add,
      Matrix.transpose_transpose, add_comm]
  · simp [infinitesimalRotation, Matrix.transpose_smul, Matrix.transpose_sub,
      Matrix.transpose_transpose]
    ext i j
    simp [Matrix.sub_apply, Matrix.smul_apply]
    ring

end NumStability.Leveque02Tracer
