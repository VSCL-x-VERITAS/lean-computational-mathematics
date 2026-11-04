/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerUndershootTarget
import Mathlib.Tactic.NormNum

/-!
# A strict undershoot in the actual Richtmyer update

The initial unit step lies in `[0, 1]`, whereas cell zero becomes strictly
negative for every positive subunit Courant number. This proves the selected
scalar supporting application, with the original numerical method unchanged.
-/

namespace NumStability

/-- The reviewed scalar unit-step application of equations (4.4), (4.22),
and (4.23), for every positive subunit Courant choice. -/
theorem leveque04_richtmyerUnitStepUndershoot :
    Leveque04RichtmyerUnitStepUndershootTarget := by
  constructor
  · intro j
    by_cases hj : 0 < j <;> simp [leveque04_richtmyerUnitStepData, hj]
  · intro speed timeStep cellWidth hspeed htime hwidth hcfl
    have hvalue : leveque04_richtmyerUnitStepAtOrigin speed timeStep cellWidth =
        (speed * timeStep / cellWidth) * (speed * timeStep / cellWidth - 1) / 2 := by
      simp [leveque04_richtmyerUnitStepAtOrigin, leveque04_finiteVolumeUpdate,
        conservativeFluxDifferenceUpdateInt, leveque04_localInterfaceFlux,
        leveque04_richtmyerFlux, leveque04_richtmyerPredictor,
        leveque04_richtmyerUnitStepData, div_eq_mul_inv, mul_inv_rev]
      ring
    refine ⟨hvalue, ?_⟩
    rw [hvalue]
    exact div_neg_of_neg_of_pos
      (mul_neg_of_pos_of_neg (div_pos (mul_pos hspeed htime) hwidth) (sub_neg.mpr hcfl))
      (by norm_num)

end NumStability
