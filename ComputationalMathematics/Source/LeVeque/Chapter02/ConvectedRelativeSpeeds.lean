/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ConvectedRelativeSpeedsTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.ConvectedAcousticsEigenvalues
import Mathlib.Tactic

/-!
# LeVeque Chapter 2: ConvectedRelativeSpeeds

Proof of observer-relative acoustic characteristic speeds.
-/

namespace NumStability.Leveque02Tracer

theorem convectedRelativeSpeeds : convectedRelativeSpeedsTarget := by
  intro bulkModulus density backgroundVelocity hbulk hdensity
  obtain ⟨hleft, hright⟩ := convectedAcousticsEigenvalues
    bulkModulus density backgroundVelocity hbulk hdensity
  exact ⟨hleft, hright, by ring, by ring⟩

end NumStability.Leveque02Tracer
