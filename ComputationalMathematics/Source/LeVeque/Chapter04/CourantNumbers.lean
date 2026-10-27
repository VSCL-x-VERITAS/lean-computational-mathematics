/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Finset.Lattice.Fold
import Mathlib.Data.Fintype.Fin
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ScalarCourantNumber
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.SystemCourantNumber

/-!
# LeVeque Chapter 4, equations (4.16) and (4.17): Courant numbers

The scalar three-point numerical cone reaches one cell width per time step.
Equation (4.16) expresses the resulting speed bound as a dimensionless
Courant number. Equation (4.17) uses the greatest absolute characteristic
speed of a finite-dimensional system.
-/

namespace NumStability

/-- Equation (4.16): the one-cell-per-step speed-cone condition is exactly
that the scalar Courant number does not exceed one. This is the algebraic
CFL condition, separate from the general convergence-necessity theorem. -/
theorem leveque04_equation16
    (timeStep cellWidth velocity : ℝ)
    (_htime : 0 < timeStep) (hwidth : 0 < cellWidth) :
    leveque04_scalarCourantNumber timeStep cellWidth velocity ≤ 1 ↔
      -cellWidth ≤ velocity * timeStep ∧
        velocity * timeStep ≤ cellWidth := by
  simp only [leveque04_scalarCourantNumber, abs_div, abs_of_pos hwidth]
  rw [div_le_iff₀ hwidth]
  simpa only [one_mul] using (abs_le :
    |velocity * timeStep| ≤ cellWidth ↔
      -cellWidth ≤ velocity * timeStep ∧
        velocity * timeStep ≤ cellWidth)

/-- Equation (4.17), exposing the finite characteristic-speed maximum. -/
theorem leveque04_equation17
    {m : ℕ} [NeZero m] (timeStep cellWidth : ℝ) (speed : Fin m → ℝ)
    (_htime : 0 < timeStep) (_hwidth : 0 < cellWidth) :
    leveque04_systemCourantNumber timeStep cellWidth speed =
      timeStep / cellWidth *
        Finset.univ.sup' (by exact ⟨0, Finset.mem_univ (0 : Fin m)⟩)
          (fun p => |speed p|) := rfl

end NumStability
