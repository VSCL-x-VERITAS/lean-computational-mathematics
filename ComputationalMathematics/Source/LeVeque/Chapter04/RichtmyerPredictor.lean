/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CenteredAndLaxFriedrichsFlux
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4, equations (4.22) and (4.23): Richtmyer predictor

The two-state half-time predictor uses the same neighbor average and centered
physical-flux difference as a staggered Lax–Friedrichs step. The interface
numerical flux is the physical flux of that predicted state.
-/

namespace NumStability

/-- Half-time state between neighboring cells, using their old-level states. -/
noncomputable def leveque04_richtmyerPredictor {m : ℕ}
    (timeStep cellWidth : ℝ)
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (left right : Fin m → ℝ) : Fin m → ℝ :=
  (1 / 2 : ℝ) • (left + right) -
    (timeStep / (2 * cellWidth)) • (physicalFlux right - physicalFlux left)

/-- Equation (4.23), componentwise: a neighbor-state average minus a
centered physical-flux difference at the half-time interface. -/
theorem leveque04_equation23 {m : ℕ}
    (timeStep cellWidth : ℝ)
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (left right : Fin m → ℝ) (k : Fin m) :
    leveque04_richtmyerPredictor timeStep cellWidth physicalFlux left right k =
      (left k + right k) / 2 -
        timeStep / (2 * cellWidth) *
          (physicalFlux right k - physicalFlux left k) := by
  simp [leveque04_richtmyerPredictor, Pi.sub_apply, Pi.add_apply,
    Pi.smul_apply, smul_eq_mul]
  ring

/-- The Richtmyer numerical flux applies the physical flux to the half-time
predicted interface state. -/
noncomputable def leveque04_richtmyerFlux {m : ℕ}
    (timeStep cellWidth : ℝ)
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (left right : Fin m → ℝ) : Fin m → ℝ :=
  physicalFlux (leveque04_richtmyerPredictor timeStep cellWidth
    physicalFlux left right)

/-- Equation (4.22): the physical flux evaluated at the predicted
half-time state is the numerical interface flux. -/
theorem leveque04_equation22 {m : ℕ}
    (timeStep cellWidth : ℝ)
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (left right : Fin m → ℝ) :
    leveque04_richtmyerFlux timeStep cellWidth physicalFlux left right =
      physicalFlux (leveque04_richtmyerPredictor timeStep cellWidth
        physicalFlux left right) := rfl

end NumStability
