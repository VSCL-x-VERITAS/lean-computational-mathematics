/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.AcousticsEigenvalues
import ComputationalMathematics.Source.LeVeque.Chapter02.SoundSpeedFormulaTarget

/-!
# Acoustic sound-speed formula
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.55), reusing the already integrated Chapter 1 acoustic-speed
producer for the same book. -/
theorem soundSpeedFormula : soundSpeedFormulaTarget := by
  intro bulkModulus density hbulkModulus hdensity
  have hacoustics :=
    NumStability.leveque01_acousticsMatrixEigenvalues hbulkModulus hdensity
  exact ⟨Real.sqrt (bulkModulus / density), rfl, hacoustics.1⟩

end NumStability.Leveque02Tracer
