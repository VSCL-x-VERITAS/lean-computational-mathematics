/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.Exercise37Wave

/-!
# Exercise 3.7: averaging across one complete bounce period

Printed page 63/raw PDF page 85. A period has length `2/c` in the unit tube.
The exact time mean is the slow pressure at the center of that period and the
linear piston-to-wall velocity profile.
-/

namespace NumStability

open MeasureTheory

theorem leveque03_exercise37Pressure_eq_steps
    (density soundSpeed initialPressure epsilon x t : ℝ) :
    leveque03_exercise37Pressure density soundSpeed initialPressure epsilon x t =
      initialPressure + acousticImpedance density soundSpeed * epsilon *
        leveque03_exercise37Step (soundSpeed * t - x) +
      acousticImpedance density soundSpeed * epsilon *
        leveque03_exercise37Step (soundSpeed * t + x - 2) := by
  unfold leveque03_exercise37Pressure
    leveque03_exercise37RightInvariant leveque03_exercise37LeftInvariant
  ring

theorem leveque03_exercise37Velocity_eq_steps
    (density soundSpeed initialPressure epsilon x t : ℝ)
    (hZ : acousticImpedance density soundSpeed ≠ 0) :
    leveque03_exercise37Velocity density soundSpeed initialPressure epsilon x t =
      epsilon * leveque03_exercise37Step (soundSpeed * t - x) -
        epsilon * leveque03_exercise37Step (soundSpeed * t + x - 2) := by
  unfold leveque03_exercise37Velocity
    leveque03_exercise37RightInvariant leveque03_exercise37LeftInvariant
  field_simp [hZ]
  ring

theorem leveque03_exercise37Step_timeIntervalIntegrable
    (soundSpeed d a b : ℝ) (hspeed : 0 ≤ soundSpeed) :
    IntervalIntegrable
      (fun t => leveque03_exercise37Step (soundSpeed * t + d))
      volume a b := by
  apply Monotone.intervalIntegrable
  intro s t hst
  apply leveque03_exercise37Step_mono
  simpa only [add_comm d] using
    add_le_add_right (mul_le_mul_of_nonneg_left hst hspeed) d

/-- The temporal mean across one complete back-and-forth crossing. -/
noncomputable def leveque03_exercise37TimeAverage
    (soundSpeed : ℝ) (field : ℝ → ℝ → ℝ) (x a : ℝ) : ℝ :=
  soundSpeed / 2 * ∫ t in a..a + 2 / soundSpeed, field x t

theorem leveque03_exercise37Velocity_timeAverage
    (density soundSpeed initialPressure epsilon x a : ℝ)
    (hspeed : 0 < soundSpeed) (hdensity : 0 < density) :
    leveque03_exercise37TimeAverage soundSpeed
      (leveque03_exercise37Velocity density soundSpeed initialPressure epsilon)
      x a = leveque03_exercise37SlowVelocity epsilon x a := by
  have hZ : acousticImpedance density soundSpeed ≠ 0 :=
    (mul_pos hdensity hspeed).ne'
  have hr : IntervalIntegrable
      (fun t => leveque03_exercise37Step (soundSpeed * t - x))
      volume a (a + 2 / soundSpeed) := by
    simpa only [sub_eq_add_neg] using
      leveque03_exercise37Step_timeIntervalIntegrable
        soundSpeed (-x) a (a + 2 / soundSpeed) hspeed.le
  have hl : IntervalIntegrable
      (fun t => leveque03_exercise37Step (soundSpeed * t + x - 2))
      volume a (a + 2 / soundSpeed) := by
    simpa only [sub_eq_add_neg, add_assoc] using
      leveque03_exercise37Step_timeIntervalIntegrable
        soundSpeed (x - 2) a (a + 2 / soundSpeed) hspeed.le
  have hir :
      (∫ t in a..a + 2 / soundSpeed,
        leveque03_exercise37Step (soundSpeed * t - x)) =
        (soundSpeed * a - x + 2) / soundSpeed := by
    simpa only [sub_eq_add_neg] using
      leveque03_exercise37Step_timePeriodIntegral
        soundSpeed a (-x) hspeed
  have hil :
      (∫ t in a..a + 2 / soundSpeed,
        leveque03_exercise37Step (soundSpeed * t + x - 2)) =
        (soundSpeed * a + x - 2 + 2) / soundSpeed := by
    simpa only [sub_eq_add_neg, add_assoc] using
      leveque03_exercise37Step_timePeriodIntegral
        soundSpeed a (x - 2) hspeed
  unfold leveque03_exercise37TimeAverage
  simp_rw [leveque03_exercise37Velocity_eq_steps
    density soundSpeed initialPressure epsilon x _ hZ]
  rw [intervalIntegral.integral_sub (hr.const_mul epsilon) (hl.const_mul epsilon),
    intervalIntegral.integral_const_mul,
    intervalIntegral.integral_const_mul, hir, hil]
  change soundSpeed / 2 *
    (epsilon * ((soundSpeed * a - x + 2) / soundSpeed) -
      epsilon * ((soundSpeed * a + x - 2 + 2) / soundSpeed)) =
      leveque03_exercise37SlowVelocity epsilon x a
  dsimp [leveque03_exercise37SlowVelocity]
  field_simp [hspeed.ne']
  ring

theorem leveque03_exercise37Pressure_timeAverage
    (bulkModulus density soundSpeed initialPressure epsilon x a : ℝ)
    (hspeed : 0 < soundSpeed)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    leveque03_exercise37TimeAverage soundSpeed
      (leveque03_exercise37Pressure density soundSpeed initialPressure epsilon)
      x a =
        leveque03_exercise37SlowPressure bulkModulus initialPressure epsilon
          x (a + 1 / soundSpeed) := by
  let coeff := acousticImpedance density soundSpeed * epsilon
  have hr : IntervalIntegrable
      (fun t => leveque03_exercise37Step (soundSpeed * t - x))
      volume a (a + 2 / soundSpeed) := by
    simpa only [sub_eq_add_neg] using
      leveque03_exercise37Step_timeIntervalIntegrable
        soundSpeed (-x) a (a + 2 / soundSpeed) hspeed.le
  have hl : IntervalIntegrable
      (fun t => leveque03_exercise37Step (soundSpeed * t + x - 2))
      volume a (a + 2 / soundSpeed) := by
    simpa only [sub_eq_add_neg, add_assoc] using
      leveque03_exercise37Step_timeIntervalIntegrable
        soundSpeed (x - 2) a (a + 2 / soundSpeed) hspeed.le
  have hir :
      (∫ t in a..a + 2 / soundSpeed,
        leveque03_exercise37Step (soundSpeed * t - x)) =
        (soundSpeed * a - x + 2) / soundSpeed := by
    simpa only [sub_eq_add_neg] using
      leveque03_exercise37Step_timePeriodIntegral
        soundSpeed a (-x) hspeed
  have hil :
      (∫ t in a..a + 2 / soundSpeed,
        leveque03_exercise37Step (soundSpeed * t + x - 2)) =
        (soundSpeed * a + x - 2 + 2) / soundSpeed := by
    simpa only [sub_eq_add_neg, add_assoc] using
      leveque03_exercise37Step_timePeriodIntegral
        soundSpeed a (x - 2) hspeed
  have hconst : IntervalIntegrable (fun _ : ℝ => initialPressure)
      volume a (a + 2 / soundSpeed) := intervalIntegrable_const
  unfold leveque03_exercise37TimeAverage
  simp_rw [leveque03_exercise37Pressure_eq_steps
    density soundSpeed initialPressure epsilon x]
  rw [intervalIntegral.integral_add (hconst.add (hr.const_mul coeff))
      (hl.const_mul coeff),
    intervalIntegral.integral_add hconst (hr.const_mul coeff),
    intervalIntegral.integral_const_mul,
    intervalIntegral.integral_const_mul,
    hir, hil]
  simp only [intervalIntegral.integral_const]
  dsimp [leveque03_exercise37SlowPressure, coeff, acousticImpedance]
  field_simp [hspeed.ne']
  rw [hmaterial]
  ring

/-- Averaging the exact bouncing wave over any complete round trip recovers
both macroscopic fields at the center time of the averaging interval. -/
theorem leveque03_exercise37FullAverage
    (bulkModulus density soundSpeed initialPressure epsilon x a : ℝ)
    (hdensity : 0 < density) (hspeed : 0 < soundSpeed)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    leveque03_exercise37TimeAverage soundSpeed
        (leveque03_exercise37Pressure density soundSpeed initialPressure epsilon)
        x a =
      leveque03_exercise37SlowPressure bulkModulus initialPressure epsilon
        x (a + 1 / soundSpeed) ∧
    leveque03_exercise37TimeAverage soundSpeed
        (leveque03_exercise37Velocity density soundSpeed initialPressure epsilon)
        x a =
      leveque03_exercise37SlowVelocity epsilon x a := by
  exact ⟨leveque03_exercise37Pressure_timeAverage bulkModulus density soundSpeed
    initialPressure epsilon x a hspeed hmaterial,
    leveque03_exercise37Velocity_timeAverage density soundSpeed
      initialPressure epsilon x a hspeed hdensity⟩

end NumStability
