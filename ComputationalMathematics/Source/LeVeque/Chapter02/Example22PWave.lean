/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Example22PWaveTarget
import Mathlib.Tactic

/-!
# LeVeque Example 2.2: P-wave displacement and strain
-/

namespace NumStability.Leveque02Tracer

/-- The longitudinal traveling profile has only extensional infinitesimal strain. -/
theorem example22PWave : example22PWaveTarget := by
  intro waveform compressionSpeed x y t slope hw
  dsimp only
  constructor
  · simp [materialDisplacement, currentMaterialLocation]
  · have hinner : HasDerivAt (fun ξ : ℝ => ξ - compressionSpeed * t) 1 x := by
      simpa using (hasDerivAt_id x).sub_const (compressionSpeed * t)
    have hprofile : HasDerivAt
        (fun ξ : ℝ => waveform (ξ - compressionSpeed * t)) slope x := by
      simpa using hw.comp x hinner
    have hderiv : deriv (fun ξ : ℝ => waveform (ξ - compressionSpeed * t)) x = slope :=
      hprofile.deriv
    have hgrad : displacementGradient
        (fun ξ _ τ => ξ + waveform (ξ - compressionSpeed * τ))
        (fun _ η _ => η) x y t = !![slope, 0; 0, 0] := by
      simp [displacementGradient, materialDisplacement, currentMaterialLocation,
        hderiv]
    rw [hgrad]
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [infinitesimalStrain, Matrix.smul_apply,
        Matrix.transpose_apply, Matrix.vecHead, Matrix.vecTail]
    ring

end NumStability.Leveque02Tracer
