/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticImpedanceTarget

/-!
# Acoustic impedance
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.59), using the source-independent acoustic-impedance
definition and positivity of a product of positive real parameters. -/
theorem acousticImpedanceFormula : acousticImpedanceTarget := by
  intro density soundSpeed hdensity hsoundSpeed
  refine ⟨NumStability.acousticImpedance density soundSpeed, rfl, rfl, ?_⟩
  exact mul_pos hdensity hsoundSpeed

end NumStability.Leveque02Tracer
