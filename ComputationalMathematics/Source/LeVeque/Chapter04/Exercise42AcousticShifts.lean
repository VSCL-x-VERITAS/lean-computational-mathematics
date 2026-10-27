/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.AcousticFluxMatrices
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4, Exercise 4.2(c): acoustic characteristic shifts

At zero background velocity and unit sound-speed CFL, the right-going
invariant comes from the left neighboring cell and the left-going
invariant from the right neighboring cell. Reconstructing pressure and
particle velocity gives the displayed exact cell-average formulas.
-/

namespace NumStability

/-- The acoustics spectral split at zero background velocity. -/
theorem leveque04_acousticMatrices_zeroBackground
    (density soundSpeed : ℝ) (hspeed : 0 < soundSpeed)
    (himpedance : acousticImpedance density soundSpeed ≠ 0) :
    let Z := acousticImpedance density soundSpeed
    leveque04_acousticPositiveMatrix density soundSpeed 0 =
        !![soundSpeed / 2, Z * soundSpeed / 2;
           soundSpeed / (2 * Z), soundSpeed / 2] ∧
      leveque04_acousticNegativeMatrix density soundSpeed 0 =
        !![-soundSpeed / 2, Z * soundSpeed / 2;
           soundSpeed / (2 * Z), -soundSpeed / 2] := by
  obtain ⟨hplus, hminus⟩ :=
    leveque04_exercise41_acousticMatrices density soundSpeed 0 himpedance
  constructor
  · simpa [max_eq_left hspeed.le, max_eq_right (neg_nonpos.mpr hspeed.le)] using hplus
  · simpa [min_eq_left (neg_nonpos.mpr hspeed.le), min_eq_right hspeed.le] using hminus

/-- The right-going acoustic characteristic combination. -/
def leveque04_acousticRightCharacteristic
    (impedance : ℝ) (state : Fin 2 → ℝ) : ℝ :=
  state 0 + impedance * state 1

/-- The left-going acoustic characteristic combination. -/
def leveque04_acousticLeftCharacteristic
    (impedance : ℝ) (state : Fin 2 → ℝ) : ℝ :=
  state 0 - impedance * state 1

/-- Reconstruct the unit-CFL update from characteristic values shifted
from the left and right neighboring cells. -/
noncomputable def leveque04_acousticUnitShiftStep
    (impedance : ℝ) (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) : Fin 2 → ℝ :=
  ![(leveque04_acousticRightCharacteristic impedance (old (i - 1)) +
       leveque04_acousticLeftCharacteristic impedance (old (i + 1))) / 2,
     (leveque04_acousticRightCharacteristic impedance (old (i - 1)) -
       leveque04_acousticLeftCharacteristic impedance (old (i + 1))) /
       (2 * impedance)]

/-- The pressure formula obtained from the two characteristic shifts. -/
theorem leveque04_acousticUnitShift_pressure
    (impedance : ℝ) (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    leveque04_acousticUnitShiftStep impedance old i 0 =
      (old (i - 1) 0 + old (i + 1) 0 +
        impedance * (old (i - 1) 1 - old (i + 1) 1)) / 2 := by
  simp [leveque04_acousticUnitShiftStep,
    leveque04_acousticRightCharacteristic,
    leveque04_acousticLeftCharacteristic]
  ring

/-- The particle-velocity formula obtained from the two shifts. -/
theorem leveque04_acousticUnitShift_velocity
    (impedance : ℝ) (himpedance : impedance ≠ 0)
    (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    leveque04_acousticUnitShiftStep impedance old i 1 =
      (old (i - 1) 1 + old (i + 1) 1) / 2 +
        (old (i - 1) 0 - old (i + 1) 0) / (2 * impedance) := by
  simp [leveque04_acousticUnitShiftStep,
    leveque04_acousticRightCharacteristic,
    leveque04_acousticLeftCharacteristic]
  field_simp
  ring

/-- The numerical update advances the right-going invariant by one cell. -/
theorem leveque04_acousticUnitShift_rightCharacteristic
    (impedance : ℝ) (himpedance : impedance ≠ 0)
    (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    leveque04_acousticRightCharacteristic impedance
        (leveque04_acousticUnitShiftStep impedance old i) =
      leveque04_acousticRightCharacteristic impedance (old (i - 1)) := by
  simp [leveque04_acousticRightCharacteristic,
    leveque04_acousticLeftCharacteristic,
    leveque04_acousticUnitShiftStep]
  field_simp
  ring

/-- The left-going invariant advances by one cell from the right. -/
theorem leveque04_acousticUnitShift_leftCharacteristic
    (impedance : ℝ) (himpedance : impedance ≠ 0)
    (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    leveque04_acousticLeftCharacteristic impedance
        (leveque04_acousticUnitShiftStep impedance old i) =
      leveque04_acousticLeftCharacteristic impedance (old (i + 1)) := by
  simp [leveque04_acousticRightCharacteristic,
    leveque04_acousticLeftCharacteristic,
    leveque04_acousticUnitShiftStep]
  field_simp
  ring

/-- At `c Δt = Δx`, the acoustic spectral-fluctuation update built from
the actual split matrices is the characteristic one-cell shift. -/
theorem leveque04_acousticSplitStep_unitCFL
    (density soundSpeed timeStep cellWidth : ℝ)
    (hspeed : 0 < soundSpeed) (hwidth : 0 < cellWidth)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (hcfl : soundSpeed * timeStep = cellWidth)
    (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    old i - (timeStep / cellWidth) •
        ((leveque04_acousticPositiveMatrix density soundSpeed 0).mulVec
            (old i - old (i - 1)) +
          (leveque04_acousticNegativeMatrix density soundSpeed 0).mulVec
            (old (i + 1) - old i)) =
      leveque04_acousticUnitShiftStep
        (acousticImpedance density soundSpeed) old i := by
  have hratio : timeStep / cellWidth = 1 / soundSpeed := by
    apply (div_eq_iff hwidth.ne').mpr
    field_simp [hspeed.ne']
    nlinarith [hcfl]
  obtain ⟨hplus, hminus⟩ :=
    leveque04_acousticMatrices_zeroBackground density soundSpeed
      hspeed himpedance
  rw [hratio, hplus, hminus]
  funext k
  fin_cases k <;>
    simp [leveque04_acousticUnitShiftStep,
      leveque04_acousticRightCharacteristic,
      leveque04_acousticLeftCharacteristic,
      dotProduct, Fin.sum_univ_two,
      Pi.sub_apply, smul_eq_mul] <;>
    field_simp [hspeed.ne', himpedance] <;> ring

end NumStability
