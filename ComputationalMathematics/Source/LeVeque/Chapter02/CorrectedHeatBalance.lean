/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.CorrectedHeatBalanceTarget

/-!
# Corrected integral heat balance sign

The Fourier model and the existing conservation endpoint convention yield
the positive bracket of conductivity times temperature gradient.
-/

namespace NumStability.Leveque02Tracer

/-- Rewrite the conserving energy rate using the corrected endpoint bracket. -/
theorem correctedHeatBalance : correctedHeatBalanceTarget := by
  intro temperature capacity conductivity gradient a b t _hab _hint _hgradient
  have hsign :
      fourierHeatFlux (conductivity a) (gradient a) -
          fourierHeatFlux (conductivity b) (gradient b) =
        conductivity b * gradient b - conductivity a * gradient a := by
    simp only [fourierHeatFlux]
    ring
  rw [hsign]

end NumStability.Leveque02Tracer
