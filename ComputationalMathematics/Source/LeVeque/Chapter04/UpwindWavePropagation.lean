/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.PositiveSpeedUpwind
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4, equations (4.28)–(4.35): signed upwind waves

Left and right jumps represent the waves entering a cell from its neighboring
interfaces. Splitting a constant velocity into positive and negative parts
combines the two one-sided updates in a single conservative flux.
-/

namespace NumStability

/-- Jump crossing the left face of cell `i`. -/
def leveque04_leftWaveJump (cellAverage : ℤ → ℝ) (i : ℤ) : ℝ :=
  cellAverage i - cellAverage (i - 1)

/-- Equation (4.28): positive-speed upwind update in left-wave form. -/
theorem leveque04_equation28
    (timeStep cellWidth velocity : ℝ)
    (cellAverage : ℤ → ℝ) (i : ℤ) (hvelocity : 0 < velocity) :
    leveque04_positiveUpwindStep timeStep cellWidth velocity cellAverage i =
      cellAverage i - velocity * timeStep / cellWidth *
        leveque04_leftWaveJump cellAverage i := by
  simpa only [leveque04_leftWaveJump] using
    leveque04_equation25 timeStep cellWidth velocity cellAverage i hvelocity

/-- Positive and negative parts of the constant advection velocity, as in
(4.34). -/
noncomputable def leveque04_positiveVelocity (velocity : ℝ) : ℝ := max velocity 0
noncomputable def leveque04_negativeVelocity (velocity : ℝ) : ℝ := min velocity 0

/-- Equation (4.34), exposing both sign-split velocity definitions. -/
theorem leveque04_equation34 (velocity : ℝ) :
    leveque04_positiveVelocity velocity = max velocity 0 ∧
      leveque04_negativeVelocity velocity = min velocity 0 := ⟨rfl, rfl⟩

/-- Combined signed upwind flux at the left face of cell `i`. -/
noncomputable def leveque04_signedUpwindInterfaceFlux
    (velocity : ℝ) (cellAverage : ℤ → ℝ) (i : ℤ) : ℝ :=
  leveque04_positiveVelocity velocity * cellAverage (i - 1) +
    leveque04_negativeVelocity velocity * cellAverage i

/-- Equation (4.33), the positive and negative velocity parts acting on the
left and right cell values respectively. -/
theorem leveque04_equation33
    (velocity : ℝ) (cellAverage : ℤ → ℝ) (i : ℤ) :
    leveque04_signedUpwindInterfaceFlux velocity cellAverage i =
      leveque04_negativeVelocity velocity * cellAverage i +
        leveque04_positiveVelocity velocity * cellAverage (i - 1) := by
  simp only [leveque04_signedUpwindInterfaceFlux]
  ring

/-- Equation (4.29): negative-speed flux uses the right cell at the left
interface of cell `i`. -/
theorem leveque04_equation29
    (velocity : ℝ) (hvelocity : velocity < 0)
    (cellAverage : ℤ → ℝ) (i : ℤ) :
    leveque04_signedUpwindInterfaceFlux velocity cellAverage i =
      velocity * cellAverage i := by
  simp [leveque04_signedUpwindInterfaceFlux,
    leveque04_positiveVelocity, leveque04_negativeVelocity,
    max_eq_right hvelocity.le, min_eq_left hvelocity.le]

/-- The conservative step using the signed upwind interface flux. -/
noncomputable def leveque04_signedUpwindStep
    (timeStep cellWidth velocity : ℝ)
    (cellAverage : ℤ → ℝ) (i : ℤ) : ℝ :=
  conservativeFluxDifferenceUpdateInt (timeStep / cellWidth) cellAverage
    (leveque04_signedUpwindInterfaceFlux velocity cellAverage) i

/-- Jump crossing the right face of cell `i`. -/
def leveque04_rightWaveJump (cellAverage : ℤ → ℝ) (i : ℤ) : ℝ :=
  cellAverage (i + 1) - cellAverage i

/-- Equation (4.35): one combined wave-propagation update for velocities of
either sign. -/
theorem leveque04_equation35
    (timeStep cellWidth velocity : ℝ)
    (cellAverage : ℤ → ℝ) (i : ℤ) :
    leveque04_signedUpwindStep timeStep cellWidth velocity cellAverage i =
      cellAverage i - timeStep / cellWidth *
        (leveque04_positiveVelocity velocity *
            leveque04_leftWaveJump cellAverage i +
          leveque04_negativeVelocity velocity *
            leveque04_rightWaveJump cellAverage i) := by
  simp only [leveque04_signedUpwindStep,
    conservativeFluxDifferenceUpdateInt, smul_eq_mul,
    leveque04_signedUpwindInterfaceFlux, leveque04_leftWaveJump,
    leveque04_rightWaveJump, add_sub_cancel_right]
  ring

/-- Equation (4.30): for negative velocity the right one-sided difference
enters the cell update. -/
theorem leveque04_equation30
    (timeStep cellWidth velocity : ℝ)
    (cellAverage : ℤ → ℝ) (i : ℤ) (hvelocity : velocity < 0) :
    leveque04_signedUpwindStep timeStep cellWidth velocity cellAverage i =
      cellAverage i - velocity * timeStep / cellWidth *
        (cellAverage (i + 1) - cellAverage i) := by
  simp only [leveque04_signedUpwindStep,
    conservativeFluxDifferenceUpdateInt, smul_eq_mul]
  rw [leveque04_equation29 velocity hvelocity cellAverage (i + 1),
    leveque04_equation29 velocity hvelocity cellAverage i]
  ring

/-- Equation (4.31): the same negative-speed update as a right-wave change. -/
theorem leveque04_equation31
    (timeStep cellWidth velocity : ℝ)
    (cellAverage : ℤ → ℝ) (i : ℤ) (hvelocity : velocity < 0) :
    leveque04_signedUpwindStep timeStep cellWidth velocity cellAverage i =
      cellAverage i - velocity * timeStep / cellWidth *
        leveque04_rightWaveJump cellAverage i := by
  simpa only [leveque04_rightWaveJump] using
    leveque04_equation30 timeStep cellWidth velocity cellAverage i hvelocity

/-- Equation (4.32): the signed Courant weight lies in `[-1,0]` for
negative velocity when the scalar CFL number is at most one. -/
theorem leveque04_equation32
    (timeStep cellWidth velocity : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < cellWidth)
    (hvelocity : velocity < 0)
    (hcfl : leveque04_scalarCourantNumber timeStep cellWidth velocity ≤ 1) :
    -1 ≤ velocity * timeStep / cellWidth ∧
      velocity * timeStep / cellWidth ≤ 0 := by
  have hnonpos : velocity * timeStep / cellWidth ≤ 0 :=
    div_nonpos_of_nonpos_of_nonneg
      (mul_nonpos_of_nonpos_of_nonneg hvelocity.le htime.le) hwidth.le
  have habs : |velocity * timeStep / cellWidth| ≤ 1 := by
    simpa only [leveque04_scalarCourantNumber] using hcfl
  exact ⟨(abs_le.mp habs).1, hnonpos⟩

/-- Equation (4.30) on the source's positive space and forward-time mesh.
The underlying algebraic identity is `leveque04_equation30`. -/
theorem leveque04_equation30_physical
    (timeStep cellWidth velocity : ℝ)
    (cellAverage : ℤ → ℝ) (i : ℤ)
    (_htime : 0 < timeStep) (_hwidth : 0 < cellWidth) (hvelocity : velocity < 0) :
    leveque04_signedUpwindStep timeStep cellWidth velocity cellAverage i =
      cellAverage i - velocity * timeStep / cellWidth *
        (cellAverage (i + 1) - cellAverage i) :=
  leveque04_equation30 timeStep cellWidth velocity cellAverage i hvelocity

/-- Equation (4.31) on the source's positive space and forward-time mesh. -/
theorem leveque04_equation31_physical
    (timeStep cellWidth velocity : ℝ)
    (cellAverage : ℤ → ℝ) (i : ℤ)
    (_htime : 0 < timeStep) (_hwidth : 0 < cellWidth) (hvelocity : velocity < 0) :
    leveque04_signedUpwindStep timeStep cellWidth velocity cellAverage i =
      cellAverage i - velocity * timeStep / cellWidth *
        leveque04_rightWaveJump cellAverage i :=
  leveque04_equation31 timeStep cellWidth velocity cellAverage i hvelocity

/-- Equation (4.35) on the source's positive space and forward-time mesh,
for either sign of the constant velocity. -/
theorem leveque04_equation35_physical
    (timeStep cellWidth velocity : ℝ)
    (cellAverage : ℤ → ℝ) (i : ℤ)
    (_htime : 0 < timeStep) (_hwidth : 0 < cellWidth) :
    leveque04_signedUpwindStep timeStep cellWidth velocity cellAverage i =
      cellAverage i - timeStep / cellWidth *
        (leveque04_positiveVelocity velocity * leveque04_leftWaveJump cellAverage i +
          leveque04_negativeVelocity velocity * leveque04_rightWaveJump cellAverage i) :=
  leveque04_equation35 timeStep cellWidth velocity cellAverage i

end NumStability
