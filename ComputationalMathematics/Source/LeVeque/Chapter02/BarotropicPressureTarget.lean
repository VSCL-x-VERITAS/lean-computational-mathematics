/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.BarotropicPressureModel

/-!
# Density-only equation of state

Equation (2.36) evaluates the prescribed pressure law at the actual density.
The derivative-sign requirement of (2.37) is a separate model assumption.
-/

namespace NumStability.Leveque02Tracer

/-- Pressure in the chosen density-only model is the pressure law at density. -/
def barotropicPressureTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (density : ℝ → ℝ → ℝ) (x t : ℝ),
    barotropicPressure pressureLaw density x t = pressureLaw (density x t)

end NumStability.Leveque02Tracer
