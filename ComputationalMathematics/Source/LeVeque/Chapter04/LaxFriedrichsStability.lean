/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CenteredAndLaxFriedrichsFlux
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: scalar Lax–Friedrichs stability

For constant-speed advection, the Lax–Friedrichs update is a convex
combination of neighboring states when the absolute Courant number is at
most one. Every iterate preserves a uniform bound on the initial data.
-/

namespace NumStability

/-- The scalar form of (4.20) for a constant-speed linear flux. -/
noncomputable def leveque04_scalarLaxFriedrichsStep
    (courant : ℝ) (old : ℤ → ℝ) : ℤ → ℝ :=
  fun i => ((1 + courant) / 2) * old (i - 1) +
    ((1 - courant) / 2) * old (i + 1)

/-- The scalar step is precisely the finite-volume Lax–Friedrichs update
of (4.20) for the physical flux `f(q) = speed * q`. -/
theorem leveque04_scalarLaxFriedrichsStep_eq_equation20
    (speed timeStep cellWidth : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < cellWidth)
    (old : ℤ → ℝ) (i : ℤ) :
    leveque04_finiteVolumeUpdate timeStep cellWidth
        (fun (j : ℤ) (_ : Fin 1) => old j)
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux timeStep cellWidth
            (fun (state : Fin 1 → ℝ) (_ : Fin 1) => speed * state 0))
          (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 =
      leveque04_scalarLaxFriedrichsStep
        (speed * timeStep / cellWidth) old i := by
  rw [leveque04_equation20 timeStep cellWidth
    (fun (state : Fin 1 → ℝ) (_ : Fin 1) => speed * state 0)
    (fun (j : ℤ) (_ : Fin 1) => old j) i 0 htime hwidth]
  dsimp [leveque04_scalarLaxFriedrichsStep]
  field_simp
  ring

/-- Under CFL, both Lax–Friedrichs weights are nonnegative and sum to one. -/
theorem leveque04_scalarLaxFriedrichs_weights
    (courant : ℝ) (hcfl : |courant| ≤ 1) :
    0 ≤ (1 + courant) / 2 ∧
      0 ≤ (1 - courant) / 2 ∧
      (1 + courant) / 2 + (1 - courant) / 2 = 1 := by
  constructor
  · have h := (abs_le.mp hcfl).1
    linarith
  constructor
  · have h := (abs_le.mp hcfl).2
    linarith
  · ring

/-- One scalar Lax–Friedrichs step preserves any uniform absolute bound. -/
theorem leveque04_scalarLaxFriedrichsStep_bound
    (courant bound : ℝ) (hcfl : |courant| ≤ 1)
    (old : ℤ → ℝ) (hbound : ∀ i, |old i| ≤ bound) (i : ℤ) :
    |leveque04_scalarLaxFriedrichsStep courant old i| ≤ bound := by
  obtain ⟨hleft, hright, hsum⟩ :=
    leveque04_scalarLaxFriedrichs_weights courant hcfl
  dsimp [leveque04_scalarLaxFriedrichsStep]
  calc
    |(1 + courant) / 2 * old (i - 1) +
        (1 - courant) / 2 * old (i + 1)| ≤
        |(1 + courant) / 2 * old (i - 1)| +
          |(1 - courant) / 2 * old (i + 1)| := abs_add_le _ _
    _ = (1 + courant) / 2 * |old (i - 1)| +
          (1 - courant) / 2 * |old (i + 1)| := by
      rw [abs_mul, abs_mul, abs_of_nonneg hleft, abs_of_nonneg hright]
    _ ≤ (1 + courant) / 2 * bound + (1 - courant) / 2 * bound := by
      exact add_le_add
        (mul_le_mul_of_nonneg_left (hbound (i - 1)) hleft)
        (mul_le_mul_of_nonneg_left (hbound (i + 1)) hright)
    _ = bound := by rw [← add_mul, hsum, one_mul]

/-- The CFL bound is preserved over any number of Lax–Friedrichs steps. -/
theorem leveque04_scalarLaxFriedrichs_iterate_bound
    (courant bound : ℝ) (hcfl : |courant| ≤ 1)
    (initial : ℤ → ℝ) (hbound : ∀ i, |initial i| ≤ bound)
    (n : ℕ) (i : ℤ) :
    |((leveque04_scalarLaxFriedrichsStep courant)^[n] initial) i| ≤ bound := by
  induction n generalizing i with
  | zero => simpa using hbound i
  | succ n ih =>
      rw [Function.iterate_succ_apply']
      exact leveque04_scalarLaxFriedrichsStep_bound courant bound hcfl
        _ ih i

end NumStability
