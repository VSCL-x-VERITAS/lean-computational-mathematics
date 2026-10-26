/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CourantNumbers
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LpUpwindNecessity
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4, equations (4.24)–(4.27): positive-speed upwind method

For a positive constant advection speed, the interface flux uses the left
cell value. The conservative update is a one-sided difference, and its
Courant form interpolates between the left and current old cell values.
-/

namespace NumStability

/-- Positive-speed upwind numerical flux at the left face of cell `i`. -/
def leveque04_positiveUpwindInterfaceFlux
    (velocity : ℝ) (cellAverage : ℤ → ℝ) (i : ℤ) : ℝ :=
  velocity * cellAverage (i - 1)

/-- The interface flux (4.24) takes the old state on the upwind left. -/
theorem leveque04_equation24
    (velocity : ℝ) (_hvelocity : 0 < velocity)
    (cellAverage : ℤ → ℝ) (i : ℤ) :
    leveque04_positiveUpwindInterfaceFlux velocity cellAverage i =
      velocity * cellAverage (i - 1) := rfl

/-- The conservative step with the positive-speed upwind interface flux. -/
noncomputable def leveque04_positiveUpwindStep
    (timeStep cellWidth velocity : ℝ) (cellAverage : ℤ → ℝ) (i : ℤ) : ℝ :=
  conservativeFluxDifferenceUpdateInt (timeStep / cellWidth) cellAverage
    (leveque04_positiveUpwindInterfaceFlux velocity cellAverage) i

/-- Equation (4.25): the positive-speed one-sided advection difference. -/
theorem leveque04_equation25
    (timeStep cellWidth velocity : ℝ)
    (cellAverage : ℤ → ℝ) (i : ℤ) (_hvelocity : 0 < velocity) :
    leveque04_positiveUpwindStep timeStep cellWidth velocity cellAverage i =
      cellAverage i - velocity * timeStep / cellWidth *
        (cellAverage i - cellAverage (i - 1)) := by
  simp only [leveque04_positiveUpwindStep,
    conservativeFluxDifferenceUpdateInt, smul_eq_mul,
    leveque04_positiveUpwindInterfaceFlux, add_sub_cancel_right]
  ring

/-- Equation (4.26): the same update is a linear interpolation with Courant
weight on the preceding cell. -/
theorem leveque04_equation26
    (timeStep cellWidth velocity : ℝ)
    (cellAverage : ℤ → ℝ) (i : ℤ) (hvelocity : 0 < velocity) :
    leveque04_positiveUpwindStep timeStep cellWidth velocity cellAverage i =
      (velocity * timeStep / cellWidth) * cellAverage (i - 1) +
        (1 - velocity * timeStep / cellWidth) * cellAverage i := by
  rw [leveque04_equation25 timeStep cellWidth velocity cellAverage i hvelocity]
  ring

/-- The displayed condition (4.27) for the two interpolation weights. -/
def IsLeveque04PositiveUpwindCFL
    (timeStep cellWidth velocity : ℝ) : Prop :=
  0 ≤ velocity * timeStep / cellWidth ∧
    velocity * timeStep / cellWidth ≤ 1

/-- For positive speed, time step and width, scalar CFL at most one gives
exactly the nonnegative Courant-weight condition (4.27). -/
theorem leveque04_equation27
    (timeStep cellWidth velocity : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < cellWidth)
    (hvelocity : 0 < velocity)
    (hcfl : leveque04_scalarCourantNumber timeStep cellWidth velocity ≤ 1) :
    IsLeveque04PositiveUpwindCFL timeStep cellWidth velocity := by
  have hnonneg : 0 ≤ velocity * timeStep / cellWidth :=
    div_nonneg (mul_nonneg hvelocity.le htime.le) hwidth.le
  refine ⟨hnonneg, ?_⟩
  simpa [leveque04_scalarCourantNumber, abs_of_nonneg hnonneg]
    using hcfl


/-- Equation (4.27), with the Chapter 8 stability definition referenced by its
local proof: positive-speed upwind is stable in the physical one-norm on
fixed-ratio positive mesh refinements exactly when its Courant weight is in
the unit interval. -/
theorem leveque04_upwind_oneNorm_refinementStable_iff_cfl
    (speed ratio : ℝ) (hspeed : 0 < speed) (hratio : 0 < ratio) :
    IsLpUpwindOneNormRefinementStable speed ratio ↔
      0 ≤ speed * ratio ∧ speed * ratio ≤ 1 :=
  lpUpwindOneNormRefinementStable_iff_cfl speed ratio hspeed hratio

end NumStability
