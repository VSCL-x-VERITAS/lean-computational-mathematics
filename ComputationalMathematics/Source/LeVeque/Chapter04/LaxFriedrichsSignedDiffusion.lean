/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsViscosity
import ComputationalMathematics.Source.LeVeque.Chapter04.UpwindWavePropagation
import Mathlib.Tactic.Linarith

/-!
# LeVeque: signed-speed numerical diffusion comparison

The existing signed upwind interface flux has viscosity coefficient
`abs speed * width / 2`. On positive meshes the existing Lax-Friedrichs
coefficient is at least this large under CFL, and strictly larger below
the CFL limit. The Chapter 8 reciprocal leading coefficient uses its
explicit signed Courant convention and requires nonzero speed.
-/

namespace NumStability

theorem leveque04_signedUpwindInterfaceFlux_eq_viscous
    (speed width : ℝ) (old : ℤ → ℝ) (i : ℤ) (hwidth : 0 < width) :
    leveque04_signedUpwindInterfaceFlux speed old i =
      speed * (old (i - 1) + old i) / 2 -
        (|speed| * width / 2) / width * (old i - old (i - 1)) := by
  have hw : width ≠ 0 := ne_of_gt hwidth
  by_cases hs : 0 ≤ speed
  · simp only [leveque04_signedUpwindInterfaceFlux, leveque04_positiveVelocity,
      leveque04_negativeVelocity, max_eq_left hs, min_eq_right hs, abs_of_nonneg hs]
    field_simp
    ring
  · have hs' : speed ≤ 0 := (lt_of_not_ge hs).le
    simp only [leveque04_signedUpwindInterfaceFlux, leveque04_positiveVelocity,
      leveque04_negativeVelocity, max_eq_right hs', min_eq_left hs', abs_of_nonpos hs']
    field_simp
    ring

theorem leveque04_laxFriedrichsViscosity_sub_upwind
    (speed ratio width : ℝ) (hratio : 0 < ratio) (hwidth : 0 < width) :
    leveque04_laxFriedrichsViscosity (ratio * width) width - |speed| * width / 2 =
      (1 - |speed * ratio|) * width / (2 * ratio) := by
  rw [leveque04_laxFriedrichsViscosity_fixedRatio ratio width hratio hwidth,
    abs_mul, abs_of_pos hratio]
  field_simp

theorem leveque04_upwindViscosity_le_laxFriedrichs
    (speed ratio width : ℝ) (hratio : 0 < ratio) (hwidth : 0 < width)
    (hcfl : |speed * ratio| ≤ 1) :
    |speed| * width / 2 ≤ leveque04_laxFriedrichsViscosity (ratio * width) width := by
  have h := leveque04_laxFriedrichsViscosity_sub_upwind speed ratio width hratio hwidth
  have hn : 0 ≤ (1 - |speed * ratio|) * width / (2 * ratio) :=
    div_nonneg (mul_nonneg (sub_nonneg.mpr hcfl) hwidth.le) (by positivity)
  linarith

theorem leveque04_upwindViscosity_lt_laxFriedrichs
    (speed ratio width : ℝ) (hratio : 0 < ratio) (hwidth : 0 < width)
    (hcfl : |speed * ratio| < 1) :
    |speed| * width / 2 < leveque04_laxFriedrichsViscosity (ratio * width) width := by
  have h := leveque04_laxFriedrichsViscosity_sub_upwind speed ratio width hratio hwidth
  have hp : 0 < (1 - |speed * ratio|) * width / (2 * ratio) :=
    div_pos (mul_pos (sub_pos.mpr hcfl) hwidth) (by positivity)
  linarith

theorem leveque04_laxFriedrichs_advectionLeadingCoefficient_reciprocal
    (speed ratio width : ℝ) (hspeed : speed ≠ 0) (hratio : 0 < ratio) :
    (1 - (speed * ratio) ^ 2) / (2 * ratio) * width =
      speed * width / 2 * (1 / (speed * ratio) - speed * ratio) := by
  field_simp [hspeed, ne_of_gt hratio]

end NumStability
