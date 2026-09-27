/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.CoupledAcousticsSpectrum

/-!
# Mach number and counts of incoming characteristic fields

The printed page 59 comparison of subsonic and supersonic flows and the
noncharacteristic finite-pipe boundary count. The directional inflow
formulas themselves are reused from Chapter 2.
-/

namespace NumStability

/-- The ratio of the background flow speed to the sound speed. -/
noncomputable def leveque03_machNumber (backgroundVelocity soundSpeed : ℝ) : ℝ :=
  |backgroundVelocity| / soundSpeed

theorem leveque03_machNumber_subsuper
    (backgroundVelocity soundSpeed : ℝ)
    (hbackground : 0 < backgroundVelocity) (hsound : 0 < soundSpeed) :
    (leveque03_machNumber backgroundVelocity soundSpeed < 1 ↔
      backgroundVelocity < soundSpeed) ∧
    (1 < leveque03_machNumber backgroundVelocity soundSpeed ↔
      soundSpeed < backgroundVelocity) := by
  simp only [leveque03_machNumber, abs_of_pos hbackground]
  constructor
  · rw [div_lt_iff₀ hsound]
    simp
  · rw [lt_div_iff₀ hsound]
    simp

/-- The number of incoming characteristics at the left boundary. -/
noncomputable def leveque03_leftInflowCount
    {m : ℕ} (speeds : Fin m → ℝ) : ℕ :=
  (Finset.univ.filter fun p => 0 < speeds p).card

/-- The number of incoming characteristics at the right boundary. -/
noncomputable def leveque03_rightInflowCount
    {m : ℕ} (speeds : Fin m → ℝ) : ℕ :=
  (Finset.univ.filter fun p => speeds p < 0).card

theorem leveque03_boundaryConditionCount
    {m : ℕ} (speeds : Fin m → ℝ)
    (hnonchar : ∀ p, speeds p ≠ 0) :
    leveque03_leftInflowCount speeds +
      leveque03_rightInflowCount speeds = m := by
  classical
  have hneg :
      (Finset.univ.filter fun p : Fin m => speeds p < 0) =
      (Finset.univ.filter fun p : Fin m => ¬ 0 < speeds p) := by
    ext p
    simp only [Finset.mem_filter, Finset.mem_univ, true_and]
    constructor
    · intro hp
      exact not_lt.mpr hp.le
    · intro hp
      exact lt_of_le_of_ne (le_of_not_gt hp) (hnonchar p)
  unfold leveque03_leftInflowCount leveque03_rightInflowCount
  rw [hneg]
  simpa using (Finset.card_filter_add_card_filter_not
    (s := (Finset.univ : Finset (Fin m))) (p := fun p => 0 < speeds p))

theorem leveque03_boundaryConditionCount_split
    {m : ℕ} (speeds : Fin m → ℝ)
    (hnonchar : ∀ p, speeds p ≠ 0)
    (n : ℕ) (hnegative : leveque03_rightInflowCount speeds = n) :
    n ≤ m ∧ leveque03_leftInflowCount speeds = m - n := by
  have hsum := leveque03_boundaryConditionCount speeds hnonchar
  omega

end NumStability
