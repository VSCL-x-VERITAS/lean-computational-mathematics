/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.RigidTranslationStrainTarget

/-!
# LeVeque Chapter 2: RigidTranslationStrain

Proof that a rigid translation has zero infinitesimal strain.
-/

namespace NumStability.Leveque02Tracer

theorem rigidTranslationStrain : rigidTranslationStrainTarget := by
  intro a b x y t
  dsimp only
  let X : ℝ → ℝ → ℝ → ℝ := fun ξ _ τ => ξ + a τ
  let Y : ℝ → ℝ → ℝ → ℝ := fun _ η τ => η + b τ
  have hgradient : displacementGradient X Y x y t = 0 := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [displacementGradient, materialDisplacement,
        currentMaterialLocation, X, Y]
  constructor
  · simp [materialDisplacement, currentMaterialLocation]
  · refine ⟨hgradient, ?_⟩
    change infinitesimalStrain (displacementGradient X Y x y t) = 0
    rw [hgradient]
    simp [infinitesimalStrain]

end NumStability.Leveque02Tracer
