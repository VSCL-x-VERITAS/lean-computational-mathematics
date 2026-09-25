/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Example22SWaveTarget
import Mathlib.Tactic

/-!
# LeVeque Example 2.2: S-wave displacement and strain
-/

namespace NumStability.Leveque02Tracer

/-- The transverse traveling profile has only symmetric shear infinitesimal strain. -/
theorem example22SWave : example22SWaveTarget := by
  intro waveform shearSpeed x y t slope hw
  dsimp only
  constructor
  · simp [materialDisplacement, currentMaterialLocation]
  · have hinner : HasDerivAt (fun ξ : ℝ => ξ - shearSpeed * t) 1 x := by
      simpa using (hasDerivAt_id x).sub_const (shearSpeed * t)
    have hprofile : HasDerivAt
        (fun ξ : ℝ => waveform (ξ - shearSpeed * t)) slope x := by
      simpa using hw.comp x hinner
    have hderiv : deriv (fun ξ : ℝ => waveform (ξ - shearSpeed * t)) x = slope :=
      hprofile.deriv
    have hgrad : displacementGradient
        (fun ξ _ _ => ξ)
        (fun ξ η τ => η + waveform (ξ - shearSpeed * τ))
        x y t = !![0, 0; slope, 0] := by
      simp [displacementGradient, materialDisplacement, currentMaterialLocation,
        hderiv]
    rw [hgrad]
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [infinitesimalStrain, Matrix.smul_apply,
        Matrix.transpose_apply, Matrix.vecHead, Matrix.vecTail] <;> ring

end NumStability.Leveque02Tracer
