/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.DomainStateFluxTarget

/-!
# Physical and conserved fluid flux coordinates

Use ordinary nonzero-density cancellation within the supplied constitutive
law domain to identify the two flux forms.
-/

namespace NumStability.Leveque02Tracer

/-- The source flux coordinates agree on the defined nonzero density domain. -/
theorem domainStateFlux : domainStateFluxTarget := by
  intro densityDomain pressureLaw density velocity hρ
  simp only [fluidConservedState, domainFluidStateFlux, Matrix.cons_val_zero,
    Matrix.cons_val_one]
  have hquot : (density : ℝ) * velocity * ((density : ℝ) * velocity) / density =
      (density : ℝ) * velocity * velocity := by
    rw [mul_div_assoc, mul_div_cancel_left₀ _ hρ]
  rw [hquot]
  exact ⟨trivial, trivial, rfl⟩

end NumStability.Leveque02Tracer
