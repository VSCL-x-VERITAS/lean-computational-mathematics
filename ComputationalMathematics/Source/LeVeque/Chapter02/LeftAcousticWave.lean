/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LeftAcousticWaveTarget

/-!
# General form of a pure left-going acoustic wave
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.60): a pure left-going acoustic eigenfamily wave has, and is
characterized by, a translated scalar profile multiplying the left acoustic
eigenvector. -/
theorem leftAcousticWaveFormula : leftAcousticWaveTarget := by
  intro q density soundSpeed _ _
  constructor
  · intro hpure
    rcases
        (isPureEigenmodeWave_iff_exists_eq_eigenmodeTravelingWave
          q (-soundSpeed)
          (linearAcousticsLeftEigenvector density soundSpeed)).mp hpure with
      ⟨profile, hq⟩
    refine ⟨profile, hq, ?_, ?_⟩
    · intro x t
      rw [hq]
      simp [eigenmodeTravelingWave, travelingWave]
    · intro ξ profile' hprofile
      exact hasDerivAt_eigenmodeProfile
        (linearAcousticsLeftEigenvector density soundSpeed) hprofile
  · rintro ⟨profile, hq, _, _⟩
    exact
      (isPureEigenmodeWave_iff_exists_eq_eigenmodeTravelingWave
        q (-soundSpeed)
        (linearAcousticsLeftEigenvector density soundSpeed)).mpr
        ⟨profile, hq⟩

end NumStability.Leveque02Tracer
