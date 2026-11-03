/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.UniformAdvection
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.Analysis.Calculus.Deriv.Pow
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Tactic.Positivity

/-!
# A nonexact quadratic time-Taylor approximation for scalar advection

The path is an explicit approximation to the same constant-speed equation as
its traveling-wave reference. Its input-prescribed residual and endpoint
budgets are exact. All spatial integrals are over finite cells; a globally
bounded profile or a global spatial Lp norm is not assumed.
-/

open MeasureTheory

namespace NumStability.AdvectionTaylor

/-- A quadratic initial profile, with its coefficients fixed by the input. -/
def quadraticProfile (curvature linear constant x : ℝ) : ℝ :=
  curvature * x ^ 2 + linear * x + constant

/-- The first time-Taylor path for the same scalar advection speed. -/
def quadraticTaylorPath (speed curvature linear constant x t : ℝ) : ℝ :=
  quadraticProfile curvature linear constant x -
    speed * t * (2 * curvature * x + linear)

/-- A prescribed bound on the literal advection residual on a forward step. -/
def residualBudget (speed curvature t : ℝ) : ℝ :=
  2 * |curvature| * speed ^ 2 * t

/-- A prescribed endpoint error bound, depending only on input coefficients and step. -/
def endpointBudget (speed curvature timeStep : ℝ) : ℝ :=
  |curvature| * speed ^ 2 * timeStep ^ 2

theorem quadraticProfile_hasDerivAt (curvature linear constant x : ℝ) :
    HasDerivAt (quadraticProfile curvature linear constant)
      (2 * curvature * x + linear) x := by
  unfold quadraticProfile
  convert ((((hasDerivAt_id x).pow 2).const_mul curvature).add
    ((hasDerivAt_id x).const_mul linear)).add_const constant using 1
  simp only [id_eq]
  ring

theorem quadraticTaylorPath_initial (speed curvature linear constant x : ℝ) :
    quadraticTaylorPath speed curvature linear constant x 0 =
      quadraticProfile curvature linear constant x := by
  simp [quadraticTaylorPath]

theorem quadraticTaylorPath_hasDerivAt_time
    (speed curvature linear constant x t : ℝ) :
    HasDerivAt (fun τ => quadraticTaylorPath speed curvature linear constant x τ)
      (-speed * (2 * curvature * x + linear)) t := by
  simpa [quadraticTaylorPath] using
    (hasDerivAt_const t (quadraticProfile curvature linear constant x)).sub
      (((hasDerivAt_id t).const_mul speed).mul_const (2 * curvature * x + linear))

theorem quadraticTaylorPath_hasDerivAt_space
    (speed curvature linear constant x t : ℝ) :
    HasDerivAt (fun y => quadraticTaylorPath speed curvature linear constant y t)
      (2 * curvature * x + linear - 2 * curvature * speed * t) x := by
  have hlinear : HasDerivAt (fun y : ℝ => 2 * curvature * y + linear)
      (2 * curvature) x := by
    simpa using ((hasDerivAt_id x).const_mul (2 * curvature)).add_const linear
  convert (quadraticProfile_hasDerivAt curvature linear constant x).sub
    (hlinear.const_mul (speed * t)) using 1
  dsimp only [quadraticTaylorPath]
  ring

theorem quadraticTaylorPath_contDiff (speed curvature linear constant : ℝ) :
    ContDiff ℝ 1 (Function.uncurry (quadraticTaylorPath speed curvature linear constant)) := by
  unfold Function.uncurry quadraticTaylorPath quadraticProfile
  fun_prop

theorem quadraticProfile_intervalIntegrable (curvature linear constant left right : ℝ) :
    IntervalIntegrable (quadraticProfile curvature linear constant) volume left right := by
  apply Continuous.intervalIntegrable
  unfold quadraticProfile
  fun_prop

theorem quadraticTaylorPath_intervalIntegrable
    (speed curvature linear constant t left right : ℝ) :
    IntervalIntegrable (fun x => quadraticTaylorPath speed curvature linear constant x t)
      volume left right := by
  apply Continuous.intervalIntegrable
  unfold quadraticTaylorPath quadraticProfile
  fun_prop

theorem quadraticReference_intervalIntegrable
    (speed curvature linear constant t left right : ℝ) :
    IntervalIntegrable
      (fun x => travelingWave (quadraticProfile curvature linear constant) speed x t)
      volume left right := by
  apply Continuous.intervalIntegrable
  unfold travelingWave quadraticProfile
  fun_prop

/-- The reference solves the same actual scalar advection PDE. -/
theorem quadraticReference_isLinearAdvectionSolution
    (speed curvature linear constant : ℝ) :
    IsLinearAdvectionSolution
      (travelingWave (quadraticProfile curvature linear constant) speed) speed := by
  exact travelingWave_isLinearAdvectionSolution speed
    (fun x => (quadraticProfile_hasDerivAt curvature linear constant x).differentiableAt)

/-- The same reference has the actual integral conservation law with flux speed times state. -/
theorem quadraticReference_isRectangleConservationLawSolution
    (speed curvature linear constant : ℝ) :
    IsRectangleConservationLawSolution
      (travelingWave (quadraticProfile curvature linear constant) speed)
      (fun state : ℝ => speed • state) := by
  exact travelingWave_isRectangleConservationLawSolution _
    (quadraticProfile_intervalIntegrable curvature linear constant) speed

/-- The actual derivatives, not a nominal model label, determine this residual. -/
theorem quadraticTaylorPath_residual (speed curvature linear constant x t : ℝ) :
    deriv (fun τ => quadraticTaylorPath speed curvature linear constant x τ) t +
      speed * deriv (fun y => quadraticTaylorPath speed curvature linear constant y t) x =
        -2 * curvature * speed ^ 2 * t := by
  rw [(quadraticTaylorPath_hasDerivAt_time speed curvature linear constant x t).deriv,
    (quadraticTaylorPath_hasDerivAt_space speed curvature linear constant x t).deriv]
  ring

theorem residualBudget_nonneg (speed curvature t : ℝ) (ht : 0 ≤ t) :
    0 ≤ residualBudget speed curvature t := by
  unfold residualBudget
  positivity

theorem endpointBudget_nonneg (speed curvature timeStep : ℝ) :
    0 ≤ endpointBudget speed curvature timeStep := by
  unfold endpointBudget
  positivity

theorem quadraticTaylorPath_abs_residual
    (speed curvature linear constant x t : ℝ) (ht : 0 ≤ t) :
    |deriv (fun τ => quadraticTaylorPath speed curvature linear constant x τ) t +
      speed * deriv (fun y => quadraticTaylorPath speed curvature linear constant y t) x| =
        residualBudget speed curvature t := by
  rw [quadraticTaylorPath_residual]
  simp [residualBudget, abs_mul, abs_of_nonneg ht, abs_of_nonneg (sq_nonneg speed)]

/-- The input residual budget integrates to the input endpoint budget. -/
theorem integral_residualBudget (speed curvature timeStep : ℝ) :
    (∫ t in (0 : ℝ)..timeStep, residualBudget speed curvature t) =
      endpointBudget speed curvature timeStep := by
  unfold residualBudget endpointBudget
  rw [intervalIntegral.integral_const_mul, integral_id]
  ring

/-- The explicit approximate path differs from the actual transported initial field. -/
theorem quadraticTaylorPath_sub_reference (speed curvature linear constant x t : ℝ) :
    quadraticTaylorPath speed curvature linear constant x t -
      travelingWave (quadraticProfile curvature linear constant) speed x t =
        -curvature * speed ^ 2 * t ^ 2 := by
  unfold quadraticTaylorPath travelingWave quadraticProfile
  ring

theorem quadraticTaylorPath_abs_error (speed curvature linear constant x t : ℝ) :
    |quadraticTaylorPath speed curvature linear constant x t -
      travelingWave (quadraticProfile curvature linear constant) speed x t| =
        endpointBudget speed curvature t := by
  rw [quadraticTaylorPath_sub_reference]
  simp [endpointBudget, abs_mul, abs_of_nonneg (sq_nonneg speed),
    abs_of_nonneg (sq_nonneg t)]

theorem endpointBudget_pos (speed curvature timeStep : ℝ)
    (hproduct : speed * curvature ≠ 0) (hstep : 0 < timeStep) :
    0 < endpointBudget speed curvature timeStep := by
  have hspeed : speed ≠ 0 := (mul_ne_zero_iff.mp hproduct).1
  have hcurvature : curvature ≠ 0 := (mul_ne_zero_iff.mp hproduct).2
  unfold endpointBudget
  positivity

/-- Nonzero speed and curvature give a genuinely nonexact endpoint at every point. -/
theorem quadraticTaylorPath_ne_reference
    (speed curvature linear constant x timeStep : ℝ)
    (hproduct : speed * curvature ≠ 0) (hstep : 0 < timeStep) :
    quadraticTaylorPath speed curvature linear constant x timeStep ≠
      travelingWave (quadraticProfile curvature linear constant) speed x timeStep := by
  intro heq
  have herror := quadraticTaylorPath_abs_error speed curvature linear constant x timeStep
  rw [heq, sub_self, abs_zero] at herror
  have hpos := endpointBudget_pos speed curvature timeStep hproduct hstep
  linarith

/-- The error is the same constant in the actual normalized means of every positive cell. -/
theorem quadraticTaylorPath_cellAverage_sub_reference
    (speed curvature linear constant timeStep left right : ℝ) (hcell : left < right) :
    oneDimensionalCellAverage
        (fun x => quadraticTaylorPath speed curvature linear constant x timeStep) left right -
      oneDimensionalCellAverage
        (fun x => travelingWave (quadraticProfile curvature linear constant) speed x timeStep)
        left right = -curvature * speed ^ 2 * timeStep ^ 2 := by
  have happrox := quadraticTaylorPath_intervalIntegrable speed curvature linear constant
    timeStep left right
  have href := quadraticReference_intervalIntegrable speed curvature linear constant
    timeStep left right
  have hdiff : (fun x => quadraticTaylorPath speed curvature linear constant x timeStep -
      travelingWave (quadraticProfile curvature linear constant) speed x timeStep) =
      (fun _ : ℝ => -curvature * speed ^ 2 * timeStep ^ 2) := by
    funext x
    exact quadraticTaylorPath_sub_reference speed curvature linear constant x timeStep
  unfold oneDimensionalCellAverage
  rw [← smul_sub, ← intervalIntegral.integral_sub happrox href, hdiff,
    intervalIntegral.integral_const]
  simp only [smul_eq_mul]
  have hwidth : right - left ≠ 0 := ne_of_gt (sub_pos.mpr hcell)
  field_simp [hwidth]

theorem quadraticTaylorPath_cellAverage_abs_error
    (speed curvature linear constant timeStep left right : ℝ) (hcell : left < right) :
    |oneDimensionalCellAverage
        (fun x => quadraticTaylorPath speed curvature linear constant x timeStep) left right -
      oneDimensionalCellAverage
        (fun x => travelingWave (quadraticProfile curvature linear constant) speed x timeStep)
        left right| = endpointBudget speed curvature timeStep := by
  rw [quadraticTaylorPath_cellAverage_sub_reference speed curvature linear constant
    timeStep left right hcell]
  simp [endpointBudget, abs_mul, abs_of_nonneg (sq_nonneg speed),
    abs_of_nonneg (sq_nonneg timeStep)]

/-- The same example is nonexact after actual finite-volume averaging. -/
theorem quadraticTaylorPath_cellAverage_ne_reference
    (speed curvature linear constant timeStep left right : ℝ) (hcell : left < right)
    (hproduct : speed * curvature ≠ 0) (hstep : 0 < timeStep) :
    oneDimensionalCellAverage
        (fun x => quadraticTaylorPath speed curvature linear constant x timeStep) left right ≠
      oneDimensionalCellAverage
        (fun x => travelingWave (quadraticProfile curvature linear constant) speed x timeStep)
        left right := by
  intro heq
  have herror := quadraticTaylorPath_cellAverage_abs_error speed curvature linear constant
    timeStep left right hcell
  rw [heq, sub_self, abs_zero] at herror
  have hpos := endpointBudget_pos speed curvature timeStep hproduct hstep
  linarith

end NumStability.AdvectionTaylor
