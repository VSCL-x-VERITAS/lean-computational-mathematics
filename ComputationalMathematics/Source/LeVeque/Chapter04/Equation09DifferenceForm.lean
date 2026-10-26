/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Equation04ConservativeUpdate
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4, equation (4.9): finite-difference form

The conservative cell update can be written as a zero time-difference plus
flux-difference residual at each component.
-/

namespace NumStability

/-- For positive time step and cell width, the update relation and zero
finite-difference residual are equivalent at a selected cell/component. -/
theorem leveque04_equation09_iff {m : ℕ}
    (timeStep cellWidth : ℝ) (htime : 0 < timeStep)
    (hwidth : 0 < cellWidth)
    (before after edgeFlux : ℤ → (Fin m → ℝ)) (i : ℤ) (k : Fin m) :
    after i k = before i k -
        (timeStep / cellWidth) * (edgeFlux (i + 1) k - edgeFlux i k) ↔
      (after i k - before i k) / timeStep +
        (edgeFlux (i + 1) k - edgeFlux i k) / cellWidth = 0 := by
  constructor
  · intro hupdate
    rw [hupdate]
    field_simp
    ring
  · intro hresidual
    have hdiff : (after i k - before i k) / timeStep =
        -((edgeFlux (i + 1) k - edgeFlux i k) / cellWidth) :=
      eq_neg_of_add_eq_zero_left hresidual
    calc
      after i k = before i k +
          timeStep * ((after i k - before i k) / timeStep) := by
            field_simp
            ring
      _ = before i k -
          (timeStep / cellWidth) * (edgeFlux (i + 1) k - edgeFlux i k) := by
            rw [hdiff]
            ring

/-- Rearranging a conservative update gives the finite-difference equation
(4.9) with the same right-minus-left interface flux orientation. -/
theorem leveque04_equation09 {m : ℕ}
    (timeStep cellWidth : ℝ) (htime : 0 < timeStep)
    (hwidth : 0 < cellWidth)
    (cellAverage edgeFlux : ℤ → (Fin m → ℝ)) (i : ℤ) (k : Fin m) :
    (leveque04_finiteVolumeUpdate timeStep cellWidth cellAverage edgeFlux i k -
        cellAverage i k) / timeStep +
      (edgeFlux (i + 1) k - edgeFlux i k) / cellWidth = 0 := by
  simp only [leveque04_finiteVolumeUpdate,
    conservativeFluxDifferenceUpdateInt, Pi.sub_apply, Pi.smul_apply,
    smul_eq_mul]
  field_simp
  ring

end NumStability
