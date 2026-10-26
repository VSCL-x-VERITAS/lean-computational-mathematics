/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsCosineCellAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsDiffusionComparison

/-!
# Sharp periodic zero-flux Lax–Friedrichs error on smooth exact averages

The fixed smooth stationary profile `cos x` has period `2π`. On each
refinement its exact cell-average state is a positive multiple of the
first periodic cosine mode. The numerical neighbor average damps that
mode by a first-order amount at a fixed physical horizon.
-/

namespace NumStability

open MeasureTheory

/-- The time-independent smooth cosine solves the zero-flux scalar
conservation law on every oriented space-time rectangle. -/
theorem leveque04_stationaryCosine_rectangleSolution :
    IsRectangleConservationLawSolution
      (fun x (_ : ℝ) => fun (_ : Fin 1) => Real.cos x)
      (fun (_ : Fin 1 → ℝ) => fun (_ : Fin 1) => 0) := by
  have hcont : Continuous
      (fun x : ℝ => fun (_ : Fin 1) => Real.cos x) :=
    continuous_pi (fun _ => Real.continuous_cos)
  have hint : ∀ a b : ℝ,
      IntervalIntegrable
        (fun x : ℝ => fun (_ : Fin 1) => Real.cos x)
        volume a b := fun a b => hcont.intervalIntegrable a b
  have hfield : travelingWave
      (fun x : ℝ => fun (_ : Fin 1) => Real.cos x) 0 =
        (fun x (_ : ℝ) => fun (_ : Fin 1) => Real.cos x) := by
    funext x t k
    simp [travelingWave]
  simpa only [hfield, zero_smul] using
    travelingWave_isRectangleConservationLawSolution
      (fun x : ℝ => fun (_ : Fin 1) => Real.cos x) hint 0

/-- The exact stationary profile has the fixed physical period used by
every grid in the sharpness refinement. -/
theorem leveque04_stationaryCosine_periodic
    (x : ℝ) :
    (fun (_ : Fin 1) => Real.cos (x + 2 * Real.pi)) =
      (fun (_ : Fin 1) => Real.cos x) := by
  funext k
  exact Real.cos_add_two_pi x

/-- At fixed `dt/width = ratio`, exactly `n` steps on the `n`-cell
periodic grid reach the physical time `ratio·2π`. -/
theorem leveque04_periodicCosine_fixedHorizon
    (n : ℕ) [NeZero n] (ratio : ℝ) :
    (n : ℝ) * (ratio * (2 * Real.pi / (n : ℝ))) =
      ratio * (2 * Real.pi) := by
  have hn : (n : ℝ) ≠ 0 := by exact_mod_cast (NeZero.ne n)
  field_simp

/-- Exact averages of the stationary smooth cosine on an `n`-cell grid
covering the fixed period `2π`. -/
noncomputable def leveque04_cosineExactPeriodicCellAverage
    (n : ℕ) (i : ZMod n) : ℝ :=
  oneDimensionalCellAverage Real.cos
    ((i.val : ℝ) * (2 * Real.pi / (n : ℝ)) -
      (2 * Real.pi / (n : ℝ)) / 2)
    ((i.val : ℝ) * (2 * Real.pi / (n : ℝ)) +
      (2 * Real.pi / (n : ℝ)) / 2)

/-- The exact average is a positive sinc amplitude times the sampled
discrete cosine mode. -/
theorem leveque04_cosineExactPeriodicCellAverage_eq_mode
    (n : ℕ) [NeZero n] (i : ZMod n) :
    leveque04_cosineExactPeriodicCellAverage n i =
      (2 * Real.sin ((2 * Real.pi / (n : ℝ)) / 2) /
        (2 * Real.pi / (n : ℝ))) *
          leveque04_periodicCosineMode n i :=
  leveque04_periodicCosine_exactCellAverage n i

/-- The exact-average state inherits the discrete cosine eigenvalue. -/
theorem leveque04_cosineExactPeriodicCellAverage_eigen
    (n : ℕ) [NeZero n] (hn : 2 ≤ n) (i : ZMod n) :
    (leveque04_cosineExactPeriodicCellAverage n (i - 1) +
      leveque04_cosineExactPeriodicCellAverage n (i + 1)) / 2 =
        Real.cos (2 * Real.pi / (n : ℝ)) *
          leveque04_cosineExactPeriodicCellAverage n i := by
  simp only [leveque04_cosineExactPeriodicCellAverage_eq_mode]
  rw [← mul_add]
  calc
    _ = (2 * Real.sin (2 * Real.pi / (n : ℝ) / 2) /
          (2 * Real.pi / (n : ℝ))) *
          ((leveque04_periodicCosineMode n (i - 1) +
            leveque04_periodicCosineMode n (i + 1)) / 2) := by ring
    _ = _ := by
      rw [leveque04_periodicCosineMode_eigen n hn]
      ring

/-- Starting from exact averages of one fixed smooth periodic
stationary solution, the zero-flux Lax–Friedrichs error at cell zero
after `n` steps is at least a positive constant times `1/n`. -/
theorem leveque04_cosineExactPeriodicCellAverage_fixedHorizon_error_lower
    (n : ℕ) [NeZero n] (hn : 5 ≤ n) (ratio : ℝ) :
    16 / (Real.pi * (n : ℝ) * (1 + Real.pi ^ 2)) ≤
      |((leveque04_periodicNonlinearLaxFriedrichsStep n
        (fun _ => 0) ratio)^[n]
          (leveque04_cosineExactPeriodicCellAverage n)) 0 -
            leveque04_cosineExactPeriodicCellAverage n 0| := by
  let amplitude : ℝ :=
    2 * Real.sin ((2 * Real.pi / (n : ℝ)) / 2) /
      (2 * Real.pi / (n : ℝ))
  let factor : ℝ := Real.cos (2 * Real.pi / (n : ℝ))
  have hA : 2 / Real.pi ≤ amplitude :=
    leveque04_periodicCosine_cellAverageAmplitude_lower n (by omega)
  have hA0 : 0 ≤ amplitude :=
    le_trans (by positivity : 0 ≤ 2 / Real.pi) hA
  have hD : 8 / ((n : ℝ) * (1 + Real.pi ^ 2)) ≤
      1 - factor ^ n :=
    leveque04_periodicCosineMode_fixedHorizon_damping_lower n hn
  have hD0 : 0 ≤ 1 - factor ^ n :=
    le_trans (by positivity :
      0 ≤ 8 / ((n : ℝ) * (1 + Real.pi ^ 2))) hD
  have hmode := leveque04_periodicLaxFriedrichs_zeroFlux_mode_error
    n ratio factor (leveque04_cosineExactPeriodicCellAverage n)
    (leveque04_cosineExactPeriodicCellAverage_eigen n (by omega)) n
    (0 : ZMod n)
  have hzero : leveque04_cosineExactPeriodicCellAverage n (0 : ZMod n) =
      amplitude := by
    rw [leveque04_cosineExactPeriodicCellAverage_eq_mode]
    simp [leveque04_periodicCosineMode_apply, amplitude]
  rw [hmode, hzero]
  have herr : |(factor ^ n - 1) * amplitude| =
      amplitude * (1 - factor ^ n) := by
    rw [abs_mul, abs_of_nonpos (by linarith [hD0]),
      abs_of_nonneg hA0]
    ring
  rw [herr]
  have hprod : (2 / Real.pi) *
      (8 / ((n : ℝ) * (1 + Real.pi ^ 2))) ≤
        amplitude * (1 - factor ^ n) := by
    calc
      _ ≤ amplitude * (8 / ((n : ℝ) * (1 + Real.pi ^ 2))) :=
        mul_le_mul_of_nonneg_right hA (by positivity)
      _ ≤ amplitude * (1 - factor ^ n) :=
        mul_le_mul_of_nonneg_left hD hA0
  calc
    _ = (2 / Real.pi) *
        (8 / ((n : ℝ) * (1 + Real.pi ^ 2))) := by
          field_simp
          norm_num
    _ ≤ _ := hprod

/-- On the same exact averages of a fixed smooth periodic stationary
solution, zero-speed upwind preserves cell zero while the periodic
Lax–Friedrichs stencil incurs a first-order excess damping error. -/
theorem leveque04_cosineExactPeriodicCellAverage_excessDiffusion_upwind
    (n : ℕ) [NeZero n] (hn : 5 ≤ n) (ratio : ℝ) :
    16 / (Real.pi * (n : ℝ) * (1 + Real.pi ^ 2)) ≤
      |((leveque04_periodicNonlinearLaxFriedrichsStep n
        (fun _ => 0) ratio)^[n]
          (leveque04_cosineExactPeriodicCellAverage n)) 0 -
        ((leveque04_signedUpwindStep
          (ratio * (2 * Real.pi / (n : ℝ)))
          (2 * Real.pi / (n : ℝ)) 0)^[n]
            (fun j : ℤ =>
              leveque04_cosineExactPeriodicCellAverage n (j : ZMod n))) 0| := by
  rw [leveque04_signedUpwindStep_zero_speed_iterate]
  simpa using
    leveque04_cosineExactPeriodicCellAverage_fixedHorizon_error_lower
      n hn ratio

end NumStability
