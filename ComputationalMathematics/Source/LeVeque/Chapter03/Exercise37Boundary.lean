/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.AcousticBoundary

/-!
# Exercise 3.7: piston and wall characteristic data

Printed page 63/raw PDF page 85. The piston prescribes velocity `epsilon`
at the left end of the unit tube; the right wall prescribes zero velocity.
-/

namespace NumStability

/-- The piston wall velocity for Exercise 3.7. -/
def leveque03_exercise37PistonWallVelocity
    (velocity : ℝ → ℝ → ℝ) (epsilon : ℝ) : Prop :=
  ∀ t, 0 < t → velocity 0 t = epsilon ∧ velocity 1 t = 0

theorem leveque03_exercise37BoundaryVariables
    (density soundSpeed epsilon : ℝ)
    (hZ : acousticImpedance density soundSpeed ≠ 0)
    (pressure velocity : ℝ → ℝ → ℝ) :
    leveque03_exercise37PistonWallVelocity velocity epsilon ↔
      (∀ t, 0 < t →
        leveque03_acousticBoundaryVariables density soundSpeed
            (pressure 0 t) (velocity 0 t) 1 =
          2 * acousticImpedance density soundSpeed * epsilon -
            leveque03_acousticBoundaryVariables density soundSpeed
              (pressure 0 t) (velocity 0 t) 0) ∧
      (∀ t, 0 < t →
        leveque03_acousticBoundaryVariables density soundSpeed
            (pressure 1 t) (velocity 1 t) 0 =
          -leveque03_acousticBoundaryVariables density soundSpeed
            (pressure 1 t) (velocity 1 t) 1) := by
  constructor
  · intro hv
    constructor
    · intro t ht
      have h := (hv t ht).1
      simp [leveque03_acousticBoundaryVariables, h]
      ring
    · intro t ht
      have h := (hv t ht).2
      simp [leveque03_acousticBoundaryVariables, h]
  · rintro ⟨hleft, hright⟩ t ht
    constructor
    · have hs := leveque03_acousticBoundaryVariables_sum density soundSpeed
        (pressure 0 t) (velocity 0 t)
      rw [hleft t ht] at hs
      have hmul : acousticImpedance density soundSpeed *
          (velocity 0 t - epsilon) = 0 := by linarith
      exact sub_eq_zero.mp ((mul_eq_zero.mp hmul).resolve_left hZ)
    · have hs := leveque03_acousticBoundaryVariables_sum density soundSpeed
        (pressure 1 t) (velocity 1 t)
      rw [hright t ht] at hs
      have hmul : acousticImpedance density soundSpeed * velocity 1 t = 0 := by
        linarith
      exact (mul_eq_zero.mp hmul).resolve_left hZ

theorem leveque03_exercise37InitialBoundaryVariables
    (density soundSpeed initialPressure : ℝ) :
    leveque03_acousticBoundaryVariables density soundSpeed initialPressure 0 =
      ![-initialPressure, initialPressure] := by
  ext i
  fin_cases i <;>
    simp [leveque03_acousticBoundaryVariables]

end NumStability
