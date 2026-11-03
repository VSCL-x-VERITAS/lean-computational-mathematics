/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RoeCorrectionStabilityTarget

/-!
# Constant-linear Roe correction and stability

The flux-defined conservative step agrees with the characteristic wave step.
Its pairwise characteristic contraction gives every iterate and the fixed
eigenbasis factor in physical coordinates.
-/

namespace NumStability

/-- The complete qualified constant-linear Roe correction/stability target. -/
theorem leveque04_roeCorrectionStability :
    Leveque04RoeCorrectionStabilityTarget := by
  intro m _ coefficient basis speeds heigen
  refine ⟨?_, ?_, ?_⟩
  · exact leveque04_linearRoeStep_eq_waveStep coefficient basis speeds heigen
  · intro timeStep cellWidth B htime hwidth hB hCFL P Q hbound n i p
    exact leveque04_linearRoe_iterate_characteristic_difference_bound
      coefficient basis speeds heigen (timeStep / cellWidth) B
      (div_pos htime hwidth) hB hCFL P Q hbound n i p
  · intro timeStep cellWidth B htime hwidth hB hCFL P Q hbound n i
    exact leveque04_linearRoe_iterate_physical_difference_bound
      coefficient basis speeds heigen (timeStep / cellWidth) B
      (div_pos htime hwidth) hB hCFL P Q hbound n i

end NumStability
