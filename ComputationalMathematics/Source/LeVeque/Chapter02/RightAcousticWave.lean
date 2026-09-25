/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.RightAcousticWaveTarget

/-!
# Pure right-going acoustic waves
-/

namespace NumStability.Leveque02Tracer

/-- The pure right-going acoustic mode has the translated right eigenvector
form and satisfies `p = Z₀ u` at every point. -/
theorem rightAcousticWaveFormula : rightAcousticWaveTarget := by
  intro q density soundSpeed _ _
  constructor
  · intro hpure
    obtain ⟨profile, hq⟩ :=
      (isPureEigenmodeWave_iff_exists_eq_eigenmodeTravelingWave
        q soundSpeed
        (linearAcousticsRightEigenvector density soundSpeed)).mp hpure
    refine ⟨profile, hq, ?_⟩
    intro x t
    rw [hq]
    simp [eigenmodeTravelingWave, travelingWave,
      linearAcousticsRightEigenvector, acousticImpedance, mul_comm]
  · rintro ⟨profile, hq, _⟩
    exact
      (isPureEigenmodeWave_iff_exists_eq_eigenmodeTravelingWave
        q soundSpeed
        (linearAcousticsRightEigenvector density soundSpeed)).mpr
        ⟨profile, hq⟩

end NumStability.Leveque02Tracer
