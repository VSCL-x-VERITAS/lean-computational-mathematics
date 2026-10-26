/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.AcousticRiemannWaves
import Mathlib.Tactic.Linarith

/-!
# LeVeque Chapter 4, Exercise 4.2(d): characteristic grid alignment

The acoustic speeds are `u₀ - c` and `u₀ + c`. Under a one-cell CFL
restriction, both waves can be grid aligned only at zero background
velocity or at the two sonic values `u₀ = ±c`.
-/

namespace NumStability

/-- A characteristic travels exactly one cell left, stays stationary,
or travels exactly one cell right during the step. -/
def IsLeveque04GridAlignedSpeed
    (speed timeStep cellWidth : ℝ) : Prop :=
  speed * timeStep = -cellWidth ∨
    speed * timeStep = 0 ∨
      speed * timeStep = cellWidth

/-- Two distinct acoustic characteristics can both be aligned with a
one-cell grid only in the zero-velocity or sonic cases. -/
theorem leveque04_acousticGridAlignment_classification
    (background soundSpeed timeStep cellWidth : ℝ)
    (hsound : 0 < soundSpeed) (htime : 0 < timeStep)
    (hwidth : 0 < cellWidth)
    (hleft : IsLeveque04GridAlignedSpeed
      (background - soundSpeed) timeStep cellWidth)
    (hright : IsLeveque04GridAlignedSpeed
      (background + soundSpeed) timeStep cellWidth) :
    background = 0 ∨
      background = soundSpeed ∨
        background = -soundSpeed := by
  rcases hleft with hl | hl | hl <;>
    rcases hright with hr | hr | hr
  all_goals
    first
    | left
      have h : background * timeStep = 0 := by nlinarith [mul_pos hsound htime]
      exact (mul_eq_zero.mp h).resolve_right htime.ne'
    | right; left
      have h : (background - soundSpeed) * timeStep = 0 := by
        nlinarith [mul_pos hsound htime]
      exact sub_eq_zero.mp ((mul_eq_zero.mp h).resolve_right htime.ne')
    | right; right
      have h : (background + soundSpeed) * timeStep = 0 := by
        nlinarith [mul_pos hsound htime]
      exact eq_neg_iff_add_eq_zero.mpr
        ((mul_eq_zero.mp h).resolve_right htime.ne')

/-- A nonzero sonic background has an aligned pair: one stationary
characteristic and one positive unit-cell characteristic. -/
theorem leveque04_acousticSonic_alignment
    (soundSpeed timeStep cellWidth : ℝ)
    (_hsound : 0 < soundSpeed) (_hwidth : 0 < cellWidth)
    (htravel : 2 * soundSpeed * timeStep = cellWidth) :
    IsLeveque04GridAlignedSpeed
        (soundSpeed - soundSpeed) timeStep cellWidth ∧
      IsLeveque04GridAlignedSpeed
        (soundSpeed + soundSpeed) timeStep cellWidth := by
  constructor
  · right; left
    ring
  · right; right
    nlinarith

end NumStability
