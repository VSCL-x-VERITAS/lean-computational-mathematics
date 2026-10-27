/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsPeriodicRefinement

/-!
# Zero-flux periodic Lax–Friedrichs mode transfer

For a stationary equation, periodic Lax–Friedrichs averages the two
neighboring states. Any periodic mode with a fixed neighbor-average
factor therefore has an exactly computable amplitude after each step.
This isolates the discrete spectral calculation needed for a smooth
periodic first-order sharpness witness.
-/

namespace NumStability

/-- A zero-flux periodic Lax–Friedrichs step is neighbor averaging. -/
theorem leveque04_periodicLaxFriedrichs_zeroFlux_step
    (n : ℕ) [NeZero n] (ratio : ℝ)
    (u : ZMod n → ℝ) (i : ZMod n) :
    leveque04_periodicNonlinearLaxFriedrichsStep n
      (fun _ => 0) ratio u i = (u (i - 1) + u (i + 1)) / 2 := by
  simp [leveque04_periodicNonlinearLaxFriedrichsStep]

/-- Neighbor averaging commutes with scaling of a periodic state. -/
theorem leveque04_periodicLaxFriedrichs_zeroFlux_scale
    (n : ℕ) [NeZero n] (ratio scale : ℝ)
    (u : ZMod n → ℝ) :
    leveque04_periodicNonlinearLaxFriedrichsStep n
      (fun _ => 0) ratio (fun i => scale * u i) =
        fun i => scale *
          leveque04_periodicNonlinearLaxFriedrichsStep n
            (fun _ => 0) ratio u i := by
  funext i
  simp only [leveque04_periodicLaxFriedrichs_zeroFlux_step]
  ring

/-- A periodic neighbor-average eigenmode decays by the corresponding
power of its factor under the actual zero-flux source stencil. -/
theorem leveque04_periodicLaxFriedrichs_zeroFlux_mode_iterate
    (n : ℕ) [NeZero n] (ratio factor : ℝ)
    (u : ZMod n → ℝ)
    (hmode : ∀ i, (u (i - 1) + u (i + 1)) / 2 = factor * u i)
    (steps : ℕ) :
    ((leveque04_periodicNonlinearLaxFriedrichsStep n
      (fun _ => 0) ratio)^[steps] u) =
        fun i => factor ^ steps * u i := by
  induction steps with
  | zero => simp
  | succ steps ih =>
      rw [Function.iterate_succ_apply', ih]
      rw [leveque04_periodicLaxFriedrichs_zeroFlux_scale]
      funext i
      rw [leveque04_periodicLaxFriedrichs_zeroFlux_step, hmode]
      ring

/-- The exact stationary-state error of one periodic eigenmode is its
amplitude loss times the mode value. -/
theorem leveque04_periodicLaxFriedrichs_zeroFlux_mode_error
    (n : ℕ) [NeZero n] (ratio factor : ℝ)
    (u : ZMod n → ℝ)
    (hmode : ∀ i, (u (i - 1) + u (i + 1)) / 2 = factor * u i)
    (steps : ℕ) (i : ZMod n) :
    (((leveque04_periodicNonlinearLaxFriedrichsStep n
      (fun _ => 0) ratio)^[steps] u) i - u i) =
      (factor ^ steps - 1) * u i := by
  rw [leveque04_periodicLaxFriedrichs_zeroFlux_mode_iterate
    n ratio factor u hmode steps]
  ring

end NumStability
