/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CenteredFlux

/-!
# Lax–Friedrichs numerical flux
-/

namespace NumStability

/-- Lax–Friedrichs flux: centered physical flux minus the scaled state jump. -/
noncomputable def leveque04_laxFriedrichsFlux {m : ℕ}
    (timeStep cellWidth : ℝ)
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (left right : Fin m → ℝ) : Fin m → ℝ :=
  leveque04_centeredFlux physicalFlux left right -
    (cellWidth / (2 * timeStep)) • (right - left)

end NumStability
