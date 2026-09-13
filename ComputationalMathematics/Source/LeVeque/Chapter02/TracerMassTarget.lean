/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TracerMassModel

/-!
# The defining proposition for LeVeque's segment tracer mass

This statement specifies the physical model and the admissible integral domain
for equation (2.1), printed page 15 (PDF page 37). It is a definition
correspondence, with no temporal conservation conclusion.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.1) on its explicit physical model domain. -/
def massDefinitionTarget : Prop :=
  ∀ (volumetricDensity : ℝ → ℝ → ℝ) (area : ℝ → ℝ) (a b t : ℝ)
    (h : AdmissibleSegment volumetricDensity area a b t),
    physicalSectionMass volumetricDensity area a b t h =
      ∫ x in a..b, linearDensity volumetricDensity area x t

end NumStability.Leveque02Tracer
