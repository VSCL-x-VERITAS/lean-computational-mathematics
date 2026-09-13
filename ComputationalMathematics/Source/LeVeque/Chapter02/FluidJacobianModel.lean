/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidStateFluxModel
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.LinearAlgebra.Matrix.ToLin

/-!
# Conserved-coordinate gas-flux matrix

The displayed matrix is used at nonzero mass coordinate and an actual pressure
slope. Its derivative interpretation is imposed by the separate target.
-/

namespace NumStability.Leveque02Tracer

/-- The displayed gas-flux Jacobian in conserved coordinates. -/
noncomputable def fluidFluxJacobian (state : Fin 2 → ℝ) (pressureSlope : ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  !![0, 1; -(state 1) ^ 2 / (state 0) ^ 2 + pressureSlope, 2 * state 1 / state 0]

end NumStability.Leveque02Tracer
