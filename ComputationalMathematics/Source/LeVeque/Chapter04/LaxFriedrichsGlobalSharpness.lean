/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsOrderWitness

/-!
# Fixed-horizon first-order Lax–Friedrichs error witness

For the stationary zero-flux equation, a quadratic exact profile gains
one squared cell width per Lax–Friedrichs step. The error accumulated
over a fixed physical time is exactly proportional to the width.
-/

namespace NumStability

/-- At zero physical flux, adding a constant to all old cell averages
adds that constant to the Lax–Friedrichs update. -/
theorem leveque04_scalarLaxFriedrichs_zeroFlux_add_const
    (old : ℤ → ℝ) (constant : ℝ) (i : ℤ) :
    leveque04_scalarLaxFriedrichsStep 0
      (fun j => old j + constant) i =
    leveque04_scalarLaxFriedrichsStep 0 old i + constant := by
  simp only [leveque04_scalarLaxFriedrichsStep]
  ring

/-- Each zero-flux Lax–Friedrichs step adds one squared cell width to
the stationary quadratic exact cell averages. -/
theorem leveque04_scalarLaxFriedrichs_zeroFlux_quadratic_step
    (width : ℝ) (i : ℤ) :
    leveque04_scalarLaxFriedrichsStep 0
      (leveque04_quadraticCellAverage width) i =
    leveque04_quadraticCellAverage width i + width ^ 2 := by
  have h := leveque04_laxFriedrichs_quadraticAdvectionDefect 0 width i
  have h' : leveque04_scalarLaxFriedrichsStep 0
      (leveque04_quadraticCellAverage width) i -
        leveque04_quadraticCellAverage width i = width ^ 2 := by
    simpa [leveque04_quadraticCellAverage] using h
  linarith

/-- The quadratic stationary-data error accumulates exactly over any
number of zero-flux Lax–Friedrichs steps. -/
theorem leveque04_scalarLaxFriedrichs_zeroFlux_quadratic_iterate
    (width : ℝ) (steps : ℕ) (i : ℤ) :
    ((leveque04_scalarLaxFriedrichsStep 0)^[steps]
      (leveque04_quadraticCellAverage width)) i =
    leveque04_quadraticCellAverage width i + (steps : ℝ) * width ^ 2 := by
  induction steps generalizing i with
  | zero => simp
  | succ steps ih =>
      rw [Function.iterate_succ_apply']
      have hstate :
          ((leveque04_scalarLaxFriedrichsStep 0)^[steps]
            (leveque04_quadraticCellAverage width)) =
          fun j => leveque04_quadraticCellAverage width j +
            (steps : ℝ) * width ^ 2 := by
        funext j
        exact ih j
      rw [hstate,
        leveque04_scalarLaxFriedrichs_zeroFlux_add_const,
        leveque04_scalarLaxFriedrichs_zeroFlux_quadratic_step]
      push_cast
      ring

/-- If the time step is `ratio * width` and `steps` reach a fixed
horizon, the actual solution error on this smooth stationary profile
is exactly `(horizon / ratio) * width`. -/
theorem leveque04_scalarLaxFriedrichs_zeroFlux_quadratic_fixedHorizonError
    (ratio width horizon : ℝ) (steps : ℕ) (i : ℤ)
    (hratio : 0 < ratio)
    (hhorizon : (steps : ℝ) * (ratio * width) = horizon) :
    ((leveque04_scalarLaxFriedrichsStep 0)^[steps]
      (leveque04_quadraticCellAverage width)) i -
        leveque04_quadraticCellAverage width i =
      (horizon / ratio) * width := by
  rw [leveque04_scalarLaxFriedrichs_zeroFlux_quadratic_iterate]
  rw [← hhorizon]
  have hrne : ratio ≠ 0 := ne_of_gt hratio
  field_simp
  ring

/-- The fixed-horizon error divided by the cell width is the
mesh-independent number `horizon / ratio`. -/
theorem leveque04_scalarLaxFriedrichs_zeroFlux_quadratic_fixedHorizonRate
    (ratio width horizon : ℝ) (steps : ℕ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hhorizon : (steps : ℝ) * (ratio * width) = horizon) :
    (((leveque04_scalarLaxFriedrichsStep 0)^[steps]
      (leveque04_quadraticCellAverage width)) i -
        leveque04_quadraticCellAverage width i) / width =
      horizon / ratio := by
  rw [leveque04_scalarLaxFriedrichs_zeroFlux_quadratic_fixedHorizonError
    ratio width horizon steps i hratio hhorizon]
  field_simp

end NumStability
