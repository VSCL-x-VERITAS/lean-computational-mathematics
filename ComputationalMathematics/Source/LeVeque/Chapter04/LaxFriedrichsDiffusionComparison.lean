/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsGlobalSharpness
import ComputationalMathematics.Source.LeVeque.Chapter04.UpwindWavePropagation

/-!
# A concrete comparison of Lax–Friedrichs and upwind diffusion

For zero physical flux the signed upwind step leaves every cell
average fixed, whereas Lax–Friedrichs smooths quadratic data by one
squared cell width per step. The comparison measures extra numerical
diffusion on a smooth stationary exact solution.
-/

namespace NumStability

/-- The conservative signed upwind update is the identity when the
physical speed is zero. -/
theorem leveque04_signedUpwindStep_zero_speed
    (timeStep width : ℝ) (old : ℤ → ℝ) (i : ℤ) :
    leveque04_signedUpwindStep timeStep width 0 old i = old i := by
  rw [leveque04_equation35]
  simp [leveque04_positiveVelocity, leveque04_negativeVelocity]

/-- Upwind evolution preserves any initial state at zero physical speed. -/
theorem leveque04_signedUpwindStep_zero_speed_iterate
    (timeStep width : ℝ) (old : ℤ → ℝ) (steps : ℕ) (i : ℤ) :
    ((leveque04_signedUpwindStep timeStep width 0)^[steps] old) i =
      old i := by
  have hstep : leveque04_signedUpwindStep timeStep width 0 =
      (id : (ℤ → ℝ) → (ℤ → ℝ)) := by
    funext state j
    exact leveque04_signedUpwindStep_zero_speed timeStep width state j
  rw [hstep, Function.iterate_id]
  rfl

/-- On stationary quadratic exact cell averages, Lax–Friedrichs has
an excess one-step diffusion error of precisely `width²` compared
with the zero-speed upwind method. -/
theorem leveque04_laxFriedrichs_zeroFlux_excessDiffusion_step
    (ratio width : ℝ) (i : ℤ) :
    leveque04_scalarLaxFriedrichsStep 0
        (leveque04_quadraticCellAverage width) i -
      leveque04_signedUpwindStep (ratio * width) width 0
        (leveque04_quadraticCellAverage width) i = width ^ 2 := by
  rw [leveque04_signedUpwindStep_zero_speed,
    leveque04_scalarLaxFriedrichs_zeroFlux_quadratic_step]
  ring

/-- The excess diffusion compared with exact zero-speed upwind
evolution persists over a fixed physical horizon at first-order scale. -/
theorem leveque04_laxFriedrichs_zeroFlux_excessDiffusion_fixedHorizon
    (ratio width horizon : ℝ) (steps : ℕ) (i : ℤ)
    (hratio : 0 < ratio)
    (hhorizon : (steps : ℝ) * (ratio * width) = horizon) :
    ((leveque04_scalarLaxFriedrichsStep 0)^[steps]
        (leveque04_quadraticCellAverage width)) i -
      ((leveque04_signedUpwindStep (ratio * width) width 0)^[steps]
        (leveque04_quadraticCellAverage width)) i =
      (horizon / ratio) * width := by
  rw [leveque04_signedUpwindStep_zero_speed_iterate]
  exact leveque04_scalarLaxFriedrichs_zeroFlux_quadratic_fixedHorizonError
    ratio width horizon steps i hratio hhorizon

end NumStability
