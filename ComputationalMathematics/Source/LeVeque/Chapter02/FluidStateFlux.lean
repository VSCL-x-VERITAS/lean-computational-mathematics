/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidStateFluxTarget

/-!
# Physical and conserved fluid flux coordinates

At positive density, the quotient form of the momentum flux reduces to its
physical-coordinate form.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.40) in the source's positive-density physical domain. -/
theorem fluidStateFlux_eq : fluidStateFluxTarget := by
  intro pressureLaw density velocity hDensity
  have hDensityNe : density ≠ 0 := ne_of_gt hDensity
  simp only [fluidConservedState, fluidStateFlux, Matrix.cons_val_zero,
    Matrix.cons_val_one]
  have hquot : density * velocity * (density * velocity) / density =
      density * velocity * velocity := by
    rw [mul_div_assoc, mul_div_cancel_left₀ _ hDensityNe]
  rw [hquot]
  exact ⟨trivial, trivial, rfl⟩

end NumStability.Leveque02Tracer
