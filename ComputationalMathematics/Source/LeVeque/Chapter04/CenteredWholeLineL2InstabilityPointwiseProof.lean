/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CenteredWholeLineL2PointwiseEquivalence

/-!
# Centered instability in the physical two-norm

The pointwise target follows from the exact step/iterate equivalence and the
existing whole-line counterexample with finitely supported initial data.
-/

namespace NumStability

/-- The reviewed pointwise centered method has no uniform all-data bound through
any fixed positive physical horizon at a fixed nonzero CFL-satisfying ratio. -/
theorem leveque04_centeredWholeLineL2Instability_pointwise :
    leveque04_centeredWholeLineL2Instability_pointwiseTarget := by
  apply centeredWholeLineL2Instability_pointwise_iff_old.mpr
  intro speed ratio finalTime hspeed hratio _hcfl hfinal
  rintro ⟨bound, hbound, start, huniform⟩
  obtain ⟨n, hn, hnpos, hstrict⟩ :=
    leveque04_centeredWholeLineL2_fixedTime_unstable
      speed ratio finalTime bound hspeed hratio hfinal hbound start
  exact (not_lt_of_ge
    (huniform n hn hnpos n le_rfl (leveque04_centeredTruncatedQuarterWave n))) hstrict

end NumStability
